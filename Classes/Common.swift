//
//  Common.swift
//  User
//
//  Created by imac on 1/1/18.
//  Copyright © 2018 Appoets. All rights reserved.
//

import UIKit
import MessageUI



class Common {
    class func isValid(email : String)->Bool{
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@","[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}")
        return emailTest.evaluate(with: email)
        
    }
    
    class func getBackButton()->UIBarButtonItem{
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        return backItem// This will show in the next view controller being pushed
    }
    
    
   
    
    
//    class func GMSAutoComplete(fromView : GMSAutocompleteViewControllerDelegate?)->GMSAutocompleteViewController{
//
//    let gmsAutoCompleteFilter = GMSAutocompleteFilter()
//    gmsAutoCompleteFilter.country =  GMSCountryCode
//    gmsAutoCompleteFilter.type = .city
//    let gmsAutoComplete = GMSAutocompleteViewController()
//    gmsAutoComplete.delegate = fromView
//    gmsAutoComplete.autocompleteFilter = gmsAutoCompleteFilter
//    return gmsAutoComplete
//    }
    
    
    class func getCurrentCode()->String?{
        
       return (Locale.current as NSLocale).object(forKey:  NSLocale.Key.countryCode) as? String
  
    }
    
  
    
    
    //MARK:- Get Countries from JSON
    
//    class func getCountries()->[Country]{
//        
//        var source = [Country]()
//        
//        if let data = NSData(contentsOfFile: Bundle.main.path(forResource: "countryCodes", ofType: "json") ?? "") as Data? {
//            do{
//                source = try JSONDecoder().decode([Country].self, from: data)
//                
//            } catch let err {
//                print(err.localizedDescription)
//            }
//        }
//        return source
//    }
    
    
/*
    class func getRefreshControl(intableView tableView : UITableView, tintcolorId  : Int = Color.primary.rawValue, attributedText text : NSAttributedString? = nil)->UIRefreshControl{
       
        let rc = UIRefreshControl()
        rc.tintColorId = tintcolorId
        rc.attributedTitle = text
        tableView.addSubview(rc)
        return rc
        
    }
    
    // MARK:- Set Font
    
    class func setFont(to field :Any,isTitle : Bool = false, size : CGFloat = 0, fontType : FontCustom = .medium) {
        
        let customSize = size > 0 ? size : (isTitle ? 16 : 14)
        let font = UIFont(name: fontType.rawValue, size: customSize)
        
        switch (field.self) {
        case is UITextField:
            (field as? UITextField)?.font = font
        case is UILabel:
            (field as? UILabel)?.font = font
        case is UIButton:
            (field as? UIButton)?.titleLabel?.font = font
        case is UITextView:
            (field as? UITextView)?.font = font
        default:
            break
        }
    }
    
    
    // MARK:- Make Call
    class func call(to number : String?) {
        
        if let providerNumber = number, let url = URL(string: "tel://\(providerNumber)"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIScreen.main.focusedView?.make(toast:  APPLocalize.localizestring.cannotMakeCallAtThisMoment.localize())
        }
        
    }
    
    // MARK:- Send Email
    class func sendEmail(to mailId : [String], from view : UIViewController & MFMailComposeViewControllerDelegate) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = view
            mail.setToRecipients(mailId)
            view.present(mail, animated: true)
        } else {
            UIScreen.main.focusedView?.make(toast:  APPLocalize.localizestring.couldnotOpenEmailAttheMoment.localize())
        }
        
    }
    
    // MARK:- Send Message
    
    class func sendMessage(to numbers : [String], text : String, from view : UIViewController & MFMessageComposeViewControllerDelegate) {
        
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.body = text
            controller.recipients = numbers
            controller.messageComposeDelegate = view
            view.present(controller, animated: true, completion: nil)
        }
    }
    
    // MARK:- Bussiness Image Url
    class func getImageUrl (for urlString : String?)->String {
        
        return baseUrl+"/storage/"+String.removeNil(urlString)
    }
    
    class func storeUserData(from profile : UserProfileDetails?){
        
        User.main.id = profile?.id
        User.main.email = profile?.email
        User.main.name = profile?.name
        User.main.mobile = String(describing: (profile?.phone)!)
        User.main.picture = profile?.avatar
        User.main.wallet_balance = profile?.wallet_balance
        User.main.login_by = LoginType(rawValue: profile?.login_by ?? LoginType.manual.rawValue)
        User.main.payment_mode =  profile?.payment_mode
        User.main.currency = profile?.currency
        User.main.cart = profile?.cart
        
       // if let language = profile?.profile?.language {
//            UserDefaults.standard.set(language.rawValue, forKey: Keys.list.language)
//            setLocalization(language: language)
       // }
        if let languageStr = UserDefaults.standard.value(forKey: Keys.list.language) as? String, let language = Language(rawValue: languageStr) {
            setLocalization(language: language)
        }else {
            setLocalization(language: .english)
        }
   
    }
    
    //MARK:- Show Custom Toast
    class func showToast(string : String?) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.makeToast(string, duration: 1.0, position: .center)
        }
    }
    
    //Set Amount
    
    class func showAmount(amount:Double) -> String {
        let currency = String.removeNil(User.main.currency)
        return currency + String(format: "%.2f",amount)
//        return "\(String.removeNil(User.main.currency)) \(amount)"
    }
 
 */
    
}
