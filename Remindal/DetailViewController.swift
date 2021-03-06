//
//  DetailViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 26/04/22.
//

import UIKit

class DetailViewController: UIViewController, RefreshDataDelegate {
    
    @IBOutlet weak var timepicker: UIDatePicker!
    @IBOutlet weak var reminderTextfield: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var reminder:Reminder?
    
    var isUpdating:Bool = false
    
    var t_h = ""
    var t_m = ""
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let h = reminder?.hour!
        let m = reminder?.minute!
        timepicker.date = dateFormatter.date(from: "\(h!):\(m!)")!
        
        reminderTextfield.text = reminder!.label
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDaysRepeatSegue" {
            let dest = segue.destination as! RepeatModalViewController
            dest.reminder = reminder
            dest.viewDelegate = self
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
        //TODO: Add Sound on notify
        
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
    
    func refreshData() {
        tableView.reloadData()
    }
    
    func fetchDays() -> String {
        var temp = ""
        var daysCount = 0
        var weekdayCount = 0
        var weekendCount = 0
        if reminder!.monday == true {
            temp.append(" Mon")
            daysCount += 1
            weekdayCount += 1
        }
        if reminder!.tuesday == true{
            temp.append(" Tue")
            daysCount += 1
            weekdayCount += 1
        }
        if reminder!.wednesday == true {
            temp.append(" Wed")
            daysCount += 1
            weekdayCount += 1
        }
        if reminder!.thursday == true {
            temp.append(" Thu")
            daysCount += 1
            weekdayCount += 1
        }
        if reminder!.friday == true {
            temp.append(" Fri")
            daysCount += 1
            weekdayCount += 1
        }
        if reminder!.saturday == true {
            temp.append(" Sat")
            daysCount += 1
            weekendCount += 1
        }
        if reminder!.sunday == true {
            temp.append(" Sun")
            daysCount += 1
            weekendCount += 1
        }
        
        temp = String(temp.dropFirst())
        
        if daysCount == 7 {
            temp = "Everyday"
        } else if weekdayCount == 5 && weekendCount == 0{
            temp = "Every Weekday"
        } else if weekendCount == 2 && weekdayCount == 0{
            temp = "Every Weekend"
        }
        
        return temp
    }
    
    @IBAction func textFieldDidEndOnExit(_ sender: Any) {
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = "Repeat"
        cell?.detailTextLabel?.text = fetchDays()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        performSegue(withIdentifier: "toDaysRepeatSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
