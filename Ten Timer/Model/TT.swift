//
//  Timer.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit
import CoreData

struct TT {
    
    static var shared = TT()
    var timerArray = [TTimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func appendItem(_ number: Int) {
        let newTimer = TTimer(context: self.context)
        newTimer.date = Date()
        newTimer.uuid = UUID()
        newTimer.totalSeconds = defaultSeconds[number]
        newTimer.timerNumber = Int64(number)
        newTimer.title = ""
        newTimer.subtitle = ""
        
        let newInnerTimer = InnerTimer(context: self.context)
        newInnerTimer.date = Date()
        newInnerTimer.uuid = UUID()
        newInnerTimer.title = "Title\(number+1)"
        newInnerTimer.seconds = Int64(defaultSeconds[number])
        newInnerTimer.colorInt = Int64(number)
        newInnerTimer.soundInt = Int64(number)
        newInnerTimer.timerNumber = Int64(newTimer.innerTimerArray.count)
        newInnerTimer.isVibrate = true
        
        newTimer.addToInnerTimers(newInnerTimer)
        
        saveContext()
    }
    
    mutating func addInnerTimer(timer: TTimer) {
        let timerNumber = Int(timer.timerNumber)
        let innerTimerArrayCount = Int(timer.innerTimerArray.count)
        
        let newInnerTimer = InnerTimer(context: self.context)
        newInnerTimer.date = Date()
        newInnerTimer.uuid = UUID()
        newInnerTimer.title = "Title\(timerNumber+1).\(innerTimerArrayCount+1)"
        newInnerTimer.seconds = defaultSeconds[timerNumber]
        newInnerTimer.colorInt = Int64(timerNumber)
        newInnerTimer.soundInt = Int64(timerNumber)
        newInnerTimer.timerNumber = Int64(timer.innerTimerArray.count)
        newInnerTimer.isVibrate = true
        
        timer.totalSeconds = timer.totalSeconds + defaultSeconds[timerNumber]
        timer.addToInnerTimers(newInnerTimer)
        
        saveContext()
    }
    
    mutating func removeInnerTimer(timer: TTimer, index: Int) {
        timer.totalSeconds -= timer.innerTimerArray[index].seconds
        context.delete(timer.innerTimerArray[index])
        saveContext()
    }
    
    func updateInnerTimerNumber(innerTimer: InnerTimer, number: Int) {
        innerTimer.timerNumber = Int64(number)
        saveContext()
    }
    
    func updateInnerTimerTitle(timer: TTimer, index: Int, newTitle: String) {
        timer.innerTimerArray[index].title = newTitle
        saveContext()
    }
    
    func updateInnerTimerSeconds(timer: TTimer, index: Int, seconds: Int) {
        timer.innerTimerArray[index].seconds = Int64(seconds)
        updateTimerTotalSeconds(timer: timer)
        saveContext()
    }
    
    func updateTimerTotalSeconds(timer: TTimer) {
        var newTotalSeconds = 0
        for i in 0..<timer.innerTimerArray.count {
            newTotalSeconds += Int(timer.innerTimerArray[i].seconds)
        }
        timer.totalSeconds = Int64(newTotalSeconds)
    }
    
    func updateInnerTimerColor(innerTimer: InnerTimer, newColorInt: Int) {
        innerTimer.colorInt = Int64(newColorInt)
        saveContext()
    }
    
    func updateInnerTimerSound(innerTimer: InnerTimer, newSoundInt: Int) {
        innerTimer.soundInt = Int64(newSoundInt)
        saveContext()
    }
    
    mutating func loadTimers(with request: NSFetchRequest<TTimer> = TTimer.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "timerNumber", ascending: true)]
            timerArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func saveContext() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func checkIfThereIsNotification(completion: @escaping(Bool)-> Void) {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            if requests.count > 0 {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    mutating func updateUserDefaultsForTimer() {
        self.loadTimers()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        let timer = self.timerArray[UDM.getIntValue(UDM.selectedTimerIndex)]
        guard let currentNotificationDate = UDM.getDateValue(UDM.currentNotificationDate) else { return }
        let dateComponents = Calendar.current.dateComponents([.second], from: currentNotificationDate, to: Date())
        if let secondsCount = dateComponents.second {
            let totalSeconds = Int(timer.totalSeconds)
            let lastTimeCounter = UDM.getIntValue(UDM.lastTimerCounter)
            UDM.setValue(totalSeconds-(totalSeconds-(secondsCount+lastTimeCounter)), UDM.currentTimerCounter)
        }
    }
    
    func getTimeString(_ second: Int) -> String {
        let hour = second / 3600
        let min = (second - (hour*3600)) / 60
        let sec = second - ((hour*3600)+(min*60))
        
        let hourStr = "\(hour)' "
        let minStr = "\(min)\" "
        let secStr = "\(sec)"
        
        return "\(hour > 0 ? hourStr : "")\(min > 0 ? minStr : "")\(sec > 0 ? secStr : "")"
    }
    
    func getTimeInt(_ second: Int) -> (Int, Int, Int) {
        let hour = second / 3600
        let min = (second - (hour*3600)) / 60
        let sec = second - ((hour*3600)+(min*60))
        
        return (hour, min, sec)
    }
}
