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
            // Light
            static let primary = UIColor(red: 148/255, green: 94/255, blue: 252/255, alpha: 1.0) //#945EFC
            static let barColor = UIColor.black
            static let barText = UIColor(red: 148/255, green: 94/255, blue: 252/255, alpha: 1.0) //#945EFC
            static let header = UIColor.black
            static let background = UIColor.black
            static let contentBackground = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1.0) //#212529
            static let contentBackgroundLight = UIColor(red: 67/255, green: 75/255, blue: 83/255, alpha: 1.0) //#434B53
            static let selected = UIColor.black
            static let text = UIColor.white
            
            static let progressbar = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1.0) //#212529
//            static let progressbar = UIColor(red: 116/255, green: 125/255, blue: 134/255, alpha: 1.0) //#747D86
            static let positive = UIColor(red: 106/255, green: 191/255, blue: 2/255, alpha: 1.0) //#6ABF02
            static let positiveLight = UIColor(red: 180/255, green: 223/255, blue: 128/255, alpha: 1.0) //#B4DF80
//            static let positive = UIColor(red: 43/255, green: 0/255, blue: 255/255, alpha: 1.0) //#2B00FF
//            static let positiveLight = UIColor(red: 0/255, green: 146/255, blue: 255/255, alpha: 1.0) //#0092FF
            static let negative = UIColor(red: 191/255, green: 2/255, blue: 106/255, alpha: 1.0) //#bf026a
            static let negativeLight = UIColor(red: 252/255, green: 0/255, blue: 126/255, alpha: 1.0) //#fc0080
            
            static let grayUltraLight = UIColor(red: 200/255, green: 200/255, blue: 200/255, alpha: 1.0) //#C8C8C8
            static let grayLight = UIColor(red: 100/255, green: 100/255, blue: 100/255, alpha: 1.0) //#646464
            static let grayMedium = UIColor(red: 58/255, green: 58/255, blue: 58/255, alpha: 1.0) //#3A3A3A
            static let grayDark = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0) //#262626
        }
        
        // Dark
//        static let barStyle: UIBarStyle = .black
//        static let navBarBackground = UIColor(red: 12/255, green: 12/255, blue: 12/255, alpha: 1.0) //#1F1F1F
//        static let navBarText = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) //#FFF
//        static let background = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0) //#262626
//        static let text = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1.0) //#FFF
    }
    
    static func gradientColor(color1: UIColor, color2: UIColor, percent: Double) -> UIColor {
        let resultRed: CGFloat = color1.rgba.red + CGFloat(percent) * (color2.rgba.red - color1.rgba.red);
        let resultGreen: CGFloat = color1.rgba.green + CGFloat(percent) * (color2.rgba.green - color1.rgba.green);
        let resultBlue: CGFloat = color1.rgba.blue + CGFloat(percent) * (color2.rgba.blue - color1.rgba.blue);
        return UIColor(red: resultRed, green: resultGreen, blue: resultBlue, alpha: 1.0)
    }
}
