//
//  ColorCell.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 17.02.2023.
//

import UIKit

class ColorCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    var color: Color? {
        didSet { configure() }
    }
    
    lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 17)
        label.textColor = .white
        return label
    }()
    
    lazy var checkLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextBold, size: 30)
        label.textColor = .white
        return label
    }()
    
    //MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.backgroundColor = .systemPurple
        
        contentView.addSubview(numberLabel)
        numberLabel.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 8)
        
        contentView.addSubview(checkLabel)
        checkLabel.centerX(inView: contentView)
        checkLabel.centerY(inView: contentView)
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let color = color else { return }
        
        numberLabel.text = "\(color.id)"
        checkLabel.text = "\(color.selected ? "✓" : "")"
        contentView.backgroundColor = UIColor(hex: "#\(color.hex)")
    }
}
