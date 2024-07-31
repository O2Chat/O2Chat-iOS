//
//  MultiPDFCVCell.swift
//  Befiler
//
//  Created by Sanjay Kumar on 05/01/2024.
//  Copyright © 2024 Haseeb. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class MultiPDFCVCell: UICollectionViewCell, WKNavigationDelegate {

    var pdfView: PDFView!
    var base64String = "..."
    @IBOutlet var webView: WKWebView!
    @IBOutlet weak var viewPdfViewer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
extension MultiPDFCVCell{
    
    
    func displayPDFinWebView(base64 : String){
        self.base64String = base64
        
        if let data = Data(base64Encoded: base64String) {
            savePDFToDocumentDirectory(data: data)
            loadPDFFromDocumentDirectory()
        }
    }
    
    func savePDFToDocumentDirectory(data: Data) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsDirectory.appendingPathComponent("sample.pdf")
        
        do {
            try data.write(to: pdfURL)
        } catch {
            print("Error writing PDF to file: \(error.localizedDescription)")
        }
    }
    
    //        func loadPDFFromDocumentDirectory() {
    //            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    //            let pdfURL = documentsDirectory.appendingPathComponent("sample.pdf")
    //
    //            if let document = PDFDocument(url: pdfURL) {
    //                let pdfView = PDFView(frame: self.viewPdfViewer.bounds)
    //                pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    //                pdfView.displayMode = .singlePageContinuous
    //                pdfView.displayDirection = .vertical
    //                pdfView.document = document
    //                self.viewPdfViewer.addSubview(pdfView)
    //            } else {
    //                print("Error loading PDF document.")
    //            }
    //        }
    
    func loadPDFFromDocumentDirectory() {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let pdfURL = documentsDirectory.appendingPathComponent("sample.pdf")
        
        pdfView = PDFView(frame: viewPdfViewer.bounds)
        pdfView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        pdfView.displayMode = .singlePageContinuous
        pdfView.displayDirection = .vertical
        
        if let document = PDFDocument(url: pdfURL) {
            pdfView.document = document
            pdfView.autoScales = true
            viewPdfViewer.addSubview(pdfView)
            resizePDFViewFrame()
        } else {
            print("Error loading PDF document.")
        }
    }
    
    func resizePDFViewFrame() {
        pdfView.frame = viewPdfViewer.bounds
    }
    
}
