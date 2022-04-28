//
//  RepeatModalTableViewCell.swift
//  Remindal
//
//  Created by Gregorius Albert on 27/04/22.
//

import UIKit

class RepeatModalTableViewCell: UITableViewCell {
    
    var reminder:Reminder?
    var repeatDays:RepeatDays?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func toggle(_ sender: Any) {
        let context = appDelegate.persistentContainer.viewContext
        
        if repeatDays?.days == "Monday" {
            reminder?.monday = toggle.isOn
        }
        else if repeatDays?.days == "Tuesday" {
            reminder?.tuesday = toggle.isOn
        }
        else if repeatDays?.days == "Wednesday" {
            reminder?.wednesday = toggle.isOn
        }
        else if repeatDays?.days == "Thursday" {
            reminder?.thursday = toggle.isOn
        }
        else if repeatDays?.days == "Friday" {
            reminder?.friday = toggle.isOn
        }
        else if repeatDays?.days == "Saturday" {
            reminder?.saturday = toggle.isOn
        }
        else if repeatDays?.days == "Sunday" {
            reminder?.sunday = toggle.isOn
        }
        
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
}
