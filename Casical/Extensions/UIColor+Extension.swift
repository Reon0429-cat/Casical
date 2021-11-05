//
//  UIColor+Extension.swift
//  Casical
//
//  Created by 大西玲音 on 2021/10/29.
//

import UIKit

extension UIColor {
    
    static var lightColor: UIColor {
        UserDefaults.standard.loadColor(.lightColor)
        ?? UIColor(named: "lightColor")!
    }
    
    static var darkColor: UIColor {
        UserDefaults.standard.loadColor(.darkColor)
        ?? UIColor(named: "darkColor")!
    }
    
    static var moreLightColor: UIColor {
        UserDefaults.standard.loadColor(.moreLightColor)
        ?? UIColor(named: "moreLightColor")!
    }
    
    static var moreDarkColor: UIColor {
        UserDefaults.standard.loadColor(.moreDarkColor)
        ?? UIColor(named: "moreDarkColor")!
    }
    
    static var mostLightColor: UIColor {
        UserDefaults.standard.loadColor(.mostLightColor)
        ?? UIColor(named: "mostLightColor")!
    }
    
    static var pieChartColor1: UIColor {
        .darkColor
    }
    
    static var pieChartColor2: UIColor {
        UIColor(hex: "D4A9F3")
    }
    
    static var pieChartColor3: UIColor {
        UIColor(hex: "D8C7F8")
    }
    
    static var horizontalChartColor1: UIColor {
        .darkColor
    }
    
    static var horizontalChartColor2: UIColor {
        .darkColor.withAlphaComponent(0.9)
    }
    
    static var horizontalChartColor3: UIColor {
        .darkColor.withAlphaComponent(0.75)
    }
    
    static var horizontalChartColor4: UIColor {
        .darkColor.withAlphaComponent(0.6)
    }
    
    static var horizontalChartColor5: UIColor {
        .darkColor.withAlphaComponent(0.5)
    }
    
}

extension UIColor {
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let v = Int("000000" + hex, radix: 16) ?? 0
        let r = CGFloat(v / Int(powf(256, 2)) % 256) / 255
        let g = CGFloat(v / Int(powf(256, 1)) % 256) / 255
        let b = CGFloat(v / Int(powf(256, 0)) % 256) / 255
        self.init(red: r, green: g, blue: b, alpha: min(max(alpha, 0), 1))
    }
    
}
