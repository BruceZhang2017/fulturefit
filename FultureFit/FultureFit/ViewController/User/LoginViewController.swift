//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  ViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginButton: UIButton! // 登录按钮
    @IBOutlet weak var phoneTextField: UITextField! // 手机号输入框
    @IBOutlet weak var pwdTextField: UITextField! // 密码输入框
    @IBOutlet weak var registerButton: UIButton! // 注册按钮
    @IBOutlet weak var forgetButton: UIButton! // 忘记密码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    // MARK: - Action
    
    // 忘记密码
    @IBAction func forgetPWD(_ sender: Any) {
        
    }
    
    // 注册账户
    @IBAction func registerUser(_ sender: Any) {
        
    }
    
    // 登录账户
    @IBAction func loginUser(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Tab", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "FFTabBarController") as? FFTabBarController {
            viewController.modalTransitionStyle = .crossDissolve
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
}

