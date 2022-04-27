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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Remove this after config ok
        timepicker.addTarget(self, action: #selector(datePickerChanged(picker:)), for: .valueChanged)
    }
    
    @objc func datePickerChanged(picker: UIDatePicker) {
                
        let tf = DateFormatter()
        tf.dateFormat = "HH:mm"
        let time = tf.string(from: picker.date)
        print(time)
        
    }
    
    

}
