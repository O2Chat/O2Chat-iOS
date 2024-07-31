//
//  ImagePicker.swift
//  NewChatDemo2
//
//  Created by Sanjay Kumar on 15/07/2024.
//

import Foundation
import UIKit
import PhotosUI

// Delegate protocol to handle the selected images
protocol ImagePickerDelegate: AnyObject {
    func didSelectImages(_ images: [UIImage], withFileData fileData: [FileDataClass], fileUploadArrayList: [UploadFilesDataModel])
}

class ImagePicker: NSObject, PHPickerViewControllerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private weak var presentationController: UIViewController?
    private weak var delegate: ImagePickerDelegate?
    var conversationUUID : String?
    init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.presentationController = presentationController
        self.delegate = delegate
    }
    
    func presentImagePicker(conversationUuID : String) {
        if #available(iOS 14, *) {
            var configuration = PHPickerConfiguration()
            configuration.filter = .images
            configuration.selectionLimit = 5
            self.conversationUUID = conversationUuID
            let picker = PHPickerViewController(configuration: configuration)
            picker.delegate = self
            
            presentationController?.present(picker, animated: true, completion: nil)
        } else {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = false
            picker.mediaTypes = ["public.image"]
            
            presentationController?.present(picker, animated: true, completion: nil)
        }
    }
    
//    @available(iOS 14, *)
//    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
//        picker.dismiss(animated: true, completion: nil)
//        
//        var selectedImages = [UIImage]()
//        var fileDataArray = [FileDataClass]()
//        //used for add selected image or file for send to server using upload api
//        var fileUploadArrayList : [UploadFilesDataModel] = [UploadFilesDataModel]()
//        let group = DispatchGroup()
//        
//        for result in results {
//                    group.enter()
//                    result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
//                        defer { group.leave() }
//                        
//                        guard let self = self else { return }
//                        
//                        if let image = object as? UIImage {
//                            selectedImages.append(image)
//                            
////                            if let assetId = result.assetIdentifier {
////                                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
////                                if let asset = fetchResult.firstObject {
//                            if result.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
//                                result.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { (url, error) in
//                                    guard let url = url else { return }
//                                    let filename = url.lastPathComponent
//                                    let fileExtension = (filename as NSString).pathExtension
//                                    let strFileType = UtilsClassChat.sheard.getImageType(exten: fileExtension)
//                            
////                                    let filename = asset.value(forKey: "filename") as? String ?? "UnknownFileName"
////                                    let fileExtension = (filename as NSString).pathExtension
////                                    let strFileType = UtilsClassChat.sheard.getImageType(exten: fileExtension)
//                                    
//                                    var mimetype = ""
//                                    if (strFileType == "Unknown" || strFileType == ""){
//                                        mimetype = "image/png"
//                                    } else {
//                                        mimetype = "image/\(strFileType)"
//                                    }
//                                    
//                                    let base64String = image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
//                                    let tempChatID = self.generateUUID() ?? UUID().uuidString
//                                    
//                                    
//                                    //creating data model for files array list and send into upload api
//                                    var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
//                                    uploadFilesDataModel.file = base64String
//                                    uploadFilesDataModel.fileName = strFileType //filename
//                                    uploadFilesDataModel.contentType = mimetype //"image/png" //mimetype
//                                    uploadFilesDataModel.tempChatID = tempChatID
//                                    uploadFilesDataModel.conversationUId = self.conversationUUID
//                                    uploadFilesDataModel.caption = ""
//                                    fileUploadArrayList.append(uploadFilesDataModel)
//                                    
//                                    var fileDataClass = FileDataClass()
//                                    fileDataClass.fileName = filename
//                                    fileDataClass.fileSizes = ""
//                                    fileDataClass.url = base64String
//                                    fileDataClass.tempChatId = tempChatID
//                                    fileDataClass.mimeType = mimetype
//                                    fileDataClass.fileLocalUri = base64String
//                                    
//                                    fileDataArray.append(fileDataClass)
//                                }
//                            }else {
//                                print("Error loading image: \(String(describing: error))")
//                            }
//                        } else {
//                            print("Error loading image: \(String(describing: error))")
//                        }
//                    }
//        
////        for result in results {
////            group.enter()
////            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
////                defer { group.leave() }
////                
////                if let image = object as? UIImage, let assetId = result.assetIdentifier {
////                    selectedImages.append(image)
////                    
////                    let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetId], options: nil)
////                    if let asset = fetchResult.firstObject {
////                        let filename = asset.value(forKey: "filename") as? String ?? "UnknownFileName"
////                        let fileExtension = (filename as NSString).pathExtension
////                        let strFileType = UtilsClassChat.sheard.getImageType(exten: fileExtension)
////                        
////                        var mimetype = ""
////                        if (strFileType == "Unknown" || strFileType == ""){
////                            mimetype = "image/png"
////                        } else {
////                            mimetype = "image/\(strFileType)"
////                        }
////                        
////                        let base64String = image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
////                        let tempChatID = self?.generateUUID() ?? UUID().uuidString
////                        
////                        
////                        //creating data model for files array list and send into upload api
////                        var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
////                        uploadFilesDataModel.file = base64String
////                        uploadFilesDataModel.fileName = strFileType //filename
////                        uploadFilesDataModel.contentType = mimetype //"image/png" //mimetype
////                        uploadFilesDataModel.tempChatID = tempChatID
////                        uploadFilesDataModel.conversationUId = self?.conversationUUID
////                        uploadFilesDataModel.caption = ""
////                        fileUploadArrayList.append(uploadFilesDataModel)
////                        
////                        var fileDataClass = FileDataClass()
////                        fileDataClass.fileName = filename
////                        fileDataClass.fileSizes = ""
////                        fileDataClass.url = base64String
////                        fileDataClass.tempChatId = tempChatID
////                        fileDataClass.mimeType = mimetype
////                        fileDataClass.fileLocalUri = base64String
////                        
////                        fileDataArray.append(fileDataClass)
////                    }
////                } else {
////                    print("Error loading image: \(String(describing: error))")
////                }
////            }
//        }
//        
//        group.notify(queue: .main) {
//            self.delegate?.didSelectImages(selectedImages, withFileData: fileDataArray, fileUploadArrayList: fileUploadArrayList)
//        }
//    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true, completion: nil)
        
        var selectedImages = [UIImage]()
        var fileDataArray = [FileDataClass]()
        //used for add selected image or file for send to server using upload api
        var fileUploadArrayList : [UploadFilesDataModel] = [UploadFilesDataModel]()
        let group = DispatchGroup()
        
        for result in results {
            group.enter()
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (object, error) in
                defer { group.leave() }
                
                guard let self = self else { return }
                
                if let image = object as? UIImage {
                    selectedImages.append(image)
                    
                    // Process the image and generate metadata
                    let filename = UUID().uuidString + ".jpg"
                    let fileExtension = "jpg"
                    let strFileType = "jpg"
                    //let mimetype = "image/jpeg"
                    
                    var mimetype = ""
                    if (strFileType == "Unknown" || strFileType == ""){
                        mimetype = "image/png"
                    } else {
                        mimetype = "image/\(strFileType)"
                    }
                    
                    let base64String = image.jpegData(compressionQuality: 0.5)?.base64EncodedString() ?? ""
                    let tempChatID = self.generateUUID()
                    
                    //creating data model for files array list and send into upload api
                    var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
                    uploadFilesDataModel.file = base64String
                    uploadFilesDataModel.fileName = strFileType //filename
                    uploadFilesDataModel.contentType = mimetype //"image/png" //mimetype
                    uploadFilesDataModel.tempChatID = tempChatID
                    uploadFilesDataModel.conversationUId = self.conversationUUID
                    uploadFilesDataModel.caption = ""
                    fileUploadArrayList.append(uploadFilesDataModel)
                    
                    var fileDataClass = FileDataClass()
                    fileDataClass.fileName = filename
                    fileDataClass.fileSizes = ""
                    fileDataClass.url = base64String
                    fileDataClass.tempChatId = tempChatID
                    fileDataClass.mimeType = mimetype
                    fileDataClass.fileLocalUri = base64String
                    
                    fileDataArray.append(fileDataClass)
                } else {
                    print("Error loading image: \(String(describing: error))")
                }
            }
        }
        
        group.notify(queue: .main) {
            self.delegate?.didSelectImages(selectedImages, withFileData: fileDataArray, fileUploadArrayList: fileUploadArrayList)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        var selectedImages = [UIImage]()
        var fileDataArray = [FileDataClass]()
        //used for add selected image or file for send to server using upload api
        var fileUploadArrayList : [UploadFilesDataModel] = [UploadFilesDataModel]()
        
//        if let image = info[.originalImage] as? UIImage {
//            selectedImages.append(image)
//            
//            let filename = UUID().uuidString + ".jpg"
//            let fileExtension = "jpg"
//            let strFileType = "jpg"
//            let mimetype = "image/jpeg"
//            
//            let base64String = image.jpegData(compressionQuality: 0.5)?.base64EncodedString()
//            let tempChatID = generateUUID()
//
//            //creating data model for files array list and send into upload api
//            var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
//            uploadFilesDataModel.file = base64String
//            uploadFilesDataModel.fileName = strFileType //filename
//            uploadFilesDataModel.contentType = mimetype //"image/png" //mimetype
//            uploadFilesDataModel.tempChatID = tempChatID
//            //uploadFilesDataModel.conversationUId = self.conversationUuID
//            uploadFilesDataModel.caption = ""
//            fileUploadArrayList.append(uploadFilesDataModel)
//            
//            var fileDataClass = FileDataClass()
//            fileDataClass.fileName = filename
//            fileDataClass.fileSizes = ""
//            fileDataClass.url = base64String
//            fileDataClass.tempChatId = tempChatID
//            fileDataClass.mimeType = mimetype
//            fileDataClass.fileLocalUri = base64String
//            
//            fileDataArray.append(fileDataClass)
//        }
        
        let img:UIImage = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage)!
        let imageURL = (info[UIImagePickerController.InfoKey.imageURL] as? URL)
        let imageData = UtilsClassChat.sheard.compressImageFromUIImage(img: img)
        var strFileType = UtilsClassChat.sheard.getImageType(info: info)
        let strFileName = UtilsClassChat.sheard.getFileName(info: info)
        let base64String = UtilsClassChat.sheard.convertImageToBase64String(img:imageData)
       
        var strBase64 = ""
        var mimetype = ""
        if (strFileType == "Unknown" || strFileType == ""){
            strFileType = "png"
            mimetype = "image/png"
        }else {
            mimetype = "image/\(strFileType)"
        }
        if !strFileName.contains(".") {
            strFileType = "\(strFileName).\(strFileType)"
        }else{
            strFileType = strFileName
        }
        
        
        do {
            
            
            var tempChatId =  generateUUID()
            var uploadFilesDataModel : UploadFilesDataModel = UploadFilesDataModel()
            uploadFilesDataModel.file = base64String //imageData.jpegData(compressionQuality: 0.1)!
            uploadFilesDataModel.fileName = strFileName
            uploadFilesDataModel.contentType = mimetype
            uploadFilesDataModel.tempChatID = tempChatId
            uploadFilesDataModel.conversationUId = self.conversationUUID
            uploadFilesDataModel.caption = ""
            //this for send to upload api
            fileUploadArrayList.append(uploadFilesDataModel)
            
            var fileDataClass = FileDataClass()
            fileDataClass.fileName = strFileName
            fileDataClass.fileSizes = ""
            fileDataClass.url = base64String
            fileDataClass.tempChatId = tempChatId
            fileDataClass.mimeType = mimetype
            fileDataClass.fileLocalUri = base64String
//
            //this object make for show selected file to detail view controller
            fileDataArray.append(fileDataClass)
                        
        }catch{
            print("The wayo")
        }
        
        self.delegate?.didSelectImages(selectedImages, withFileData: fileDataArray, fileUploadArrayList: fileUploadArrayList)
    }
    
    private func generateUUID() -> String {
        return UUID().uuidString
    }
}
