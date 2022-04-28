//
//  Reminder+CoreDataProperties.swift
//  Remindal
//
//  Created by Gregorius Albert on 28/04/22.
//
//

import Foundation
import CoreData


extension Reminder {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reminder> {
        return NSFetchRequest<Reminder>(entityName: "Reminder")
    }

    @NSManaged public var friday: Bool
    @NSManaged public var hour: String?
    @NSManaged public var isOn: Bool
    @NSManaged public var label: String?
    @NSManaged public var minute: String?
    @NSManaged public var monday: Bool
    @NSManaged public var saturday: Bool
    @NSManaged public var sunday: Bool
    @NSManaged public var thursday: Bool
    @NSManaged public var tuesday: Bool
    @NSManaged public var wednesday: Bool
    @NSManaged public var uuidString: String?

}

extension Reminder : Identifiable {

}
