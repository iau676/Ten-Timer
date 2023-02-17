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
    
    func moveImageRight(){
        let imageSize: CGSize = self.imageView?.image?.size ?? CGSize(width: 25, height: 25)
        let buttonWidth = self.bounds.width
        self.imageEdgeInsets = UIEdgeInsets(top: 0, left: buttonWidth-(imageSize.width+16), bottom: 0, right: 0)
        self.contentHorizontalAlignment = .left
        self.imageView?.contentMode = .scaleAspectFit
    }
    
}
