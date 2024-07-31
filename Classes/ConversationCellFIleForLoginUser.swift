//
//  ConversationCellFIleForLoginUser.swift
//  ConnectMateCustomer
//
//  Created by macbook on 23/05/2023.
//

import UIKit

class ConversationCellFIleForLoginUser:
    UITableViewCell {
    
    var buttonPressed : (() -> ()) = {}
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var buttonResend: UIButton!
    @IBOutlet weak var viewFailure: UIView!
    
    @IBOutlet weak var downloaduiView: UIView!
    @IBOutlet weak var ivDownload: UIImageView!
    @IBOutlet weak var ivImageFIleIcon: UIImageView!
    @IBOutlet weak var lblFileName: UILabel!
    @IBOutlet weak var ivFileStatus: UIImageView!
    @IBOutlet weak var lblTIme: UILabel!
    @IBOutlet weak var uiViewMain: UIView!
    
    @IBOutlet weak var labelCaption: UILabel!
    @IBOutlet weak var imageFailure: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //self.uiViewMain.layer.backgroundColor = UIColor.bgMessage.cgColor
        self.uiViewMain.clipsToBounds = true
        //self.uiViewMain.layer.cornerRadius = 5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func actionResendTapped(_ sender: UIButton) {
        buttonPressed()
    }
    
    
}
