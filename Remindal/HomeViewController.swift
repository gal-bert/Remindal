//
//  ViewController.swift
//  Remindal
//
//  Created by Gregorius Albert on 25/04/22.
//

import UIKit

class HomeViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var reminderToSend:Reminder?
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrRemindals = [Reminder]()

    // TODO: Push notification 😭😭😭😭
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
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
        

        cell.titleLabel.text = remindal.label
        cell.subtitleLabel.text = "\(remindal.hour!):\(remindal.minute!)"
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

