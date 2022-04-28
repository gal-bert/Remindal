//
//  ViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 25/04/22.
//

import UIKit
import UserNotifications

class HomeViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var reminderToSend:Reminder?
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrRemindals = [Reminder]()

    // TODO: Push notification 😭😭😭😭
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(
            options: [.alert, .sound],
            completionHandler: {
                (grant, error) in
                // empty
            }
        )
        
        navigationController?.navigationBar.prefersLargeTitles = true
        self.title = "Your Reminders"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.rowHeight = 70
        
        fetchData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchData()
    }
    
    func fetchData() -> Void {
        let context = appDelegate.persistentContainer.viewContext
        
        do{
            let reminders = Reminder.fetchRequest()
            let result = try context.fetch(reminders)
            arrRemindals = result
        }
        catch {
            print(error.localizedDescription)
        }
        tableView.reloadData()
    }
    

    @IBAction func unwindToHome(_ unwindSegue: UIStoryboardSegue) {
        let sourceViewController = unwindSegue.source
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RemindalsTableViewCell
        let remindal = arrRemindals[indexPath.row]
        
        var temp = ""
        var daysCount = 0
        var weekdayCount = 0
        var weekendCount = 0
        if remindal.monday == true {
            temp.append(" Mon")
            daysCount += 1
            weekdayCount += 1
        }
        if remindal.tuesday == true{
            temp.append(" Tue")
            daysCount += 1
            weekdayCount += 1
        }
        if remindal.wednesday == true {
            temp.append(" Wed")
            daysCount += 1
            weekdayCount += 1
        }
        if remindal.thursday == true {
            temp.append(" Thu")
            daysCount += 1
            weekdayCount += 1
        }
        if remindal.friday == true {
            temp.append(" Fri")
            daysCount += 1
            weekdayCount += 1
        }
        if remindal.saturday == true {
            temp.append(" Sat")
            daysCount += 1
            weekendCount += 1
        }
        if remindal.sunday == true {
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

        cell.titleLabel.text = remindal.label
        cell.subtitleLabel.text = "\(temp) - \(remindal.hour!):\(remindal.minute!)"
        cell.toggle.isOn = remindal.isOn
        cell.reminder = remindal
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrRemindals.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.isSelected = false
        reminderToSend = arrRemindals[indexPath.row]
        performSegue(withIdentifier: "goToDetailSegue", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            do{
                
                let center = UNUserNotificationCenter.current()
                var notificationToRemove = [String]()
                for i in 1...7 {
                    notificationToRemove.append("\(arrRemindals[indexPath.row].uuidString!)-\(i)")
                }
                center.removePendingNotificationRequests(withIdentifiers: notificationToRemove)
                
                let context = appDelegate.persistentContainer.viewContext
                context.delete(arrRemindals[indexPath.row])
                try context.save()
                fetchData()
                
            }
            catch {
                print(error.localizedDescription)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToDetailSegue" {
            let dest = segue.destination as! DetailViewController
            dest.reminder = reminderToSend
        }
    }
    
    
}

