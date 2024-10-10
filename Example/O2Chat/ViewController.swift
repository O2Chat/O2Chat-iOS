//
//  ViewController.swift
//  O2Chat
//
//  Created by sanjay.khatri02@outlook.com on 07/30/2024.
//  Copyright (c) 2024 sanjay.khatri02@outlook.com. All rights reserved.
//

import UIKit
import O2ChatSDK

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            //Provide Data
            O2Chat.shared.presentO2ChatVC(from: self, customerName: "", customerEmail: "", customerPhone: "", customerCNIC: "", deviceTokenFCM: "", channelId: "")
        })
    }

    override func viewDidAppear(_ animated: Bool) {
        // Notify O2ChatManager that the app has finished launching If App Start From Terminated State
        if O2Chat.shared.isAppLauncedFromKilledStateGetter() == true{
            O2Chat.shared.isAppLauncedFromKilledStateSetter(value: false)
            O2Chat.shared.presentChatViewControllerFromNotification(from: self)
        }
    }
}

