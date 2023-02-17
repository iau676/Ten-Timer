//
//  Sound.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 17.02.2023.
//

import Foundation

struct Sound {
    var id: String
    var name: String
    var seconds: Int
    var selected: Bool
}

extension Sound {
    init?(dictionary: [String: Any]) {
        guard let id = dictionary["id"] as? String,
              let name = dictionary["name"] as? String,
              let seconds = dictionary["seconds"] as? Int else {
            return nil
        }
        
        self.id = id
        self.name = name
        self.seconds = seconds
        self.selected = false
    }
}
