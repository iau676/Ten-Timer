//
//  TimerCell.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

protocol TimerCellDelegate: AnyObject {
    func settingsPressed(_ timer: TenTimer)
}

class TimerCell: UICollectionViewCell {
    
    var timer: TenTimer? {
        didSet { configure() }
    }
    
    weak var delegate: TimerCellDelegate?
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 25)
        label.textColor = .white
        return label
    }()
    
    lazy var numberButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 19)
        button.backgroundColor = .clear
        button.setDimensions(height: 25, width: 25)
        return button
    }()
    
    lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.f6f6f6
        button.setDimensions(height: 23, width: 23)
        button.layer.cornerRadius = 23 / 2
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.centerX(inView: self)
        
        contentView.addSubview(settingsButton)
        settingsButton.anchor(top: topAnchor, right: rightAnchor,
                              paddingTop: 12, paddingRight: 12)
        
        contentView.addSubview(numberButton)
        numberButton.anchor(top: topAnchor, left: leftAnchor,
                              paddingTop: 12, paddingLeft: 12)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func settingsPressed() {
        guard let timer = timer else { return }
        delegate?.settingsPressed(timer)
    }
    
    func configure() {
        guard let timer = timer else { return }
        let viewModel = TimerViewModel(timer: timer)
        
        titleLabel.text = "\(viewModel.seconds)"
        numberButton.setTitle("\(timer.timerNumber+1)", for: .normal)
        contentView.backgroundColor = viewModel.colorName
        
        settingsButton.setImageWithRenderingMode(image: UIImage(named: "dots"),
                                                 width: 15, height: 15,
                                                 color: viewModel.colorName)
    }
}
