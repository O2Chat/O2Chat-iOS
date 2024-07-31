//
//  ConversationCellFileNonLoginUser.swift
//  ConnectMateCustomer
//
//  Created by macbook on 24/05/2023.
//

import UIKit

class ConversationCellFileNonLoginUser: UITableViewCell {

    @IBOutlet weak var downloaduiView: UIView!
    @IBOutlet weak var ivDownload: UIImageView!
    @IBOutlet weak var uiViewMain: UIView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivImageIcon: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    
    @IBOutlet weak var labelCaption: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        // Initialization code
        self.uiViewMain.layer.backgroundColor = UIColor.bgMessage.cgColor
        self.uiViewMain.clipsToBounds = true
        self.uiViewMain.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
