//
//  RemindalsTableViewCell.swift
//  Remindal
//
//  Created by Gregorius Albert on 26/04/22.
//

import UIKit


class RemindalsTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var toggle: UISwitch!
    
    var reminder:Reminder?
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
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
        do{
            reminder?.isOn = toggle.isOn
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        
    }
    
}
