//
//  Player.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 16.02.2023.
//

import Foundation
import AVFoundation

struct Player {
    
    static var shared = Player()
    private var player: AVAudioPlayer!
    
    mutating func play(withId soundName: String) {
        let url = Bundle.main.url(forResource: "\(soundName)", withExtension: "m4a")
        player = try! AVAudioPlayer(contentsOf: url!)
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
         print(error)
        }
        player.play()
    }
    
    mutating func play(sound: Sound) {
        if sound.seconds > 0 {
            play(withId: "\(sound.id)")
        } else {
            if sound.id == "1002" {
                AudioServicesPlayAlertSound(SystemSoundID(1002))
            }
        }
    }
    
    func stopSound() {
        guard let player = player else { return }
        player.stop()
    }
}
