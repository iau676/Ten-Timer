//
//  TimerViewModel.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

struct TimerViewModel {
    
    var timer: TenTimer
    
    var colorName: UIColor {
        return colorArray[Int(timer.colorInt)]
    }
    
    var soundName: Int16 {
        return soundArray[Int(timer.soundInt)]
    }
    
    var seconds: Int32 {
        return timer.totalSeconds
    }
    
    init(timer: TenTimer) {
        self.timer = timer
    }
    
}
