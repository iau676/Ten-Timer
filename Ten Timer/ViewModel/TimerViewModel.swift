//
//  TimerViewModel.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

struct TimerViewModel {
    
    var timer: TenTimer
    
    var totalSecondsStr: String {
        return "\(TT.shared.getTimeString(Int(timer.totalSeconds)))"
    }
    
    var colorName: UIColor {
        return colorArray[Int(timer.colorInt)]
    }
    
    var seconds: Int32 {
        return timer.totalSeconds
    }
    
    var title: String {
        return timer.title ?? ""
    }
    
    init(timer: TenTimer) {
        self.timer = timer
    }
    
}
