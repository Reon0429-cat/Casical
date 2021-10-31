//
//  UITextField+Extension.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

extension UITextField {
    
    func roundCorners() {
        self.borderStyle = .none
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth  = 0
        self.layer.masksToBounds = true
    }
    
    func setUnderLine() {
        self.borderStyle = .none
        let underline = UIView()
        underline.frame = CGRect(x: 0,
                                 y: self.frame.height,
                                 width: self.frame.width,
                                 height: 1)
        underline.backgroundColor = .darkColor
        self.addSubview(underline)
        self.bringSubviewToFront(underline)
    }
    
}

