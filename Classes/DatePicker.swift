//
//  DatePicker.swift
//  befiler
//
//  Created by Sanjay on 04/01/2022.
//  Copyright © 2022 Haseeb. All rights reserved.
//

import Foundation
import UIKit

//protocol DatePickerDelegate: AnyObject { //class
//    func getDate(_ DatePicker:DatePicker, date:String)
//    func cancel(_ DatePicker:DatePicker)
//}
//
//class DatePicker:UIView {
//
//    private var datePicker = UIDatePicker()
//    private var dateFormate = "dd/MM/yyyy"//"MM/dd/yyyy"//"dd/mm/yyyy"
//    private var dateFormateSalary = "MM/dd/yyyy"
//    weak var delegate:DatePickerDelegate?
//    private var isFromSalary = false
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        // self.frame = UIScreen.main.bounds
//        datePicker = UIDatePicker(frame: CGRect(x: 0,
//                                                    y: 0,
//                                                    width: UIScreen.main.bounds.width,
//                                                    height: 216))
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func showDatePicker(txtDatePicker:UITextField, isFromSalary : Bool){
//        //Formate Date
//        datePicker.datePickerMode = .date
//        datePicker.backgroundColor = UIColor.white
//        self.isFromSalary = isFromSalary
//        if #available(iOS 13.4, *) {
//            datePicker.preferredDatePickerStyle = .wheels
//        } else {
//            // Fallback on earlier versions
//
//        }
//
//        //ToolBar
//        let toolbar = UIToolbar();
//        toolbar.sizeToFit()
//        toolbar.tintColor = UIColor.primary
//        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:       #selector(donedatePicker));
//        let spaceButton = UIBarButtonItem(barButtonSystemItem:       UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:       #selector(cancelDatePicker));
//
//        toolbar.setItems([doneButton,spaceButton,cancelButton], animated:       false)
//
//        txtDatePicker.inputAccessoryView = toolbar
//        txtDatePicker.inputView = datePicker
//
//    }
//
//    @objc func donedatePicker(){
//
//        let formatter = DateFormatter()
//        if isFromSalary == true{
//            formatter.dateFormat = dateFormateSalary
//        }else{
//            formatter.dateFormat = dateFormate
//        }
//
//        let result = formatter.string(from: datePicker.date)
//        self.delegate?.getDate(self, date: result)
//
//    }
//
//    @objc func cancelDatePicker(){
//        self.delegate?.cancel(self)
//    }
//
//}

protocol DatePickerDelegate: AnyObject { //class
    func getDate(_ DatePicker:DatePicker, date:String, selectedDate : Date)
    func cancel(_ DatePicker:DatePicker)
}

class DatePicker:UIView {
    
    private var datePicker = UIDatePicker()
    private var dateFormate = "dd/MM/yyyy"//"MM/dd/yyyy"//"dd/mm/yyyy"
    private var dateFormateSalary = "MM/dd/yyyy"
    private var dateFormateExpense = "E, d MMM yyyy"
    private var selectedDateFormat = "yyyy-MM-dd HH:mm:ss"
    weak var delegate : DatePickerDelegate?
    private var isFromSalary = false
    private var isFromExpense = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // self.frame = UIScreen.main.bounds
        datePicker = UIDatePicker(frame: CGRect(x: 0,
                                                    y: 0,
                                                    width: UIScreen.main.bounds.width,
                                                    height: 216))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showDatePicker(txtDatePicker:UITextField, isFromSalary : Bool, isFromExpense : Bool){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        self.isFromSalary = isFromSalary
        self.isFromExpense = isFromExpense
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
            
        }
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        toolbar.tintColor = UIColor.primary
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action:       #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem:       UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action:       #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated:       false)
        
        txtDatePicker.inputAccessoryView = toolbar
        txtDatePicker.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
//        let formatter = DateFormatter()
//        if isFromSalary == true{
//            formatter.dateFormat = dateFormateSalary
//        }else if isFromExpense == true{
//            formatter.dateFormat = dateFormate
//            AddTransactionVCViewController.newDate = datePicker.date
//        }else{
//            formatter.dateFormat = dateFormate
//            AddTransactionVCViewController.newDate = datePicker.date
//        }
//        
//        let result = formatter.string(from: datePicker.date)
//        self.delegate?.getDate(self, date: result, selectedDate: datePicker.date)
        
    }
    
    @objc func cancelDatePicker(){
        self.delegate?.cancel(self)
    }
    
}
//MARK: Date on nth day
extension Date {
     func changeDays(by days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    func convertDateToString() -> String{
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Convert Date to String
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm:ss" //"yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
    
    func convertDateToShortStringOnly() -> String{
        let date = Date()
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        // Convert Date to String
        dateFormatter.dateFormat = "MM/dd/yyyy" //"yyyy-MM-dd HH:mm:ss"
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
}
