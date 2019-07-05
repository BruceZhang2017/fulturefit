//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  UIKitExtension.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

extension String {
    
    /// 16进制转color
    ///
    /// - Returns: color
    func ColorHex() -> UIColor? {
        let color = self
        if color.count <= 0 || color.count != 6 {
            return nil
        }
        var red: UInt32 = 0x0
        var green: UInt32 = 0x0
        var blue: UInt32 = 0x0
        let redString = String(color[color.index(color.startIndex, offsetBy: 0)...color.index(color.startIndex, offsetBy: 1)])
        let greenString = String(color[color.index(color.startIndex, offsetBy: 2)...color.index(color.startIndex, offsetBy: 3)])
        let blueString = String(color[color.index(color.startIndex, offsetBy: 4)...color.index(color.startIndex, offsetBy: 5)])
        Scanner(string: redString).scanHexInt32(&red)
        Scanner(string: greenString).scanHexInt32(&green)
        Scanner(string: blueString).scanHexInt32(&blue)
        let hexColor = UIColor.init(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        return hexColor
    }
}

extension UIViewController {
    func showBLENeedOpenAlert() {
        let alert = UIAlertController(title: nil, message: "mine_ble_scan_need_ble_open_tip".localizable(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK".localizable(), style: .default, handler: { (action) in
            
        }))
        present(alert, animated: true, completion: nil)
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss SSS"
        return formatter.string(from: self)
    }
}
