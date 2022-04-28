//
//  Helper.swift
//  Remindal
//
//  Created by Gregorius Albert on 26/04/22.
//

import Foundation
import UIKit

class Helper {
    
    static func pushAlert(title:String, message:String) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .cancel,
            handler: nil)
        )
        
        return alert
    }
    
    static func repeatDaysFeeder() -> [RepeatDays] {
        
        let monday = RepeatDays(days: "Monday", isOn: true)
        let tuesday = RepeatDays(days: "Tuesday", isOn: true)
        let wednesday = RepeatDays(days: "Wednesday", isOn: true)
        let thursday = RepeatDays(days: "Thursday", isOn: true)
        let friday = RepeatDays(days: "Friday", isOn: true)
        let saturday = RepeatDays(days: "Saturday", isOn: true)
        let sunday = RepeatDays(days: "Sunday", isOn: true)
        
        return [monday, tuesday, wednesday, thursday, friday, saturday, sunday]
        
    }
    
}
