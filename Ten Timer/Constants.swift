//
//  Constants.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

let UDM = UserDefaultsManager.shared

var colorArray = [Color]()
var soundArray = [Sound]()

let defaultSeconds: [Int64] = [30,45,60,90,120,300,600,1200,3600,5400]

let hours = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23]

let minutes = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]

let seconds = [00,01,02,03,04,05,06,07,08,09,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59]

enum Colors {
    static let f6f6f6                    = UIColor(hex: "#f6f6f6")
}

enum Images {
    static let dots                      = UIImage(named: "dots")
    static let mute                      = UIImage(named: "mute")
    static let notification              = UIImage(named: "notification")
}

enum Fonts {
    static var AvenirNextRegular         = "AvenirNext-Regular"
    static var AvenirNextDemiBold        = "AvenirNext-DemiBold"
    static var AvenirNextMedium          = "AvenirNext-Medium"
    static var AvenirNextBold            = "AvenirNext-Bold"
}
