//
//  CommaNumber.swift
//  Befiler
//
//  Created by Sanjay on 10/06/2022.
//  Copyright © 2022 Haseeb. All rights reserved.
//

import Foundation
import UIKit

class AmountField: UITextField {

private var isFirstDecimal : Bool = true
override func willMove(toSuperview newSuperview: UIView?) {

    addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    keyboardType = .decimalPad
    //textAlignment = .center
    //placeholder = "Amount"
    editingChanged()
}
    
override func deleteBackward() {
    var currentText = self.text ?? ""
    currentText = String(currentText.dropLast())
    self.text = currentText
    editingChanged(self)
}
    
@objc func editingChanged(_ textField: UITextField? = nil) {
    var doubleStr = textField?.text ?? ""


    let decimalCount = doubleStr.components(separatedBy: ".")
    if decimalCount.count > 2 {
        var currentText = self.text ?? ""
        currentText = String(currentText.dropLast())
        self.text = currentText
        return
    }

    if doubleStr.contains(".") && isFirstDecimal == true {
        self.text = doubleStr
        isFirstDecimal = false
        return
    }
    else if !(doubleStr.contains(".")) {
        isFirstDecimal = true
    }

    let doubleStrTemp = doubleStr.replacingOccurrences(of: ",", with: "")

    if doubleStrTemp != "" {
        if let n = Decimal(string: doubleStrTemp )?.significantFractionalDecimalDigits {
            if n > 2 {
                var currentText = self.text ?? ""
                currentText = String(currentText.dropLast())
                self.text = currentText
                return
            }
        }
    }
    doubleStr = doubleStr.replacingOccurrences(of: ",", with: "")

    let doube = Double(doubleStr)
    let numberFormatter = NumberFormatter()
    numberFormatter.numberStyle = NumberFormatter.Style.decimal
    if doube != nil {
        let formattedNumber = numberFormatter.string(from: NSNumber(value:doube!))
        self.text = formattedNumber
    }
}}

extension Decimal {
var significantFractionalDecimalDigits: Int {
    return max(-exponent, 0)
}}
