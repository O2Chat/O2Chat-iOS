//
//  ConversationLoginUserTableViewCell.swift
//  ConnectMateCustomer
//
//  Created by macbook on 18/05/2023.
//

import UIKit

class ConversationLoginUserTableViewCell: UITableViewCell {

    @IBOutlet weak var ivStatus: UIImageView!
    @IBOutlet weak var lblTimeDate: UILabel!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var uiViewMessage: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uiViewMessage.clipsToBounds = true
        self.uiViewMessage.layer.cornerRadius = 5
        self.uiViewMessage.layer.maskedCorners = [.layerMaxXMaxYCorner,.layerMinXMaxYCorner]
        self.uiViewMessage.backgroundColor = UIColor.white
        
        self.setCardView(view: self.uiViewMessage)

    }

    func setCardView(view : UIView){

            view.layer.masksToBounds = false
            view.layer.shadowOffset = CGSizeMake(0, 0);
            view.layer.shadowRadius = 0.7;
            view.layer.shadowOpacity = 0.3;

        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
