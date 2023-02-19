//
//  TTimer+CoreDataProperties.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 19.02.2023.
//
//

import Foundation
import CoreData


extension TTimer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TTimer> {
        return NSFetchRequest<TTimer>(entityName: "TTimer")
    }

    @NSManaged public var alertType: Int16
    @NSManaged public var colorInt: Int16
    @NSManaged public var countdownSpeechType: Int16
    @NSManaged public var countdownType: Int16
    @NSManaged public var date: Date?
    @NSManaged public var isBasic: Bool
    @NSManaged public var isCountdownSpeech: Bool
    @NSManaged public var isVibrate: Bool
    @NSManaged public var soundInt: Int16
    @NSManaged public var subtitle: String?
    @NSManaged public var timerNumber: Int16
    @NSManaged public var title: String?
    @NSManaged public var totalSeconds: Int32
    @NSManaged public var uuid: UUID?
    @NSManaged public var innerTimers: NSSet?
    
    public var innerTimerArray: [InnerTimer] {
        let innerTimersSet = innerTimers as? Set<InnerTimer> ?? []
        
        return innerTimersSet.sorted {
            $0.unwrappedDate < $1.unwrappedDate
        }
    }

}

// MARK: Generated accessors for innerTimers
extension TTimer {

    @objc(addInnerTimersObject:)
    @NSManaged public func addToInnerTimers(_ value: InnerTimer)

    @objc(removeInnerTimersObject:)
    @NSManaged public func removeFromInnerTimers(_ value: InnerTimer)

    @objc(addInnerTimers:)
    @NSManaged public func addToInnerTimers(_ values: NSSet)

    @objc(removeInnerTimers:)
    @NSManaged public func removeFromInnerTimers(_ values: NSSet)

}

extension TTimer : Identifiable {

}
