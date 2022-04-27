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
        var h = reminder?.hour!
        var m = reminder?.minute!
        timepicker.date = dateFormatter.date(from: "\(h!):\(m!)")!
        
        reminderTextfield.text = reminder!.label
    }

    
    @IBAction func update(_ sender: Any) {
        
        let tfh = DateFormatter()
        tfh.dateFormat = "HH"
        let time_h = tfh.string(from: timepicker.date)
        
        let tfm = DateFormatter()
        tfm.dateFormat = "mm"
        let time_m = tfm.string(from: timepicker.date)
        
        do {
            let context = appDelegate.persistentContainer.viewContext
            
            reminder?.isOn = true
            reminder?.label = reminderTextfield.text
            reminder?.hour = time_h
            reminder?.minute = time_m
            reminder?.monday = true
            reminder?.tuesday = true
            reminder?.wednesday = true
            reminder?.thursday = true
            reminder?.friday = true
            reminder?.saturday = true
            reminder?.sunday = true

            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
        performSegue(withIdentifier: "unwindToHome", sender: self)
        
    }
    
}
