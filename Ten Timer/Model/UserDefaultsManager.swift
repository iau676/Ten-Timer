//
//  UserDefaultsManager.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

struct UserDefaultsManager {
    
    static let shared = UserDefaultsManager()

    let currentVersion = "com.ibrahimuysal.Ten-Timer.currentVersion"
    let currentNotificationDate = "com.ibrahimuysal-Ten-Timer.currentNotificationDate"
    let currentTimerCounter = "com.ibrahimuysal-Ten-Timer.currentTimerCounter"
    let lastTimerCounter = "com.ibrahimuysal-Ten-Timer.lastTimerCounter"
    let currentTimer = "com.ibrahimuysal-Ten-Timer.currentTimer"
    let selectedTimerIndex = "com.ibrahimuysal-Ten-Timer.selectedTimerIndex"
    let fromInner = "com.ibrahimuysal-Ten-Timer.fromInner"
    let isVibrate = "com.ibrahimuysal-Ten-Timer.isVibrate"
    
    func getCGFloatValue(_ key: String) -> CGFloat {
       return CGFloat(UserDefaults.standard.integer(forKey: key))
    }
    
    func getBoolValue(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    func getIntValue(_ key: String) -> Int {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    func getStringValue(_ key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    func getDateValue(_ key: String) -> Date? {
        return UserDefaults.standard.object(forKey: key) as? Date
    }
    
    func setValue( _ value: Any, _ key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
