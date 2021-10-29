//
//  CustomTextField.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

final class CustomTextField: UITextField {
    
    private let padding = UIEdgeInsets(top: 0,
                                       left: 15,
                                       bottom: 0,
                                       right: 15)
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
}
