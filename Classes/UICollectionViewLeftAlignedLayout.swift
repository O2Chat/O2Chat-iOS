//
//  UICollectionViewLeftAlignedLayout.swift
//  ConnectMateCustomer
//
//  Created by macbook on 13/06/2023.
//

import Foundation
import UIKit
//final class UICollectionViewLeftAlignedLayout: UICollectionViewFlowLayout {
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var newAttributesArray = [UICollectionViewLayoutAttributes]()
//        let superAttributesArray = super.layoutAttributesForElements(in: rect)!
//        for (index, attributes) in superAttributesArray.enumerated() {
//            if index == 0 || superAttributesArray[index - 1].frame.origin.y != attributes.frame.origin.y {
//                attributes.frame.origin.x = sectionInset.left
//            } else {
//                let previousAttributes = superAttributesArray[index - 1]
//                let previousFrameRight = previousAttributes.frame.origin.x + previousAttributes.frame.width
//                attributes.frame.origin.x = previousFrameRight + minimumInteritemSpacing
//            }
//            newAttributesArray.append(attributes)
//        }
//        return newAttributesArray
//    }
//}

extension UIViewController{
    func addShadowBorder(view : UIView){
        // Add shadow
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = 4

        // Add border
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor(red: 78/255, green: 141/255, blue: 236/255, alpha: 1.0).cgColor
    }
    
    func addCornerRadius(button : UIButton){
        button.layer.cornerRadius = 5
        
    }
}
