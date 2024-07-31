//
//  Colors.swift
//  User
//
//  Created by imac on 12/22/17.
//  Copyright © 2017 Appoets. All rights reserved.
//

import UIKit

enum Color : Int {
    
    case primary = 1
    case secondary = 2
    case lightBlue = 3
    case brightBlue = 4
    case greyBorder = 5
    case toolbarColor = 6
    case greenColor = 7
    case greyCustomColor = 8
    case customBlue = 9
    case transparentBlack = 10
    case transactionBGColor = 11
    case imageNotSelectColor = 12
    case whiteDull = 13
    case paymentcellBG = 14
    case textColorPayLater = 15
    case paymentMethodBg = 16
    case textColor = 17
    case redBorderColor = 18

    


    

    
    
    static func valueFor(id : Int)->UIColor?{
        
        switch id {
        case self.primary.rawValue:
            return .primary
        
        case self.secondary.rawValue:
            return .secondary
            
        case self.lightBlue.rawValue:
            return .lightBlue
        
        case self.brightBlue.rawValue:
            return .brightBlue
            
        case self.greyBorder.rawValue:
            return .greyBorder
        case self.toolbarColor.rawValue:
            return .toolbarColor
        case self.greenColor.rawValue:
            return .greenColor
        case self.greyCustomColor.rawValue:
            return .greyCustomColor
        case self.customBlue.rawValue:
            return .customBlue
        case self.transparentBlack.rawValue:
            return .transparentBlack
        case self.transactionBGColor.rawValue:
            return .transactionBGColor
        case self.imageNotSelectColor.rawValue:
            return .imageNotSelectColor
        case self.whiteDull.rawValue:
            return .whiteDull
        case self.paymentcellBG.rawValue:
            return .paymentcellBG
        case self.textColorPayLater.rawValue:
            return .textColorPayLater
        case self.paymentMethodBg.rawValue:
            return .paymentMethodBg
        case self.textColor.rawValue:
            return .textColor
        case self.redBorderColor.rawValue:
            return .redBorderColor
        default:
            return nil
        }
        
        
    }
    
    
}

extension UIColor {
    //Message
    static var bgMessage : UIColor {
//        return #colorLiteral(red: 0.5843137255, green: 0.4549019608, blue: 0.8039215686, alpha: 1) //UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
        return UIColor(rgb: 0xD9ECFD)


    }
    
    // Primary Color
    static var primary : UIColor {
//        return #colorLiteral(red: 0.5843137255, green: 0.4549019608, blue: 0.8039215686, alpha: 1) //UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
        return UIColor(red: 187/255, green: 24/255, blue: 35/255, alpha: 1)
    }
    
    // Secondary Color
    static var secondary : UIColor {
//        return #colorLiteral(red: 0.9333333333, green: 0.3843137255, blue: 0.568627451, alpha: 1) // UIColor(red: 238/255, green: 98/255, blue: 145/255, alpha: 1)
        return UIColor(red: 34/255, green: 34/255, blue: 34/255, alpha: 1)
    }
    
    // Secondary Color
    static var rating : UIColor {
        return #colorLiteral(red: 0.9921568627, green: 0.7882352941, blue: 0.1568627451, alpha: 1) //UIColor(red: 238/255, green: 98/255, blue: 145/255, alpha: 1)
    }
    
    // Secondary Color
    static var lightBlue : UIColor {
        return UIColor(red: 38/255, green: 118/255, blue: 188/255, alpha: 1)
    }
    
    static var underLineBlue : UIColor {
//        return #colorLiteral(red: 0.5843137255, green: 0.4549019608, blue: 0.8039215686, alpha: 1) //UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
        return UIColor(red: 25/255, green: 136/255, blue: 241/255, alpha: 1)
    }
    // text Color
    static var textColor : UIColor {
//        return #colorLiteral(red: 0.5843137255, green: 0.4549019608, blue: 0.8039215686, alpha: 1) //UIColor(red: 149/255, green: 116/255, blue: 205/255, alpha: 1)
        return UIColor(red: 130/255, green: 143/255, blue: 162/255, alpha: 1)
    }
    
    //Gradient Start Color
    
    static var startGradient : UIColor {
        return UIColor(red: 83/255, green: 173/255, blue: 46/255, alpha: 1)
    }
    
    //Gradient End Color
    
    static var endGradient : UIColor {
        return UIColor(red: 158/255, green: 178/255, blue: 45/255, alpha: 1)
    }
    
    // Blue Color
    
    static var brightBlue : UIColor {
        return UIColor(red: 40/255, green: 25/255, blue: 255/255, alpha: 1)
    }
    
    static var lightDisclaimerOrange : UIColor {
        return UIColor(red: 235/255, green: 100/255, blue: 101/255, alpha: 1)
    }
    
    static var lightDisclaimerBlue : UIColor {
        return UIColor(red: 27/255, green: 145/255, blue: 208/255, alpha: 1)
    }
    
    static var greyBorder : UIColor {
        return UIColor(red: 145/255, green: 145/255, blue: 155/255, alpha: 1)
    }
    
    static var toolbarColor : UIColor {
        return UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    
    static var greenColor : UIColor {
        return UIColor(red: 17/255, green: 132/255, blue: 70/255, alpha: 1)
    }
    
    static var greyCustomColor : UIColor {
        return UIColor(red: 96/255, green: 96/255, blue: 96/255, alpha: 1)
    }
    
    static var customBlue : UIColor {
        return UIColor(red: 9/255, green: 144/255, blue: 211/255, alpha: 1)
    }
    
    static var transparentBlack : UIColor {
        return UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    }
    
    static var transactionBGColor : UIColor {
        return UIColor(red: 236/255, green: 242/255, blue: 247/255, alpha: 0.5)
    }
    
    static var taxViewBGColor : UIColor {
        return UIColor(red: 248/255, green: 250/255, blue: 251/255, alpha: 0.5)
    }
    static var imageNotSelectColor : UIColor {
        return UIColor(red: 249/255, green: 236/255, blue: 236/255, alpha: 0.5)
    }
    
    static var whiteDull : UIColor {
        return UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 0.5)
    }
    
    static var paymentcellBG : UIColor {
        return UIColor(red: 236/255, green: 242/255, blue: 247/255, alpha: 0.75)
    }
    static var textColorPayLater : UIColor {
        return UIColor(red: 66/255, green: 129/255, blue: 164/255, alpha: 0.5)
    }
    static var paymentMethodBg : UIColor {
        return UIColor(red: 250/255, green: 239/255, blue: 239/255, alpha: 0.5)
    }
    
    static func rgb(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
    
    static var customBlueColor : UIColor {
        return UIColor(red: 4/255, green: 42/255, blue: 79/255, alpha: 1)
    }
    
    static var categoriesBGColor : UIColor {
        return UIColor(rgb: 0x66FAEEEE)
        //return UIColor(red: 253/255, green: 247/255, blue: 248/255, alpha: 1)
    }
    
    static var categoriesUrlColor : UIColor {
        return UIColor(rgb: 0x316CF4)
        //return UIColor(red: 253/255, green: 247/255, blue: 248/255, alpha: 1)
    }
    
    static var menuBGColor : UIColor {
        return UIColor(rgb: 0xFAEEEF)
        //return UIColor(red: 250/255, green: 239/255, blue: 239/255, alpha: 1)
    }
    
    static var customNewBlue : UIColor {
        return UIColor(red: 23/255, green: 128/255, blue: 220/255, alpha: 1)
    }
    
    static var customNewPrimary : UIColor {
        return UIColor(red: 213/255, green: 37/255, blue: 48/255, alpha: 1)
    }
    
    static var customNewGray : UIColor {
        return UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1)
    }
    
    static var customNewNavBar : UIColor {
        return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static var  redBorderColor : UIColor {
        return UIColor(red: 244/255.0, green: 67/255.0, blue: 54/255.0, alpha: 1)
    }
    
    static var customTabBarBG : UIColor {
        return UIColor(rgb: 0xfad8a4)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static var redGradient1 : UIColor {
        return UIColor(rgb: 0xE85849)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    static var redGradient2 : UIColor {
        return UIColor(rgb: 0xE41E27)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    static var redGradient3 : UIColor {
        return UIColor(rgb: 0xCF242C)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    //MARK: Pie Chart Colors
    static var em_listColor1 : UIColor {
        return UIColor(rgb: 0x2bca8b)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_listColor2 : UIColor {
        return UIColor(rgb: 0x0097ff)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_listColor3 : UIColor {
        return UIColor(rgb: 0xfa4f5b)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_listColor4 : UIColor {
        return UIColor(rgb: 0xffc300)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_listColor5 : UIColor {
        return UIColor(rgb: 0x99a6b9)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_listColor6 : UIColor {
        return UIColor(rgb: 0x0795ad)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    static var em_color_five : UIColor {
        return UIColor(rgb: 0x7bbe39)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static var em_bg_screen4 : UIColor {
        return UIColor(rgb: 0xc873f4)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }
    
    static var em_dot_dark_screen3 : UIColor {
        return UIColor(rgb: 0x002954)
        //return UIColor(red: 255.0/255.0, green: 255.0/255.0, blue: 255.0/255.0, alpha: 1)
    }

    
    
    
    
    
    static let backgroundColor = UIColor.rgb(r: 21, g: 22, b: 33)
    static let outlineStrokeColor = UIColor.rgb(r: 234, g: 46, b: 111)
    static let trackStrokeColor = UIColor.rgb(r: 56, g: 25, b: 49)
    static let pulsatingFillColor = UIColor.rgb(r: 86, g: 30, b: 63)
    
    
}
extension UIColor {
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
}
