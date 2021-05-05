//
//  Colors.swift
//  Slate
//
//  Created by Sean Hart on 1/19/21.
//  Copyright © 2021 TangoJ Labs, LLC All rights reserved.
//

import Foundation
import UIKit

extension Settings {
    
//    Dark Blue - #0f43f6 = 15, 67, 246
//    Light Blue - #167afb = 22, 122, 251
//    Dark Pink - #bf026a = 191, 2, 106
//    Light Pink - #fc0080 = 252, 0, 126
    
    struct Theme {
        static let barStyle: UIBarStyle = .black
        
        struct Color {
            static let barColor = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0) //#121212
            static let barText = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) //#FFF
            static let header = UIColor(red: 18/255, green: 18/255, blue: 18/255, alpha: 1.0) //#121212
            static let background = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0) //#292929
            static let contentBackground = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.05) //#FFF
            static let outline = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.6) //#FFF
            static let selected = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) //#FFF
            static let text = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) //#FFF
            static let textGrayLight = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7) //#FFF
            static let textGrayMedium = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) //#FFF
            static let textGrayDark = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3) //#FFF
            static let textGrayUltraDark = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1) //#FFF
            static let textGrayTrueDark = UIColor(red: 41/255, green: 41/255, blue: 41/255, alpha: 1.0) //#292929
            
//            static let primary = UIColor(red: 148/255, green: 94/255, blue: 252/255, alpha: 1.0) //#945EFC
            static let primary = UIColor(red: 187/255, green: 134/255, blue: 252/255, alpha: 1.0) //#BB86FC
            static let primaryLight = UIColor(red: 187/255, green: 134/255, blue: 252/255, alpha: 1.0) //#BB86FC
            static let progressbar = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1.0) //#212529
//            static let progressbar = UIColor(red: 116/255, green: 125/255, blue: 134/255, alpha: 1.0) //#747D86
//            static let positive = UIColor(red: 106/255, green: 191/255, blue: 2/255, alpha: 1.0) //#6ABF02
            static let positive = UIColor(red: 3/255, green: 218/255, blue: 197/255, alpha: 0.7) //#03DAC5
            static let positiveLight = UIColor(red: 180/255, green: 223/255, blue: 128/255, alpha: 1.0) //#B4DF80
//            static let positive = UIColor(red: 43/255, green: 0/255, blue: 255/255, alpha: 1.0) //#2B00FF
//            static let positiveLight = UIColor(red: 0/255, green: 146/255, blue: 255/255, alpha: 1.0) //#0092FF
            static let negative = UIColor(red: 223/255, green: 111/255, blue: 151/255, alpha: 0.7) //#DF6F97
            static let negativeLight = UIColor(red: 252/255, green: 0/255, blue: 126/255, alpha: 1.0) //#fc0080
            
            static let grayUltraLight = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8) //#FFF
            static let grayLight = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.7) //#FFF
            static let grayMedium = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5) //#FFF
            static let grayDark = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.3) //#FFF
            static let grayUltraDark = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.1) //#FFF
        }
    }
    
    static func gradientColor(color1: UIColor, color2: UIColor, percent: Double) -> UIColor {
        let resultRed: CGFloat = color1.rgba.red + CGFloat(percent) * (color2.rgba.red - color1.rgba.red);
        let resultGreen: CGFloat = color1.rgba.green + CGFloat(percent) * (color2.rgba.green - color1.rgba.green);
        let resultBlue: CGFloat = color1.rgba.blue + CGFloat(percent) * (color2.rgba.blue - color1.rgba.blue);
        return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: 1.0)
    }
}
