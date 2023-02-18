//
//  SoundCell.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 16.02.2023.
//

import UIKit

class SoundCell: UITableViewCell {
    
    //MARK: - Properties
    
    var sound: Sound? {
        didSet { configure() }
    }
    
    private let secondsLabel = makeLabel(withText: "", size: 15, color: .darkGray)
    private let nameLabel = makeLabel(withText: "")
    private let checkLabel = makeLabel(withText: "", color: .blue)
    
    //MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(secondsLabel)
        secondsLabel.anchor(left: leftAnchor, paddingLeft: 16)
        secondsLabel.centerY(inView: self)
        
        addSubview(nameLabel)
        nameLabel.anchor(left: secondsLabel.rightAnchor, paddingLeft: 4)
        nameLabel.centerY(inView: self)
        
        addSubview(checkLabel)
        checkLabel.anchor(right: rightAnchor, paddingRight: 16)
        checkLabel.centerY(inView: self)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let sound = sound else { return }
        
        nameLabel.text = sound.name
        secondsLabel.text = "0:\(sound.seconds) ・"
        checkLabel.text = "\(sound.selected ? "✓" : "")"
    }
}
