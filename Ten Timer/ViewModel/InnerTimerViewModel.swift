//
//  InnerTimerViewModel.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 20.02.2023.
//

import UIKit

struct InnerTimerViewModel {
    
    var innerTimer: InnerTimer
    
    var title: String {
        return innerTimer.title ?? "Title"
    }
    
    var totalSecondsStr: String {
        return "\(TT.shared.getTimeString(Int(innerTimer.seconds)))"
    }
    
    var color: UIColor {
        let hex = colorArray[Int(innerTimer.colorInt)].hex
        return UIColor(hex: "#\(hex)") ?? .darkGray
    }
    
    var soundName: String {
        let name = soundArray[Int(innerTimer.soundInt)].name
        return name
    }
    
    var seconds: Int64 {
        return innerTimer.seconds
    }
    
    var timerNumber: Int {
        return Int(innerTimer.timerNumber)
    }
    
    init(innerTimer: InnerTimer) {
        self.innerTimer = innerTimer
    }
    
}
