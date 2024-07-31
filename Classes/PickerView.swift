//
//  PickerView.swift
//  Befiler
//
//  Created by Sanjay on 21/12/2021.
//  Copyright © 2021 Haseeb. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

protocol ToolbarPickerViewDelegate: AnyObject {//class
    func didTapDone()
    func didTapCancel()
}

class ToolbarPickerView: UIPickerView {

    public var title : String = "Title"
    public private(set) var toolbar: UIToolbar?
    public weak var toolbarDelegate: ToolbarPickerViewDelegate?
    public var pickerTitle : UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    
    public func createLabel(text : String){
        self.title = text
        self.commonInit()
    }
    
    private func commonInit() {
        let toolBar = UIToolbar()
        
        pickerTitle = UILabel(frame: .zero) //UILabel(frame: CGRect(x: 0, y: 0, width: (toolbar?.frame.width ?? 0) / 3, height: 30))
        pickerTitle.text = title //title//"title"
        pickerTitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        pickerTitle.textColor = UIColor.lightGray
        pickerTitle.textAlignment = .center
        pickerTitle.backgroundColor = .clear
        
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.primary //.black
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(self.doneTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let  titleLabel = UIBarButtonItem(customView: pickerTitle)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(self.cancelTapped))

        toolBar.setItems([cancelButton, spaceButton, titleLabel, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        self.toolbar = toolBar
    }

    @objc func doneTapped() {
        self.toolbarDelegate?.didTapDone()
    }

    @objc func cancelTapped() {
        self.toolbarDelegate?.didTapCancel()
    }
}
