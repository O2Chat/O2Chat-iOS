//
//  CustomOutlineTextField.swift
//  befiler
//
//  Created by Sanjay on 03/01/2022.
//  Copyright © 2022 Haseeb. All rights reserved.
//

import Foundation
import UIKit

//import MaterialComponents.MaterialTextFields
//import MaterialComponents.MaterialTextControls_OutlinedTextFields
//
//class CustomOutlinedTxtField: UIView {
//
//    private var textFieldControllerFloating: MDCTextInputControllerOutlined!
//    var textField: MDCTextField!
//
//    @IBInspectable var placeHolder: String!
//    @IBInspectable var value: String!
//    @IBInspectable var primaryColor: UIColor! = .purple
//
//    override open func draw(_ rect: CGRect) {
//        super.draw(rect)
//
//        textField.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
//
//    }
//    open override func awakeFromNib() {
//        super.awakeFromNib()
//        setUpProperty()
//    }
//    func setUpProperty() {
//        //Change this properties to change the propperties of text
//        textField = MDCTextField(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
//        textField.placeholder = placeHolder
//        textField.text = value
//
//        //Change this properties to change the colors of border around text
//        textFieldControllerFloating = MDCTextInputControllerOutlined(textInput: textField)
//
//        textFieldControllerFloating.activeColor = primaryColor
//        textFieldControllerFloating.floatingPlaceholderActiveColor = primaryColor
//        textFieldControllerFloating.normalColor = UIColor.lightGray
//        textFieldControllerFloating.inlinePlaceholderColor = UIColor.lightGray
//
//        //Change this font to make borderRect bigger
//        textFieldControllerFloating.inlinePlaceholderFont = UIFont.systemFont(ofSize: 14)
//        textFieldControllerFloating.textInsets(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
//
//        self.addSubview(textField)
//    }
//}
extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
}

class NMTextField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.paste(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
extension UITextField {
    func placeholderColor(color: UIColor) {
        let attributeString = [
            NSAttributedString.Key.foregroundColor: color.withAlphaComponent(1),
            NSAttributedString.Key.font: self.font!
        ] as [NSAttributedString.Key : Any]
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder!, attributes: attributeString)
    }
}
