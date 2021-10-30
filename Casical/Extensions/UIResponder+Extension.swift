//
//  UIResponder+Extension.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

extension UIResponder {
    
    var isMac: Bool {
      #if targetEnvironment(macCatalyst)
        return true
      #else
        return false
      #endif
    }
    
}
