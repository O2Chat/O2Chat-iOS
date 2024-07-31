//
//  UtilsClass.swift
//  ConnectMateCustomer
//
//  Created by macbook on 22/05/2023.
//

import Foundation
import UIKit
import Photos
class UtilsClassChat {
    
    static var sheard = UtilsClassChat()
    
    
    //MARK: Chat Base Url
    //MARK: Live
//    var baseUrlChat = "https://secure.o2chat.io/"
    
    //MARK: QA
    //var baseUrlChat = "http://175.107.196.226:5005/" //http://175.107.196.226:5003/
    
    //"https://ae5b-202-47-59-83.ngrok-free.app/" //"http://175.107.196.226:5003/" //"https://9ccd-202-47-59-83.ngrok-free.app/"//"http://175.107.196.226:5005/" // "http://175.107.196.226:5005/" //"https://ab13-202-47-59-83.ngrok-free.app/"  //"http://175.107.196.226:5005/" //"https://ae9b-202-47-59-83.ngrok-free.app/" //"http://175.107.196.226:5003/"
    
//    private var activityIndicatorView: NVActivityIndicatorView!
//    var baseUrlForWebView =
//        "http://192.168.1.118:4204/auth/iOS;user="
    //used for loading page
    var baseUrlForWebView =
        "https://qa.arittek.com/dashboard/auth/iOS;user="
    var host =
        "qa.arittek.com"
    //loading page for live
    var baseUrlForWebViewLive =
        "https://dashboard.befiler.com/auth/iOS;user="
    var hostLive =
        "dashboard.befiler.com"
    //use to check the return url from webview like when token expire we compare using these domains
    var domainLive = "https://dashboard.befiler.com"
    var domainQA = "https://qa.arittek.com/dashboard"

    //FRESH DESK CREDENTIALS
    var APPID =
        "89d8e14c-ecb6-42da-8eba-7fc91d4b29f2"
    var APPKEY = "3e92f982-359c-481a-a580-f4e87a364385"
    var DOMAIN = "msdk.freshchat.com"
    var isLive = true
    var isForeeProduction = true
    var GOOGLE_CLIENT_ID = "215868769420-go8aledmhmg3ildl4ghl1gudqil0qfm8.apps.googleusercontent.com"
    let phoneNumber =  "+922138892069"
    var fromEmail = "info@befiler.com"
    var deviceId = 4
    var deviceIdStatus = 3
    var forgetPassUrlLive = "https://www.befiler.com/dashboard/auth/confirm-password" //"https://dashboard.befiler.com/auth/confirm-password"
    var forgetPassUrlQA = "http://175.107.240.74/dashboard/auth/confirm-password"
    var callerAppType = 5
    
    var appStoreUrl = "https://apps.apple.com/pk/app/befiler/id1591792617"
    
    var urlFBR = "https://fbr.gov.pk/valuation-of-immovable-properties/51147/131220"
    
    func showToast(controller: UIViewController, message : String, seconds: Double){
        
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.view.backgroundColor = UIColor(named: "#A9A9A9")
        alert.view.alpha = 0.5
        alert.view.layer.cornerRadius = 15
        controller.present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alert.dismiss(animated: true)
            
        }
        
    }
    
    //MARK: Chat Base Url
    //MARK: Live
    //var baseUrlChat = "https://secure.o2chat.io/"
    
    //MARK: QA
    var baseUrlChat = "http://175.107.196.226:5003/" //"http://175.107.196.226:5005/" //http://175.107.196.226:5003/
 
    func convertImageToBase64String(img: UIImage) -> String {
        return img.jpegData(compressionQuality: 0.1)?.base64EncodedString() ?? ""
    }
    
    
    func compressImageFromUIImage(img : UIImage) -> UIImage{
        
        ///first time
        let compressData: NSData = img.jpegData(compressionQuality: 0.0)! as NSData //max value is 1.0 and minimum is 0.0
        let compressedImage = UIImage(data: compressData as Data)
        
        //second time
        let compressData2: NSData = compressedImage!.jpegData(compressionQuality: 0.025)! as NSData //max value is 1.0 and minimum is 0.0
        let compressedImage2 = UIImage(data: compressData2 as Data)
        
        return compressedImage2!
    }
    
  
    func convertBase64StringToImage(imageBase64String:String) -> UIImage {
        let imageData = Data.init(base64Encoded: imageBase64String, options: .init(rawValue: 0))
        let image = UIImage(data: imageData ?? NSData() as Data)
        return image ?? UIImage()
    }
    
    func getCurrentLocalTimeZone() -> String {
      // Get the current device's time zone.
      let timeZone = TimeZone.current
        
      // Get the user's local time zone.
        let localTimeZone = timeZone.localizedName(for: .standard, locale: .current)

      // Return the local time zone.
        print("\(localTimeZone!)-(\(timeZone.abbreviation() ?? ""))")
        return "\(localTimeZone!)-(\(timeZone.abbreviation() ?? ""))"
    }
   

    func getUTCTime() -> String {
      // Get the current date
      let date = Date()

      // Create a date formatter
      let formatter = DateFormatter()
      formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
      formatter.timeZone = TimeZone(identifier: "UTC")
      // Format the date to a string
      let utcTime = formatter.string(from: date)
    
//      if !utcTime.isEmpty{
//          return utcTime.components(separatedBy: " ")[1]
//      }
      // Return the UTC time
      return utcTime //""
    }
    
    
    func getDayIndex(from date: Date) -> Int {
      let calendar = Calendar.current
      let components = calendar.dateComponents([.weekday], from: date)
      let dayIndex = components.weekday! - 1
      return filterDayIndex(index: dayIndex)
    }

    
    func filterDayIndex(index: Int)-> Int{
        
        if index == 1{
            return 0
        }
        else if index == 2 {
            return 1
        }
        else if index == 3 {
            return 2
        }
        else if index == 4 {
            return 3
        }
        else if index == 5 {
            return 4
        }
        else if index == 6 {
            
            return 5
        }
        else if index == 7 {
            return 6
        }
        return index
    }
   
    func getImageType(info: [UIImagePickerController.InfoKey : Any]) -> String {
        

        if let assetPath = info[UIImagePickerController.InfoKey.imageURL] as? URL{
                    
            if (assetPath.absoluteString.hasSuffix("JPEG") || assetPath.absoluteString.hasSuffix("jpeg")) {
                print("JPEG")
                return "JPEG"

            }
           else if (assetPath.absoluteString.hasSuffix("JPG") || assetPath.absoluteString.hasSuffix("jpg")) {
                print("JPG")
                return "JPG"

            }
            else if (assetPath.absoluteString.hasSuffix("PNG")) {
                print("PNG")
                return "PNG"

            }
            else if (assetPath.absoluteString.hasSuffix("GIF")) {
                print("GIF")
                return "GIF"
            }
            else if (assetPath.absoluteString.hasSuffix("GIF")) {
                print("GIF")
                return "GIF"
            }
            else {
                print("Unknown")
                return "Unknown"
            }
        }
        return ""

    
    }
    
    func getImageType(exten : String) -> String {
        

        if exten != "" {
            let assetPath = exten
            if (assetPath == ("JPEG") || assetPath == ("jpeg")) {
                print("JPEG")
                return "JPEG"
                
            }
            else if (assetPath == ("JPG") || assetPath == ("jpg")) {
                print("JPG")
                return "JPG"
                
            }
            else if (assetPath == ("PNG")) {
                print("PNG")
                return "PNG"
                
            }
            else if (assetPath == ("GIF")) {
                print("GIF")
                return "GIF"
            }
            else if (assetPath == ("GIF")) {
                print("GIF")
                return "GIF"
            }
            else {
                print("Unknown")
                return "Unknown"
            }
        }
        return ""

    
    }
    
    func imageSizeCheck(info: [UIImagePickerController.InfoKey : Any]) -> Bool {
        var Size = Float()
        var data = Data()
        if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
        if mediaType  == "public.image" {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                data = pickedImage.jpegData(compressionQuality: 1.0)!
                //Here you get MB size
                Size = Float(Double(data.count)/1024/1024)
                 //For Kb just remove single 1024 from size
                 // I am checking 2 MB size here you check as you want
                 if Size <= 1.00{
                    return true
                   
                 }else {
                    return false
                    
                 }
                }
              }
        }
        return false
    }
    
    func getFileName(info: [UIImagePickerController.InfoKey : Any]) -> String {
        var strFileName = ""
        if let url = info[UIImagePickerController.InfoKey.referenceURL] as? URL {
                    let assets = PHAsset.fetchAssets(withALAssetURLs: [url], options: nil)
                    if let firstAsset = assets.firstObject,
                    let firstResource = PHAssetResource.assetResources(for: firstAsset).first {
                        strFileName = firstResource.originalFilename
                    } else {
                        strFileName =
                            UtilsClassChat.sheard.uniqueFileNameWithExtention()
                    }
                } else {
                    strFileName =  UtilsClassChat.sheard.uniqueFileNameWithExtention()
                }
        
        return strFileName
    }
    
    
    
    let types = [
                 
        "public.composite-content",
                 "public.image",
                 "public.jpeg",
        "public.png", "public.jpeg",
                 
                 "public.camera-raw-image",
                 "com.apple.pict",
                 "com.apple.macpaint-image",
                 "public.png",
                 "public.xbitmap-image",
                 "com.apple.quicktime-image",
                 
                 "public.directory",
                 "public.folder",
                 
                 "com.pkware.zip-archive",
                 "public.filename-extension",
                 "public.mime-type",
                 
                 "com.adobe.pdf",
                 
                 "com.compuserve.gif",
                 
                 "com.microsoft.word.doc",
                 "com.microsoft.excel.xls",
                 "com.microsoft.powerpoint.​ppt",
                 
                 "org.openxmlformats.wordprocessingml.document",
                 "com.microsoft.powerpoint.​ppt",
                 "org.openxmlformats.presentationml.presentation",
                 "com.microsoft.excel.xls",
                 "org.openxmlformats.spreadsheetml.sheet",
                 
                 
    ]
    
    func uniqueFileNameWithExtention() -> String {
        let uniqueString: String = ProcessInfo.processInfo.globallyUniqueString
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMddhhmmsss"
        let dateString: String = formatter.string(from: Date())
        let uniqueName: String = "\(uniqueString)_\(dateString)"
        
        
        return uniqueName
    }
    
    func fileSize(fromPath path: String) -> String? {
        guard let size = try? FileManager.default.attributesOfItem(atPath: path)[FileAttributeKey.size],
            let fileSize = size as? UInt64 else {
            return nil
        }

        // bytes
        if fileSize < 1023 {
            return String(format: "%lu bytes", CUnsignedLong(fileSize))
        }
        // KB
        var floatSize = Float(fileSize / 1024)
        if floatSize < 1023 {
            return String(format: "%.1f KB", floatSize)
        }
        // MB
        floatSize = floatSize / 1024
        if floatSize < 1023 {
            return String(format: "%.1f MB", floatSize)
        }
        // GB
        floatSize = floatSize / 1024
        return String(format: "%.1f GB", floatSize)
    }
    
    func getFileTypeIcon(fileType : String) -> String{
        if fileType == "image/JPEG" || fileType == "image/jpeg" || fileType == "image/PNG" || fileType == "image/png" || fileType == "image/JPG" || fileType == "image/jpg"{
            return ""
        }else{
            
            if fileType == "application/pdf" || fileType == "application/PDF" {
                
                return "pdf"
                //pdf
            }else if fileType == "application/doc" || fileType == "application/docx" || fileType == "application/msword" || fileType == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"  || fileType == "application/DOCX"{
                
                return "doc"
                
                // docs
            }
            else if fileType == "application/txt" || fileType == "application/TXT"{
                
                return "txt_ic"
                
            }
            else if fileType == "application/xls" || fileType == "application/XLS"{
                
                return "xls"
                
            }
            else if fileType == "application/7z" || fileType == "application/7Z"{
                
                return "sevenz"
                
            }
            else if fileType == "application/zip" || fileType == "application/ZIP"{
                
                return "zip"
                
            }
            else if fileType == "application/rar" || fileType == "application/RAR"{
                
                return "rar"
                
            }
            
            else if fileType == "application/xlsx" || fileType == "application/XLSX"{
                
                return "xlsx"
                
            }
            return ""
        }
    }
    
    func convertTimeStampToDate(_ dataDate: String) -> Date? {
        var inputDate: Date?
        
        let utcFormat = DateFormatter()
        utcFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        utcFormat.timeZone = TimeZone(identifier: "UTC")
        
        do {
            inputDate = try utcFormat.date(from: dataDate)
        } catch {
            print(error.localizedDescription)
        }
        
        return inputDate
    }

}
