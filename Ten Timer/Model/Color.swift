//
//  Color.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 18.02.2023.
//

import Foundation

struct Color {
    var id: Int
    var hex: String
    var selected: Bool
}

extension Color {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? Int,
              let hex = dictionary["hex"] as? String else {
            return nil
        }
        
        self.id = id
        self.hex = hex
        self.selected = false
    }
}
