//
//  TimerCell.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

protocol TimerCellDelegate: AnyObject {
    func settingsPressed(_ timer: TTimer)
}

class TimerCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var timer: TTimer? {
        didSet { configure() }
    }
    
    weak var delegate: TimerCellDelegate?
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 25)
        label.textColor = .white
        return label
    }()
    
    private lazy var numberButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 19)
        button.backgroundColor = .clear
        button.setDimensions(height: 25, width: 25)
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = Colors.f6f6f6
        button.setDimensions(height: 26, width: 26)
        button.layer.cornerRadius = 26 / 2
        return button
    }()
    
    private lazy var hiddenButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setDimensions(height: 50, width: 50)
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        return button
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 15)
        label.textColor = .white
        return label
    }()
    
    private var subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.textColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .systemPurple
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(timeLabel)
        timeLabel.centerY(inView: self)
        timeLabel.centerX(inView: self)
        
        contentView.addSubview(settingsButton)
        settingsButton.anchor(top: topAnchor, right: rightAnchor,
                              paddingTop: 12, paddingRight: 12)
        
        contentView.addSubview(hiddenButton)
        hiddenButton.anchor(top: topAnchor, right: rightAnchor)
        
        contentView.addSubview(numberButton)
        numberButton.anchor(top: topAnchor, left: leftAnchor,
                              paddingTop: 12, paddingLeft: 12)
        
        contentView.addSubview(titleLabel)
        titleLabel.anchor(left: leftAnchor, bottom: bottomAnchor, right: rightAnchor,
                          paddingLeft: 16, paddingBottom: 18, paddingRight: 16)
        
        contentView.addSubview(subtitleLabel)
        subtitleLabel.anchor(left: leftAnchor, bottom: bottomAnchor,
                          paddingLeft: 16, paddingBottom: 4)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc private func settingsPressed() {
        guard let timer = timer else { return }
        delegate?.settingsPressed(timer)
    }
    
    //MARK: - Helpers
    
    private func configure() {
        guard let timer = timer else { return }
        let viewModel = TimerViewModel(timer: timer)
        
        timeLabel.text = "\(viewModel.totalSecondsStr)"
        numberButton.setTitle("\(timer.timerNumber+1)", for: .normal)
        contentView.backgroundColor = viewModel.color
        
        settingsButton.setImageWithRenderingMode(image: Images.dots,
                                                 width: 15, height: 15,
                                                 color: viewModel.color)
        
        titleLabel.text = showTitle() ? viewModel.title : ""
        subtitleLabel.text = viewModel.subtitle
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
