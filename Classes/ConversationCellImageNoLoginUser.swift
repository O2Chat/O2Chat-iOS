//
//  ConversationCellImageNoLoginUser.swift
//  ConnectMateCustomer
//
//  Created by macbook on 23/05/2023.
//

import UIKit

class ConversationCellImageNoLoginUser: UITableViewCell {

    
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var uiViewMainImage: UIView!
    @IBOutlet weak var ivImageView: UIImageView!
    @IBOutlet weak var lbl_time: UILabel!
    @IBOutlet weak var downloaduiView: UIView!
    @IBOutlet weak var ivDownload: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.uiViewMainImage.layer.backgroundColor = UIColor.bgMessage.cgColor
        self.uiViewMainImage.clipsToBounds = true
        self.uiViewMainImage.layer.cornerRadius = 5
        // Configure the view for the selected state
        
    }
    
}
