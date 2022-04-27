//
//  RepeatModalViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 27/04/22.
//

import UIKit

class RepeatModalViewController: UIViewController {
    
    var arrDays = Helper.repeatDaysFeeder()
    
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
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrDays.count
    }
    
}
