//
//  RateUsVC.swift
//  Befiler
//
//  Created by Sanjay Kumar on 31/01/2024.
//  Copyright © 2024 Haseeb. All rights reserved.
//

import UIKit
import Cosmos


protocol SendFeedbackProtocol{
    func sendFeedbackData(rating : Int, feedback : String, isSkipped : Bool)
}
class RateUsVC: UIViewController {

    
    var delegate : SendFeedbackProtocol!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var buttonSkip: UIButton!
    @IBOutlet weak var txtFieldFeedback: UITextField!
    @IBOutlet weak var ratingView: CosmosView!
    
    @IBOutlet weak var viewRateUS: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        viewRateUS.layer.cornerRadius = 20
        ratingView.settings.fillMode = .full
        //addShadowBorder(view: viewRateUS)
        addCornerRadius(button: buttonSkip)
        addCornerRadius(button: buttonSubmit)
    }
    
    @IBAction func actionSkipTapped(_ sender: UIButton) {
        self.dismiss(animated: true) {
            print("")
            self.delegate.sendFeedbackData(rating: Int(self.ratingView.rating), feedback: self.txtFieldFeedback.text ?? "", isSkipped: true)
        }
    }
    
    @IBAction func actionSubmitTapped(_ sender: UIButton) {
        if ratingView.rating == 0{
            self.showToast(strMessage: "Please rate before submit")
        }else{
            self.dismiss(animated: true) {
                print("")
                self.delegate.sendFeedbackData(rating: Int(self.ratingView.rating), feedback: self.txtFieldFeedback.text ?? "", isSkipped: false)
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension RateUsVC{
    func showToast(strMessage : String){
    
        Toast.show(message: strMessage, controller: self)

    }
    
    
}
