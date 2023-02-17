//
//  Factories.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 17.02.2023.
//

import UIKit

func makeLabel(withText text: String, size: CGFloat = 17, color: UIColor = .label) -> UILabel {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false // important!
    label.textAlignment = .left
    label.numberOfLines = 0
    label.text = text
    label.textColor = color
    label.font = UIFont.systemFont(ofSize: size)
    
    return label
}

func makePaddingLabel(withText text: String) -> UILabel {
    let label = UILabelPadding()
    label.translatesAutoresizingMaskIntoConstraints = false // important!
    label.textAlignment = .left
    label.numberOfLines = 0
    label.text = text
    label.font = UIFont.systemFont(ofSize: 17)
    
    return label
}


class UILabelPadding: UILabel {
    let padding = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: padding))
    }

    override var intrinsicContentSize : CGSize {
        let superContentSize = super.intrinsicContentSize
        let width = superContentSize.width + padding.left + padding.right
        let heigth = superContentSize.height + padding.top + padding.bottom
        return CGSize(width: width, height: heigth)
    }
}

func makeButton(withText text: String, backgroundColor: UIColor = .systemGray4) -> UIButton {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle(text, for: .normal)
    button.titleLabel?.adjustsFontSizeToFitWidth = true
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 16)
    button.backgroundColor = backgroundColor
    button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
    button.setTitleColor(.label, for: .normal)
    button.contentHorizontalAlignment = .left
    button.layer.cornerRadius = 8
    
    return button
}

func makeSwitch(isOn: Bool) -> UISwitch {
    let theSwitch = UISwitch()
    theSwitch.translatesAutoresizingMaskIntoConstraints = false
    theSwitch.isOn = isOn

    return theSwitch
}
