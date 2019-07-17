//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFNetworkManager.swift
//  FultureFit
//
//  Created by ANKER on 2019/7/5.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import Alamofire
import iPhonesModel

class FFNetworkManager: NSObject, iPhoneModelS {
    
    private let mac = "http://api.futurefit.cn/rest/"
    
    private func urlJoin(head: String) -> String {
        let appId = "123456"
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let channelCode = "official"
        let platform = "ios"
        let url = "/\(appId)-\(version)-\(channelCode)-\(platform)"
        return head + url
    }
    
    func requestPost(url: String, param: [String : Any], callback: @escaping (Data?, Error?) -> ()) {
        Alamofire.request(url, method: .post, parameters: param, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print("返回的内容: \(response.result.value)")
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            guard let data = response.data else {
                callback(nil, nil)
                return
            }
            callback(data, nil)
        }
    }
    
    func requestGet(url: String, callback: @escaping (Data?, Error?) -> ()) {
        Alamofire.request(url, method: .get).responseJSON { (response) in
            print("返回的内容: \(response.result.value)")
            if response.error != nil {
                callback(nil, response.error)
                return
            }
            guard let data = response.data else {
                callback(nil, nil)
                return
            }
            callback(data, nil)
        }
    }
    
    func code(phone: String, callback: @escaping (FFCodeResponse?, Error?) -> ()) {
        let url = urlJoin(head: mac + "vcode/send")
        requestPost(url: url, param: ["phone": phone]) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFCodeResponse.self, from: data!)
                callback(model, nil)
                return
            }
            callback(nil, error)
        }
    }
    
    func register(phone: String, pwd: String, vcode: String, callback: @escaping (FFBaseResponse?, Error?) -> ()) {
        let url = urlJoin(head: mac + "u/register")
        requestPost(url: url, param: ["phone": phone, "password": pwd, "vcode": vcode]) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFBaseResponse.self, from: data!)
                if model?.code == 200 {
                    UserDefaults.standard.set(phone, forKey: "phone")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "time")
                    UserDefaults.standard.synchronize()
                }
                callback(model, nil)
                return
            }
            callback(nil, error)
        }
    }
    
    func resetPwd(phone: String, pwd: String, vcode: String, callback: @escaping (FFBaseResponse?, Error?) -> ()) {
        let url = urlJoin(head: mac + "u/resetPwd")
        requestPost(url: url, param: ["phone": phone, "password": pwd, "vcode": vcode]) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFBaseResponse.self, from: data!)
                if model?.code == 200 {
                    UserDefaults.standard.set(phone, forKey: "phone")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "time")
                    UserDefaults.standard.synchronize()
                }
                callback(model, nil)
                return
            }
            callback(nil, error)
        }
    }
    
    func login(phone: String, pwd: String, callback: @escaping (FFBaseResponse?, Error?) -> ()) {
        let url = urlJoin(head: mac + "u/login")
        requestPost(url: url, param: ["phone": phone, "password": pwd]) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFBaseResponse.self, from: data!)
                if model?.code == 200 {
                    UserDefaults.standard.set(phone, forKey: "phone")
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "time")
                    UserDefaults.standard.synchronize()
                }
                callback(model, nil)
                return
            }
            callback(nil, error)
        }
    }
    
    /// 登录记录
    func loginRecord() {
        guard let phone = UserDefaults.standard.string(forKey: "phone") else {
            return
        }
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let url = urlJoin(head: mac + "u/report")
        requestPost(url: url, param: ["phone": phone, "osVersion": version, "model": iPhone().rawValue]) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFBaseResponse.self, from: data!)
                if model?.code == 200 {
                    UserDefaults.standard.set(Date().timeIntervalSince1970, forKey: "time")
                    UserDefaults.standard.synchronize()
                }
            }
        }
    }
    
    func updateInterface() {
        let url = urlJoin(head: mac + "v")
        requestGet(url: url) { (data, error) in
            if data != nil {
                let model = try? JSONDecoder().decode(FFBaseResponse.self, from: data!)
                if model?.code == 200 {
                    
                }
            }
        }
    }
}
