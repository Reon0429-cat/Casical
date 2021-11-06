//
//  UserDefaults+Extension.swift
//  Casical
//
//  Created by 大西玲音 on 2021/11/06.
//

import UIKit

enum ThemeColorType: String {
    case lightColor
    case darkColor
    case moreLightColor
    case moreDarkColor
    case mostLightColor
}

extension UserDefaults {
    
    func loadColor(_ themeColorType: ThemeColorType) -> UIColor? {
        guard let colorData = self.data(forKey: themeColorType.rawValue),
              let color = try! NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(colorData) as? UIColor
        else { return nil }
        return color
    }
    
    func save(color: UIColor?, themeColorType: ThemeColorType) {
        let colorData = try! NSKeyedArchiver.archivedData(withRootObject: color as Any,
                                                          requiringSecureCoding: false) as NSData?
        self.set(colorData, forKey: themeColorType.rawValue)
    }
    
}

