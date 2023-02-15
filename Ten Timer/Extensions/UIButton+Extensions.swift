//
//  UIButton+Extensions.swift
//  Ten Timer
//
//  Created by ibrahim uysal on 13.02.2023.
//

import UIKit

extension UIButton {
    
    func setImageWithRenderingMode(image: UIImage?, width: CGFloat, height: CGFloat, color: UIColor){
        let image = image?.withRenderingMode(.alwaysTemplate).imageResized(to: CGSize(width: width, height: height)).withTintColor(color)
        self.setImage(image, for: .normal)
    }
    
}
