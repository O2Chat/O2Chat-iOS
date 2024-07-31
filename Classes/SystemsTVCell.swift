//
//  SystemsTVCell.swift
//  Befiler
//
//  Created by Sanjay Kumar on 31/01/2024.
//  Copyright © 2024 Haseeb. All rights reserved.
//

import UIKit
import Cosmos

class SystemsTVCell: UITableViewCell {

    @IBOutlet weak var viewFeedback: UIView!
    @IBOutlet weak var labelFeedback: UILabel!
    @IBOutlet weak var viewRating: CosmosView!
    @IBOutlet weak var labelUserFirstName: UILabel!
    @IBOutlet weak var stackViewFeedback: UIStackView!
    @IBOutlet weak var stackViewResolved: UIStackView!
    @IBOutlet weak var labelChatDateTime: UILabel!
    @IBOutlet weak var labelChatStatus: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.stackViewFeedback.layer.cornerRadius = 10
        self.stackViewFeedback.layer.borderWidth = 0.5
        self.stackViewFeedback.layer.borderColor = UIColor.colorFromHex("4E8CEC").cgColor //UIColor.rgbColor(red: 62/255.0, green: 114/255.0, blue: 190/255.0).cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
