//
//  Constants.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

let UDM = UserDefaultsManager.shared

let colorArray: [UIColor] = [.systemRed, .systemOrange,
                            .systemYellow, .systemGreen,
                            .systemTeal, .systemBlue,
                            .systemIndigo, .systemPurple,
                            .systemPink, .systemGray]

let soundArray: [Int16] = [1327,
                         1328,
                         1329,
                         1330,
                         1331,
                         1332,
                         1333,
                         1334,
                         1335,
                         1336]

let defaultSeconds: [Int32] = [3,5,10,20,25,30,40,45,50,60]

enum Colors {
    static let f6f6f6                    = UIColor(hex: "#f6f6f6")
}

enum Fonts {
    static var AvenirNextRegular         = "AvenirNext-Regular"
    static var AvenirNextDemiBold        = "AvenirNext-DemiBold"
    static var AvenirNextMedium          = "AvenirNext-Medium"
    static var AvenirNextBold            = "AvenirNext-Bold"
}
