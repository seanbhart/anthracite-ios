//
//  Assets.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit

struct Assets {
    
    struct Icons {
        static let iconOrdering = UIImage(systemName: "dollarsign.circle")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        static let iconOrderingFill = UIImage(systemName: "dollarsign.circle.fill")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        static let iconUp = UIImage(systemName: "arrowtriangle.up")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        static let iconUpFill = UIImage(systemName: "arrowtriangle.up.fill")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        static let iconDown = UIImage(systemName: "arrowtriangle.down")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        static let iconDownFill = UIImage(systemName: "arrowtriangle.down.fill")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
    }
    
    struct Images {
        static let notionIconWhiteSm: String = "STAR-WHITE-SM.png"
        static let notionIconWhiteLg: String = "STAR-WHITE-LG.png"
        static let notionIconGraySm: String = "STAR-GRAY-SM.png"
        static let notionIconGrayLg: String = "STAR-GRAY-LG.png"
        static let notionIconPosSm: String = "STAR-GREEN-SM.png"
        static let notionIconPosLg: String = "STAR-GREEN-LG.png"
        static let notionIconNegSm: String = "STAR-PINK-SM.png"
        static let notionIconNegLg: String = "STAR-PINK-LG.png"
        
        static let hatIconPurpleLg: String = "HAT-PURPLE-LG.png"
        static let hatIconWhiteSm: String = "HAT-WHITE-SM.png"
        static let hatIconWhiteLg: String = "HAT-WHITE-LG.png"
        
        static let topIconGraySm: String = "STARS-GRAY-SM.png"
        static let topIconGrayLg: String = "STARS-GRAY-LG.png"
        static let topIconPurpleLg: String = "STARS-PURPLE-LG.png"
        static let topIconWhiteLg: String = "STARS-WHITE-LG.png"
        
        static let logotypeLg: String = "LOGOTYPE-LG.png"
        static let logotype: String = "LOGOTYPE.png"
    }
    
    struct Fonts {
        
        struct Default {
            static let black = "SourceSansPro-Black"
            static let bold = "SourceSansPro-Bold"
            static let semiBold = "SourceSansPro-SemiBold"
//            static let medium = "Exo-Medium"
            static let regular = "SourceSansPro-Regular"
            static let light = "SourceSansPro-Light"
        }
    }
}
