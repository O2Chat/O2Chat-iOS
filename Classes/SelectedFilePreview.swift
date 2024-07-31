//
//  SelectedFilePreview.swift
//  ConnectMateCustomer
//
//  Created by macbook on 26/05/2023.
//

import Foundation
import UIKit
//import SwiftEventBus

protocol SendUpdateSelectedFiles{
    func setUpdatedSelectedFiles(filesNames :[FileDataClass])
}

class SelectedFilePreview : UIViewController, UITextViewDelegate{
    
    
    var delegate : SendUpdateSelectedFiles!
    var currentIndex : Int = -1
    @IBOutlet weak var tvMessage: UITextView!
    @IBOutlet weak var imageViewPreview: UIImageView!
    
    @IBOutlet weak var multiImageCV: UICollectionView!
    @IBOutlet weak var multiImagePC: UIPageControl!
    
    @IBOutlet weak var mainViewLayoutTyping: UIView!
    @IBAction func btnBack(_ sender: Any) {
        
        dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                //SwiftEventBus.post("CalledAfterSelectedPreviewUnSend")
                SwiftEventBus.shared.post(eventName: "CalledAfterSelectedPreviewUnSend", userInfo: nil)

            }
        })
    }
    @IBAction func btnSend(_ sender: Any) {
        //Call Swift Event here
        dismiss(animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                // save message into local storage
                self.delegate.setUpdatedSelectedFiles(filesNames: self.filesNames)
                UserDefaults.standard.set(self.tvMessage.text!, forKey: "messageStr")
                //SwiftEventBus.post("CalledAfterSelectedPreviewSend")
                SwiftEventBus.shared.post(eventName: "CalledAfterSelectedPreviewSend", userInfo: nil)
                
            }
        })
        
    }
    
    @IBOutlet weak var lblFileName: UILabel!
    var fileType: String = ""
    var fileUri: String = ""
    var fileName: String = ""
    var fileSize: String = ""
    
    var isFromPDFSelection : Bool = false
    var isFromImageSelection : Bool = false
    var filesNames :[FileDataClass] = [FileDataClass]()
    
    @IBOutlet weak var uiViewFileMain: UIView!
    @IBOutlet weak var lblFileSize: UILabel!
    @IBOutlet weak var ivFileIcon: UIImageView!
    @IBOutlet weak var btnBack: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Initialization code
        self.mainViewLayoutTyping.clipsToBounds = true
        self.mainViewLayoutTyping.layer.cornerRadius = 20
        self.setCardView(view: self.mainViewLayoutTyping)
        self.tvMessage.delegate = self
        
        registerCV()
        
        if fileType == "image/JPEG" || fileType == "image/jpeg" || fileType == "image/PNG" || fileType == "image/png" || fileType == "image/JPG" || fileType == "image/jpg"{
            loadImage(at: fileUri)
            imageViewPreview.isHidden = true
            self.multiImageCV.isHidden = false
            uiViewFileMain.isHidden = true
        }else{
            
            if fileType == "application/pdf" || fileType == "application/PDF" {
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "pdf")
                ivFileIcon.image = loadImageFromPodBundle(named: "pdf")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                self.multiImageCV.isHidden = false
                //pdf
            }else if fileType == "application/doc" || fileType == "application/docx" || fileType == "application/msword" || fileType == "application/vnd.openxmlformats-officedocument.wordprocessingml.document"  || fileType == "application/DOCX"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "doc")
                ivFileIcon.image = loadImageFromPodBundle(named: "doc")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                // docs
            }
            else if fileType == "application/txt" || fileType == "application/TXT"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "txt_ic")
                ivFileIcon.image = loadImageFromPodBundle(named: "txt_ic")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
            }
            else if fileType == "application/xls" || fileType == "application/XLS"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "xls")
                ivFileIcon.image = loadImageFromPodBundle(named: "xls")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                
            }
            else if fileType == "application/7z" || fileType == "application/7Z"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "sevenz")
                ivFileIcon.image = loadImageFromPodBundle(named: "sevenz")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                
            }
            else if fileType == "application/zip" || fileType == "application/ZIP"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "zip")
                ivFileIcon.image = loadImageFromPodBundle(named: "zip")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                
            }
            else if fileType == "application/rar" || fileType == "application/RAR"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "rar")
                ivFileIcon.image = loadImageFromPodBundle(named: "rar")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                
            }
            
            else if fileType == "application/xlsx" || fileType == "application/XLSX"{
                self.multiImageCV.isHidden = false
                imageViewPreview.isHidden = true
                uiViewFileMain.isHidden = true
                //ivFileIcon.image = UIImage(named: "xlsx")
                ivFileIcon.image = loadImageFromPodBundle(named: "xlsx")
                lblFileName.text = fileName
                lblFileSize.text = fileSize
                
                
            }
            
        }
    }
    
    func setCardView(view : UIView){
        
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSizeMake(0, 0);
        view.layer.shadowRadius = 0.7;
        view.layer.shadowOpacity = 0.3;
        
    }
    
    
    func loadImage(at base64String: String) {
        if base64String != nil {
            let decodedData = NSData(base64Encoded: base64String, options: [])
            if let data = decodedData {
                let decodedimage = UIImage(data: data as Data)
                self.imageViewPreview.image = decodedimage
            } else {
                print("error with decodedData")
            }
        } else {
            print("error with base64String")
        }
    }
    
    func fileExists(at path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
}
extension SelectedFilePreview{
    
    func registerCV(){
        
        // Register the NIB
        let bundle = Bundle(for: ChatViewController.self)
        let nib = UINib(nibName: "MultiImageCVCell", bundle: bundle)
        self.multiImageCV.register(nib, forCellWithReuseIdentifier: "MultiImageCVCell")
        
        let nib1 = UINib(nibName: "MultiPDFCVCell", bundle: bundle)
        self.multiImageCV.register(nib1, forCellWithReuseIdentifier: "MultiPDFCVCell")
        
        let nib2 = UINib(nibName: "MultiFilesCVCell", bundle: bundle)
        self.multiImageCV.register(nib2, forCellWithReuseIdentifier: "MultiFilesCVCell")
        
        //self.multiImageCV.register(UINib(nibName: "MultiImageCVCell", bundle: nil), forCellWithReuseIdentifier: "MultiImageCVCell")
        
//        self.multiImageCV.register(UINib(nibName: "MultiPDFCVCell", bundle: nil), forCellWithReuseIdentifier: "MultiPDFCVCell")
//        
//        self.multiImageCV.register(UINib(nibName: "MultiFilesCVCell", bundle: nil), forCellWithReuseIdentifier: "MultiFilesCVCell")
        
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let visibleRect = CGRect(origin: self.multiImageCV.contentOffset, size: self.multiImageCV.bounds.size)
//        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
//        if let visibleIndexPath = self.multiImageCV.indexPathForItem(at: visiblePoint) {
//            self.currentIndex = visibleIndexPath.row
//            self.tvMessage.text = self.filesNames[visibleIndexPath.row].message
//            self.multiImagePC.currentPage = visibleIndexPath.row
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let visibleIndexPath = getVisibleIndexPath() else {
            return
        }

        self.currentIndex = visibleIndexPath.row
        self.tvMessage.text = self.filesNames[visibleIndexPath.row].message
        self.multiImagePC.currentPage = visibleIndexPath.row
    }

    private func getVisibleIndexPath() -> IndexPath? {
        let visibleRect = CGRect(origin: self.multiImageCV.contentOffset, size: self.multiImageCV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)

        if let visibleIndexPath = self.multiImageCV.indexPathForItem(at: visiblePoint) {
            return visibleIndexPath
        } else {
            // If the above method fails, you can try to get the visible index path in another way.
            let visibleIndexPaths = self.multiImageCV.indexPathsForVisibleItems
            return visibleIndexPaths.first
        }
    }

    
}
extension SelectedFilePreview : UICollectionViewDelegate,UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        multiImagePC.numberOfPages = self.filesNames.count
        multiImagePC.isHidden = self.filesNames.count > 1 ? false : true
        count = self.filesNames.count
//        if isFromImageSelection{
//            multiImagePC.numberOfPages = self.filesNames.count
//            multiImagePC.isHidden = self.filesNames.count > 1 ? false : true
//            count = self.filesNames.count
//        }else if isFromPDFSelection{
//            multiImagePC.numberOfPages = self.filesNames.count
//            multiImagePC.isHidden = self.filesNames.count > 1 ? false : true
//            count = self.filesNames.count
//        }else{
//            multiImagePC.numberOfPages = self.filesNames.count
//            multiImagePC.isHidden = self.filesNames.count > 1 ? false : true
//            count = self.filesNames.count
//        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if self.filesNames[indexPath.row].mimeType ?? "" == "image/JPEG" || self.filesNames[indexPath.row].mimeType ?? "" == "image/jpeg" || self.filesNames[indexPath.row].mimeType ?? "" == "image/PNG" || self.filesNames[indexPath.row].mimeType ?? "" == "image/png" || self.filesNames[indexPath.row].mimeType ?? "" == "image/JPG" || self.filesNames[indexPath.row].mimeType ?? "" == "image/jpg"{
            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiImageCVCell", for: indexPath) as! MultiImageCVCell
            cell.imagePreview.image = UtilsClassChat.sheard.convertBase64StringToImage(imageBase64String: self.filesNames[indexPath.row].fileLocalUri ?? "")
            return cell
            
        }else if self.filesNames[indexPath.row].mimeType ?? "" == "application/pdf" || self.filesNames[indexPath.row].mimeType ?? "" == "application/PDF" {
            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiPDFCVCell", for: indexPath) as! MultiPDFCVCell
            cell.displayPDFinWebView(base64: self.filesNames[indexPath.row].fileLocalUri ?? "")
            return cell
               
        }else {
            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiFilesCVCell", for: indexPath) as! MultiFilesCVCell
            let imageName = UtilsClassChat.sheard.getFileTypeIcon(fileType: self.filesNames[indexPath.row].mimeType ?? "")
            cell.imageFile.image = UIImage(named: imageName)
            cell.labelFielSize.text = self.filesNames[indexPath.row].fileSizes
            cell.labelFileName.text = self.filesNames[indexPath.row].fileName
            return cell
        }
            
        
        
//        if isFromImageSelection{
//            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiImageCVCell", for: indexPath) as! MultiImageCVCell
//            cell.imagePreview.image = UtilsClass.sheard.convertBase64StringToImage(imageBase64String: self.filesNames[indexPath.row].fileLocalUri ?? "")
//            return cell
//        }else if isFromPDFSelection{
//            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiPDFCVCell", for: indexPath) as! MultiPDFCVCell
//            cell.displayPDFinWebView(base64: self.filesNames[indexPath.row].fileLocalUri ?? "")
//            return cell
//        }
//        else{
//            let cell = multiImageCV.dequeueReusableCell(withReuseIdentifier: "MultiFilesCVCell", for: indexPath) as! MultiFilesCVCell
//            let imageName = UtilsClassChat.sheard.getFileTypeIcon(fileType: self.filesNames[indexPath.row].mimeType ?? "")
//            cell.imageFile.image = UIImage(named: imageName)
//            cell.labelFielSize.text = self.filesNames[indexPath.row].fileSizes
//            cell.labelFileName.text = self.filesNames[indexPath.row].fileName
//            return cell
//        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //self.exampleUsage(index: indexPath.row)
        self.currentIndex = indexPath.row
//        self.tvMessage.text = self.filesNames[indexPath.row].message
        print(indexPath.row)
//        self.centerCell(index: indexPath.row)
    }
    
}
extension SelectedFilePreview : UICollectionViewDelegateFlowLayout{
    // Center the collection view contentcenterCollectionViewContent
    
       func centerCollectionViewContent() {
           let firstIndexPath = IndexPath(item: 0, section: 0)
           self.multiImageCV.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: false)
       }
    
    // Function to center the collection view on a specific cell
    func centerCollectionView(on indexPath: IndexPath, animated: Bool) {
       multiImageCV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
    }

    // Example usage:
    func centerCell(index : Int) {
        // Replace with the actual index path of the cell you want to center
        let indexPathToCenter = IndexPath(item: index, section: 0)
        centerCollectionView(on: indexPathToCenter, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width : CGFloat = 0
        var height : CGFloat = 0
    
        width = self.multiImageCV.frame.width
        height = self.multiImageCV.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 10
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return  2
    }
}
extension SelectedFilePreview{
    
    // Function to load an image from the pod's bundle
    func loadImageFromPodBundle(named imageName: String, ofType type: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        if let imagePath = bundle.path(forResource: imageName, ofType: type) {
            return UIImage(contentsOfFile: imagePath)
        }
        return nil
    }

    // Alternative function using UIImage(named:in:compatibleWith:) initializer
    func loadImageFromPodBundle(named imageName: String) -> UIImage? {
        let bundle = Bundle(for: ChatViewController.self)
        return UIImage(named: imageName, in: bundle, compatibleWith: nil)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print()
        if self.currentIndex != -1{
            self.filesNames[self.currentIndex].message = self.tvMessage.text ?? ""
        }
    }
    
    func textViewDidBeginEditing(_ textField: UITextField) {
        print()
        if self.currentIndex != -1{
            self.filesNames[self.currentIndex].message = self.tvMessage.text ?? ""
        }
    }
    
    // UITextViewDelegate method called when the text in the UITextView changes
    func textViewDidChange(_ textView: UITextView) {
        // Your code to handle the text change goes here
        print("Text changed: \(textView.text)")
        if self.currentIndex != -1{
            self.filesNames[self.currentIndex].message = self.tvMessage.text ?? ""
        }
    }
    
}
