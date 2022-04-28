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
        print(time)
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        
        // TODO: Validate empty textfield
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            
            reminderToSend!.label = reminderTextField.text
            reminderToSend!.hour = time_h
            reminderToSend!.minute = time_m
            
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
        isCreating = true
        performSegue(withIdentifier: "unwindToHome", sender: self)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
