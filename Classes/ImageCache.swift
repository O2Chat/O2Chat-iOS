//
//  ImageCache.swift
//  Befiler
//
//  Created by Sanjay on 23/12/2021.
//  Copyright © 2021 Haseeb. All rights reserved.
//

import Foundation
import UIKit

class Cache {
    
    static let shared : NSCache<AnyObject,UIImage> = {
        
        return NSCache<AnyObject,UIImage>()
        
    }()
    
    class func image(forUrl urlString : String?, completion : @escaping (UIImage?)-> ()){
        
        DispatchQueue(label: ProcessInfo().globallyUniqueString, qos: .background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil) .async {
            var image : UIImage? = nil
            guard  let url = urlString else {
                completion(image)
                return
            }
            image = Cache.shared.object(forKey: url as AnyObject) // Retrieve Image From cache If available
            if image == nil, !url.isEmpty, let _url = URL(string: url) {  // If Image is not available, then download
                URLSession.shared.dataTask(with: _url, completionHandler: { (data, response, error) in
                    guard data != nil, let imageData = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                        completion(nil)
                        return
                    }
                    Cache.shared.setObject(imageData, forKey: responseUrl as AnyObject)
                    completion(imageData) // return Image
                }).resume()
            }
            completion(image)
        }
    }
}


extension UIImageView {
    
    func setImage(with urlString : String?,placeHolder placeHolderImage : UIImage?) {
        let activity = UIActivityIndicatorView()
        activity.tag = 100
        let activityHeight = self.frame.height/3
        let activityWidth = self.frame.width/3
        activity.tintColor = .primary
        activity.frame = CGRect(x: (self.frame.width/2)-(activityWidth*0.5), y: (self.frame.height/2)-(activityHeight*0.5), width: activityWidth, height: activityHeight)
        self.addSubview(activity)
        activity.startAnimating()
        guard urlString != nil, let imageUrl = URL(string: urlString!) else {
            self.image = placeHolderImage
            self.stopActivity(image: self)
            return
        }
        if let image = Cache.shared.object(forKey: urlString! as AnyObject) {
            self.stopActivity(image: self)
            self.image = image
        } else {
            URLSession.shared.dataTask(with: imageUrl) { (data, response, error) in
                guard data != nil, let imagePic = UIImage(data: data!), let responseUrl = response?.url?.absoluteString else {
                    DispatchQueue.main.async {
                        self.stopActivity(image: self)
                        self.image = placeHolderImage
                    }
                    return
                }
                DispatchQueue.main.async {
                    self.stopActivity(image: self)
                    self.image = imagePic
                }
                Cache.shared.setObject(imagePic, forKey: responseUrl as AnyObject)
                }.resume()
        }
    }
    
    func stopActivity(image:UIImageView)  {
        for activity in image.subviews {
            if activity.tag == 100 {
                activity.removeFromSuperview()
            }
        }
    }
}




