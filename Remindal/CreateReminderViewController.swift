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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func setRepeat(_ sender: Any) {
        performSegue(withIdentifier: "toDaysRepeatSegue", sender: self)
    }
    
    @IBAction func save(_ sender: Any) {
        
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        print(time)
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        
        // TODO: Create day repeats function
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            let reminder = Reminder(context: context)
            
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
            
            context.insert(reminder)
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
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
