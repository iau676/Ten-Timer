//
//  InnerTimerCell.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 20.02.2023.
//

import UIKit

protocol InnerTimerCellDelegate: AnyObject {
    func settingsPressed(index: Int)
}

class InnerTimerCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var innerTimer: InnerTimer? {
        didSet { configure() }
    }
    
    weak var delegate: InnerTimerCellDelegate?
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 17)
        label.textColor = .white
        return label
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.f6f6f6
        button.setDimensions(height: 26, width: 26)
        button.layer.cornerRadius = 26 / 2
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        return button
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 25)
        label.textColor = .white
        return label
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 15)
        label.textColor = .white
        return label
    }()
    
    lazy var soundLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = .white
        return label
    }()

    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)

        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor,
                           paddingTop: 12, paddingLeft: 12)
        
        contentView.addSubview(settingsButton)
        settingsButton.anchor(top: topAnchor, right: rightAnchor,
                              paddingTop: 12, paddingRight: 12)
        
        contentView.addSubview(timeLabel)
        timeLabel.centerY(inView: self)
        timeLabel.centerX(inView: self)
      
        contentView.addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          paddingLeft: 16, paddingBottom: 18)
        
        contentView.addSubview(soundLabel)
        soundLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          paddingLeft: 16, paddingBottom: 4)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func settingsPressed() {
        guard let innerTimer = innerTimer else { return }
        delegate?.settingsPressed(index: Int(innerTimer.timerNumber))
    }
    
    //MARK: - Helpers
    
    func configureTimerNumber(timer: TTimer, number: Int) {
        guard let innerTimer = innerTimer else { return }
        TT.shared.updateInnerTimerNumber(innerTimer: innerTimer, number: number)
        numberLabel.text = "\(timer.timerNumber+1).\(number+1)"
    }
    
    func configure() {
        guard let innerTimer = innerTimer else { return }
        let viewModel = InnerTimerViewModel(innerTimer: innerTimer)

        titleLabel.text = showTitle() ? viewModel.title : ""
        timeLabel.text = viewModel.totalSecondsStr
        soundLabel.text = viewModel.soundName
        contentView.backgroundColor = viewModel.color
        
        settingsButton.setImageWithRenderingMode(image: UIImage(named: "dots"),
                                                 width: 15, height: 15,
                                                 color: viewModel.color)
    }
    
    private func showTitle() -> Bool {
        let width = self.frame.width
        let height = self.frame.height
        
        if width > 5*height {
            return false
        } else {
            return true
        }
    }
}
