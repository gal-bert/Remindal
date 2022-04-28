//
//  DetailViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 26/04/22.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var timepicker: UIDatePicker!
    @IBOutlet weak var reminderTextfield: UITextField!
    
    var reminder:Reminder?
    
    var isUpdating:Bool = false
    
    var t_h = ""
    var t_m = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //TODO: Initiliaze repeat label (Everyday, Weekday, Weekends)
    //TODO: Refine UI component for set repeat days
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let h = reminder?.hour!
        let m = reminder?.minute!
        timepicker.date = dateFormatter.date(from: "\(h!):\(m!)")!
        
        reminderTextfield.text = reminder!.label
    }
    

    @IBAction func setRepeat(_ sender: Any) {
        performSegue(withIdentifier: "toDaysRepeatSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDaysRepeatSegue" {
            let dest = segue.destination as! RepeatModalViewController
            dest.reminder = reminder
        }
    }
    
    @IBAction func update(_ sender: Any) {
                
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        t_h = time_h
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        t_m = time_m
        
        let labelData = reminderTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        if labelData == "" || labelData == nil {
            present(Helper.pushAlert(title: "Hey!", message: "Your reminder label can't be empty!"), animated: true)
        }
        else {
            do {
                let context = appDelegate.persistentContainer.viewContext
                
                reminder?.label = reminderTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines)
                reminder?.hour = time_h
                reminder?.minute = time_m
                
                try context.save()
            }
            catch {
                print(error.localizedDescription)
            }
            
            let center = UNUserNotificationCenter.current()
            var notificationToRemove = [String]()
            for i in 1...7 {
                notificationToRemove.append("\(reminder!.uuidString!)-\(i)")
            }
            center.removePendingNotificationRequests(withIdentifiers: notificationToRemove)
            
            checkDaysRepeat()
            performSegue(withIdentifier: "unwindToHome", sender: self)
        }
    }
    
    @IBAction func deleteReminder(_ sender: Any) {
        
        let alert = UIAlertController(
            title: "Are you sure?",
            message: "Are you sure to delete this reminder?",
            preferredStyle: .actionSheet
        )
        
        alert.addAction(UIAlertAction(
            title: "Delete",
            style: .destructive,
            handler: {_ in
                let context = self.appDelegate.persistentContainer.viewContext
                do{
                    context.delete(self.reminder!)
                    try context.save()
                }
                catch {
                    print(error.localizedDescription)
                }
                self.performSegue(withIdentifier: "unwindToHome", sender: self)
            }
        ))
        
        alert.addAction(UIAlertAction(
            title: "Cancel",
            style: .cancel,
            handler: nil
        ))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func checkDaysRepeat() {
        /// Gregorian Calendar
        /// Weekday 1 starts on Sunday
        if reminder?.monday == true {
            registerNotification(weekday: 2)
        }
        if reminder?.tuesday == true{
            registerNotification(weekday: 3)
        }
        if reminder?.wednesday == true {
            registerNotification(weekday: 4)
        }
        if reminder?.thursday == true {
            registerNotification(weekday: 5)
        }
        if reminder?.friday == true {
            registerNotification(weekday: 6)
        }
        if reminder?.saturday == true {
            registerNotification(weekday: 7)
        }
        if reminder?.sunday == true {
            registerNotification(weekday: 1)
        }
    }
    
    func registerNotification(weekday:Int) -> Void {
        let content = UNMutableNotificationContent()
        content.title = "Hey, it's \(t_h):\(t_m)!"
        content.body = "\(reminderTextfield!.text!)"
        
        var dc = DateComponents()
        dc.weekday = weekday
        dc.hour = Int(t_h)
        dc.minute = Int(t_m)
        let date = Calendar(identifier: .gregorian).date(from: dc)
        
        var dateComponents = Calendar.current.dateComponents([.hour, .minute], from: date!)
        dateComponents.weekday = weekday
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(
            identifier: "\(reminder!.uuidString!)-\(weekday)",
            content: content,
            trigger: trigger
        )
        
        let center = UNUserNotificationCenter.current()
        center.add(request){ (error) in
            
        }
        print(dc)
        print(dateComponents)
        print("\(reminder!.uuidString!)-\(weekday)\n")
        
    }
    
}
