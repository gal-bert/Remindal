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
        
        if toggle.isOn == false {
            let center = UNUserNotificationCenter.current()
            var notificationToRemove = [String]()
            for i in 1...7 {
                notificationToRemove.append("\(reminder!.uuidString!)-\(i)")
            }
            center.removePendingNotificationRequests(withIdentifiers: notificationToRemove)
        }
        else {
            checkDaysRepeat()
        }
        
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
        content.title = "Hey, it's \(reminder!.hour!):\(reminder!.minute!)!"
        content.body = "\(reminder!.label!)"
        
        var dc = DateComponents()
        dc.weekday = weekday
        dc.hour = Int(reminder!.hour!)
        dc.minute = Int(reminder!.minute!)
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
