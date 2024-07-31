//
//  TopicsCollectionViewCell.swift
//  ConnectMateCustomer
//
//  Created by macbook on 13/06/2023.
//

import UIKit

class TopicsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var lblTopicName: UILabel!
    @IBOutlet weak var uiCvMain: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uiCvMain.clipsToBounds = true
        self.uiCvMain.layer.cornerRadius = 10
        self.uiCvMain.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner,.layerMaxXMinYCorner]
        self.uiCvMain.backgroundColor = UIColor.bgMessage

    }
    
   

}
