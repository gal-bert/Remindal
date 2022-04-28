//
//  Helper.swift
//  Remindal
//
//  Created by Gregorius Albert on 26/04/22.
//

import Foundation

class Helper {
    
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
