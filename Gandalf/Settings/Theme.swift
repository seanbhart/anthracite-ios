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
        // Light
        static let barStyle: UIBarStyle = .black
//        static let colorPrimary = UIColor(red: 15/255, green: 67/255, blue: 246/255, alpha: 1.0) //#0f43f6
//        static let colorPrimaryLight = UIColor(red: 22/255, green: 122/255, blue: 251/255, alpha: 1.0) //#167afb
        static let colorPrimary = UIColor(red: 43/255, green: 0/255, blue: 255/255, alpha: 1.0) //#2B00FF
        static let colorPrimaryLight = UIColor(red: 0/255, green: 146/255, blue: 255/255, alpha: 1.0) //#0092FF
        static let colorSecondary = UIColor(red: 191/255, green: 2/255, blue: 106/255, alpha: 1.0) //#bf026a
        static let colorSecondaryLight = UIColor(red: 252/255, green: 0/255, blue: 126/255, alpha: 1.0) //#fc0080
        static let navBarBackground = UIColor.black
        static let navBarText = UIColor.white
        static let background = UIColor.black
        static let text = UIColor.white
        static let colorGrayUltraLight = UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1.0) //#CCC
        static let colorGrayLight = UIColor(red: 204/255, green: 204/255, blue: 204/255, alpha: 1.0) //#CCC
        static let colorGrayMedium = UIColor(red: 81/255, green: 81/255, blue: 81/255, alpha: 1.0) //#515151
        static let colorGrayDark = UIColor(red: 38/255, green: 38/255, blue: 38/255, alpha: 1.0) //#262626
        
        static let colorGandalfDark = UIColor(red: 33/255, green: 37/255, blue: 41/255, alpha: 1.0) //#212529
        static let colorGandalfLight = UIColor(red: 73/255, green: 80/255, blue: 87/255, alpha: 1.0) //#495057
        
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
