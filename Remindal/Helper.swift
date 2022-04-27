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
    
//    static func remindalFeeder() -> [Remindal] {
//        
//        var array = [Remindal]()
//        
//        let remindal  = Remindal(title: "Drink Water", detail: "Drink enough water plz", isOn: true)
//        let remindal2 = Remindal(title: "Eat Cheezes", detail: "Cheeze 4 lyf is loveee", isOn: false)
//        let remindal3 = Remindal(title: "Spray Wotah", detail: "Wotah is H2O much love", isOn: true)
//        
//        array.append(remindal)
//        array.append(remindal2)
//        array.append(remindal3)
//        
//        return array
//        
//    }
    
}
