//
//  ConversationTableViewCellNoLoginUser.swift
//  ConnectMateCustomer
//
//  Created by macbook on 16/05/2023.
//

import UIKit

class ConversationTableViewCellNoLoginUser: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTimeDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var uiViewMessage: UIView!
    @IBOutlet weak var lblNameFirstLetter: UILabel!
    @IBOutlet weak var uiViewNameFirstLetter: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uiViewMessage.clipsToBounds = true
        self.uiViewMessage.layer.cornerRadius = 5
        self.uiViewMessage.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner,.layerMinXMinYCorner]
     self.uiViewMessage.backgroundColor = UIColor.bgMessage
     self.uiViewNameFirstLetter.backgroundColor = UIColor.gray
        
     self.uiViewNameFirstLetter.layer.cornerRadius = 20
        
        

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
