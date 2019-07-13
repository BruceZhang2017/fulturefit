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
import Toast_Swift
import PKHUD

class LoginViewController: BaseViewController {

    @IBOutlet weak var loginButton: UIButton! // 登录按钮
    @IBOutlet weak var phoneTextField: UITextField! // 手机号输入框
    @IBOutlet weak var pwdTextField: UITextField! // 密码输入框
    @IBOutlet weak var registerButton: UIButton! // 注册按钮
    @IBOutlet weak var forgetButton: UIButton! // 忘记密码
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let leftPhone = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
        leftPhone.image = UIImage(named: "shouji")
        leftPhone.contentMode = .scaleAspectFit
        phoneTextField.leftView = leftPhone
        phoneTextField.leftViewMode = .always
        let leftPwd = UIImageView(frame: CGRect(x: 10, y: 12, width: 20, height: 20))
        leftPwd.image =  UIImage(named: "mima")
        leftPwd.contentMode = .scaleAspectFit
        pwdTextField.leftView = leftPwd
        pwdTextField.leftViewMode = .always
    }

    // MARK: - Action
    
    // 登录账户
    @IBAction func loginUser(_ sender: Any) {
        phoneTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
        guard let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            view.makeToast("请输入手机号码")
            return
        }
        if !phone.invalidatePhone() {
            view.makeToast("手机号码输入有误")
            return
        }
        guard let pwd = pwdTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            view.makeToast("请输入登录密码")
            return
        }
        if pwd.count < 6 || pwd.count > 16 {
            view.makeToast("密码输入有误，长度只能6-16")
            return
        }
        HUD.show(.progress)
        let network = FFNetworkManager()
        network.login(phone: phone, pwd: pwd) { [weak self] (response, error) in
            HUD.hide()
            if error != nil {
                self?.view.makeToast("无网络，请检查网络")
                return
            }
            if response?.code == 200 {
                self?.pushToMain()
            } else {
                self?.view.makeToast(response?.message ?? "服务器异常，请稍后重试")
            }
        }
    }
}

