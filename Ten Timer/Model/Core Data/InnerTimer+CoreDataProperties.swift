//
//  InnerTimer+CoreDataProperties.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 20.02.2023.
//
//

import Foundation
import CoreData


extension InnerTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<InnerTimer> {
        return NSFetchRequest<InnerTimer>(entityName: "InnerTimer")
    }

    @NSManaged public var colorInt: Int64
    @NSManaged public var date: Date?
    @NSManaged public var seconds: Int64
    @NSManaged public var soundInt: Int64
    @NSManaged public var title: String?
    @NSManaged public var uuid: UUID?
    @NSManaged public var isVibrate: Bool
    @NSManaged public var timerNumber: Int64
    @NSManaged public var tTimer: TTimer?

    public var unwrappedDate: Date {
        date ?? Date()
    }
}

extension InnerTimer : Identifiable {

}
