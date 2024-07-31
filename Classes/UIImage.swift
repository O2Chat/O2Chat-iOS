//
//  UIImage.swift
//  befiler
//
//  Created by Sanjay on 25/01/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import Foundation
import UIKit
class ImageSaver: NSObject {
    func writeToPhotoAlbum(image: UIImage) {
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(saveCompleted), nil)
    }

    @objc func saveCompleted(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        print("Save finished!")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "showToastReciept"), object: nil, userInfo: nil)

    }
}
