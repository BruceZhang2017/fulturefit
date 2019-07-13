//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
//
//  RegisterViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//


import UIKit
import Toast_Swift
import PKHUD

class FFForgetViewController: BaseViewController {
    
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var codeTextField: UITextField!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var codeButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    @IBAction func code(_ sender: Any) {
        resignInput()
        guard let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            view.makeToast("请输入手机号码")
            return
        }
        if !phone.invalidatePhone() {
            view.makeToast("手机号码输入有误")
            return
        }
        PKHUD.sharedHUD.show()
        let network = FFNetworkManager()
        network.code(phone: phone) {[weak self] (response, error) in
            PKHUD.sharedHUD.hide()
            if error != nil {
                self?.view.makeToast("无网络，请检查网络")
                return
            }
            if response?.code == 200 {
                self?.view.makeToast("验证码以短信的方式下发，请注意查收！")
            } else {
                self?.view.makeToast(response?.message ?? "服务器异常，请稍后重试")
            }
        }
    }
    
    @IBAction func register(_ sender: Any) {
        resignInput()
        guard let phone = phoneTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            view.makeToast("请输入手机号码")
            return
        }
        if !phone.invalidatePhone() {
            view.makeToast("手机号码输入有误")
            return
        }
        guard let vcode = codeTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) else {
            view.makeToast("请输入验证码")
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
        PKHUD.sharedHUD.show()
        let network = FFNetworkManager()
        network.resetPwd(phone: phone, pwd: pwd, vcode: vcode) { [weak self] (response, error) in
            PKHUD.sharedHUD.hide()
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
    
    private func resignInput() {
        phoneTextField.resignFirstResponder()
        codeTextField.resignFirstResponder()
        pwdTextField.resignFirstResponder()
    }
    
}
