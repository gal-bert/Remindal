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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
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
        
        // TODO: Validate empty textfield
        
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            
            reminder?.label = reminderTextfield.text
            reminder?.hour = time_h
            reminder?.minute = time_m

            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
        performSegue(withIdentifier: "unwindToHome", sender: self)
        
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
    
    
    
}
