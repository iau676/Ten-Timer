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
    var timerArray = [TenTimer]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    mutating func appendItem(_ number: Int) {
        let newTimer = TenTimer(context: self.context)
        newTimer.date = Date()
        newTimer.uuid = UUID()
        newTimer.totalSeconds = defaultSeconds[number]
        newTimer.timerNumber = Int16(number)
        newTimer.soundInt = Int16(number)
        newTimer.colorInt = Int16(number)
        newTimer.isVibrate = true
        newTimer.isCountdownSpeech = false
        newTimer.countdownSpeechType = 0
        newTimer.countdownType = 0
        newTimer.alertType = 0
        newTimer.title = ""
        newTimer.subtitle = ""
        saveItems()
    }
    
    func updateTimerSound(timer: TenTimer, newSoundInt: Int) {
        timer.soundInt = Int16(newSoundInt)
        saveItems()
    }
    
    func updateTimerTotalSeconds(timer: TenTimer, newTotalSeconds: Int) {
        timer.totalSeconds = Int32(newTotalSeconds)
        saveItems()
    }
    
    func updateTimerTitle(timer: TenTimer, newTitle: String) {
        timer.title = newTitle
        saveItems()
    }
    
    mutating func loadTimers(with request: NSFetchRequest<TenTimer> = TenTimer.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "timerNumber", ascending: true)]
            timerArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    func saveItems() {
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
