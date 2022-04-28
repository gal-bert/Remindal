//
//  CreateReminderViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 27/04/22.
//

import UIKit

class CreateReminderViewController: UIViewController {

    @IBOutlet weak var timepicker: UIDatePicker!
    @IBOutlet weak var reminderTextField: UITextField!
    
    var reminderToSend:Reminder?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var isCreating:Bool = false
    
    var t_h = ""
    var t_m = ""
    
    //TODO: Initiliaze repeat label (Everyday, Weekday, Weekends)
    //TODO: Refine UI component for set repeat days
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let context = appDelegate.persistentContainer.viewContext
        let reminder = Reminder(context: context)
        
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        
        reminder.isOn = true
        reminder.label = reminderTextField.text
        reminder.hour = time_h
        reminder.minute = time_m
        reminder.monday = true
        reminder.tuesday = true
        reminder.wednesday = true
        reminder.thursday = true
        reminder.friday = true
        reminder.saturday = true
        reminder.sunday = true
        reminder.uuidString = UUID().uuidString
        
        do {
            context.insert(reminder)
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
        reminderToSend = reminder
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if !isCreating {
            let context = appDelegate.persistentContainer.viewContext
            do{
                context.delete(reminderToSend!)
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    @IBAction func setRepeat(_ sender: Any) {
        performSegue(withIdentifier: "toDaysRepeatSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDaysRepeatSegue" {
            let dest = segue.destination as! RepeatModalViewController
            dest.reminder = reminderToSend
        }
    }
    
    @IBAction func save(_ sender: Any) {
        
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        t_h = time_h
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        t_m = time_m
        
        
        let labelData = reminderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if labelData == "" || labelData == nil {
            present(Helper.pushAlert(title: "Hey!", message: "Your reminder label can't be empty!"), animated: true)
        } else {
            do {
                let context = appDelegate.persistentContainer.viewContext
                
                reminderToSend!.label = reminderTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                reminderToSend!.hour = time_h
                reminderToSend!.minute = time_m
                
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
        
            
            isCreating = true
            checkDaysRepeat()
            performSegue(withIdentifier: "unwindToHome", sender: self)
        }
        
    }
    
    func checkDaysRepeat() {
        /// Gregorian Calendar
        /// Weekday 1 starts on Sunday
        if reminderToSend?.monday == true {
            registerNotification(weekday: 2)
        }
        if reminderToSend?.tuesday == true{
            registerNotification(weekday: 3)
        }
        if reminderToSend?.wednesday == true {
            registerNotification(weekday: 4)
        }
        if reminderToSend?.thursday == true {
            registerNotification(weekday: 5)
        }
        if reminderToSend?.friday == true {
            registerNotification(weekday: 6)
        }
        if reminderToSend?.saturday == true {
            registerNotification(weekday: 7)
        }
        if reminderToSend?.sunday == true {
            registerNotification(weekday: 1)
        }
    }
    
    func registerNotification(weekday:Int) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "Hey, it's \(t_h):\(t_m)!"
        content.body = "\(reminderTextField!.text!)"
        
        var dc = DateComponents()
        dc.weekday = weekday
        dc.hour = Int(t_h)
        dc.minute = Int(t_m)
        let date = Calendar(identifier: .gregorian).date(from: dc)
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date!)
        dateComponents.weekday = weekday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "\(reminderToSend!.uuidString!)-\(weekday)",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
            
        }
        print(dc)
        print(dateComponents)
        print("\(reminderToSend!.uuidString!)-\(weekday)\n")
        
    }


}
