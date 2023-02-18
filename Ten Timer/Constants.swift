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

let defaultSeconds: [Int32] = [3,5,10,20,25,30,40,45,6550,130]

enum Colors {
    static let f6f6f6                    = UIColor(hex: "#f6f6f6")
}

enum Fonts {
    static var AvenirNextRegular         = "AvenirNext-Regular"
    static var AvenirNextDemiBold        = "AvenirNext-DemiBold"
    static var AvenirNextMedium          = "AvenirNext-Medium"
    static var AvenirNextBold            = "AvenirNext-Bold"
}
