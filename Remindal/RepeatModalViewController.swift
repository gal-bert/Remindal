//
//  RepeatModalViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 27/04/22.
//

import UIKit

class RepeatModalViewController: UIViewController {
    
    var arrDays = Helper.repeatDaysFeeder()
        
    var reminder:Reminder?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        if let presentationController = presentationController as? UISheetPresentationController {
            presentationController.detents = [
                .medium()
            ]
            presentationController.prefersGrabberVisible = true
        }
        
    }
    
}

extension RepeatModalViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RepeatModalTableViewCell
        cell.dayLabel.text = arrDays[indexPath.row].days
        cell.toggle.isOn = arrDays[indexPath.row].isOn
        cell.reminder = reminder
        cell.repeatDays = arrDays[indexPath.row]
        
        let repeatDays = arrDays[indexPath.row].days
        
       
        if repeatDays == "Monday" {
            cell.toggle.isOn = reminder!.monday
        }
        else if repeatDays == "Tuesday" {
            cell.toggle.isOn = reminder!.tuesday
        }
        else if repeatDays == "Wednesday" {
            cell.toggle.isOn = reminder!.wednesday
        }
        else if repeatDays == "Thursday" {
            cell.toggle.isOn = reminder!.thursday
        }
        else if repeatDays == "Friday" {
            cell.toggle.isOn = reminder!.friday
        }
        else if repeatDays == "Saturday" {
            cell.toggle.isOn = reminder!.saturday
        }
        else if repeatDays == "Sunday" {
            cell.toggle.isOn = reminder!.sunday
        }
        
        
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDays.count
    }
    
}
