//
//  ActivityLoaderCell.swift
//  Befiler
//
//  Created by Sanjay Kumar on 15/08/2023.
//  Copyright © 2023 Haseeb. All rights reserved.
//

import UIKit

class ActivityLoaderCell: UITableViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
