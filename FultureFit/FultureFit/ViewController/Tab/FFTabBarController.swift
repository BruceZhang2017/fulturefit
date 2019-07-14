//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFTabBarController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import Toast_Swift

class FFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if FFBaseModel.sharedInstall.blePowerStatus != .poweredOn {
            showBLENeedOpenAlert()
        }
        regresiterNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
    }
    
    deinit {
        unregresiterNotification()
        print("deinit FFTabBarController")
    }
    
    func regresiterNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showMassage(notification:)), name: TabNotification, object: nil)
    }
    
    func unregresiterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func showMassage(notification: Notification) {
        if let obj = notification.object as? String {
            view.makeToast(obj)
        }
    }
}
