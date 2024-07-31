//
//  CustomLabel.swift
//  befiler
//
//  Created by Sanjay on 11/01/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import Foundation
import UIKit

//MARK:-
class PaddingLabel: UILabel {

   @IBInspectable var topInset: CGFloat = 15.0
   @IBInspectable var bottomInset: CGFloat = 15.0
   @IBInspectable var leftInset: CGFloat = 5.0
   @IBInspectable var rightInset: CGFloat = 5.0

   override func drawText(in rect: CGRect) {
      let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
       super.drawText(in: rect.inset(by: insets))
   }

   override var intrinsicContentSize: CGSize {
      get {
         var contentSize = super.intrinsicContentSize
         contentSize.height += topInset + bottomInset
         contentSize.width += leftInset + rightInset
         return contentSize
      }
   }
}


extension NSMutableAttributedString {
    var fontSize:CGFloat { return 10 }
    var boldFont:UIFont { return UIFont(name: "System-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFont:UIFont { return UIFont(name: "System-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    var fontSizePrice:CGFloat { return 12 }
    var boldFontPrice:UIFont { return UIFont(name: "System-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize) }
    var normalFontPrice:UIFont { return UIFont(name: "System-Medium", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
            .foregroundColor : UIColor.black
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normalMedium(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFontPrice,
            .foregroundColor : UIColor.black
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normalMediumGray(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFontPrice,
            .foregroundColor : UIColor.gray
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    /* Other styling methods */
    func orangeHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.orange
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func blackHighlight(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .foregroundColor : UIColor.white,
            .backgroundColor : UIColor.black
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func underlined(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font :  normalFont,
            .underlineStyle : NSUnderlineStyle.single.rawValue
            
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
extension UILabel {
    
//    func decideTextDirection () {
//        let tagScheme = [NSLinguisticTagScheme.language]
//        let tagger    = NSLinguisticTagger(tagSchemes: tagScheme, options: 0)
//        tagger.string = self.text
//        let lang      = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language,
//                                          tokenRange: nil, sentenceRange: nil)
//
//        if lang?.rawValue.range(of: "he") != nil ||  lang?.rawValue.range(of: "ar") != nil || lang?.rawValue.range(of: "ur") != nil {
//            self.textAlignment = NSTextAlignment.right
//        } else {
//            self.textAlignment = NSTextAlignment.left
//        }
//    }
    
    func decideTextDirection () {
        let tagScheme = [NSLinguisticTagScheme.language]
        let tagger    = NSLinguisticTagger(tagSchemes: tagScheme, options: 0)
        tagger.string = self.text //?? "N/A"
        if self.text != ""{
            let lang = tagger.tag(at: 0, scheme: NSLinguisticTagScheme.language,
                                       tokenRange: nil, sentenceRange: nil)
            
            if lang?.rawValue.range(of: "he") != nil ||  lang?.rawValue.range(of: "ar") != nil || lang?.rawValue.range(of: "ur") != nil {
                self.textAlignment = NSTextAlignment.right
            } else {
                self.textAlignment = NSTextAlignment.left
            }
        }
        
        
    }
    
    
}
