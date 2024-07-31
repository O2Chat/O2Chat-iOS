//
//  ConversationCellImageLoginUser.swift
//  ConnectMateCustomer
//
//  Created by macbook on 23/05/2023.
//

import UIKit
class ConversationCellImageLoginUser: UITableViewCell {

    
    var buttonPressed : (() -> ()) = {}
    @IBOutlet weak var failureStack: UIStackView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonReupload: UIButton!
    @IBOutlet weak var labelFailedToSend: UILabel!
    @IBOutlet weak var imageRefresh: UIImageView!
    @IBOutlet weak var viewFailure: UIView!
    
    @IBOutlet weak var stackViewFailure: UIStackView!
    
    @IBOutlet weak var labelImageCaption: UILabel!
    @IBOutlet weak var downloaduiView: UIView!
    @IBOutlet weak var ivDownload: UIImageView!
    @IBOutlet weak var uiViewMain: UIView!
    @IBOutlet weak var imgageStatus: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var ivImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.uiViewMain.layer.backgroundColor = UIColor.bgMessage.cgColor
        self.uiViewMain.clipsToBounds = true
        self.uiViewMain.layer.cornerRadius = 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionReuploadImageToSend(_ sender: UIButton) {
        self.buttonPressed()
    }
    
    
}
