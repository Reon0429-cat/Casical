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
    
}
