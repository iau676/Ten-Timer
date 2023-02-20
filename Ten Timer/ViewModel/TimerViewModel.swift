//
//  TimerViewModel.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

struct TimerViewModel {
    
    var timer: TTimer
    
    var totalSecondsStr: String {
        return "\(TT.shared.getTimeString(Int(timer.totalSeconds)))"
    }
    
    var color: UIColor {
        let hex = colorArray[Int(timer.innerTimerArray[0].colorInt)].hex
        return UIColor(hex: "#\(hex)") ?? .darkGray
    }
    
    var seconds: Int64 {
        return timer.totalSeconds
    }
    
    var title: String {
        return timer.title ?? ""
    }
    
    init(timer: TTimer) {
        self.timer = timer
    }
    
}
