//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FoundationExtension.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import Foundation

extension String {
    func localizable() -> String {
        return NSLocalizedString(self, comment: "none")
    }
    
    func invalidatePhone() -> Bool {
        if count != 11 {
            return false
        }
        let pattern = "^1[0-9]{10}$"
        if NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: self) {
            return true
        }
        return false
    }
}

extension Data {
    func hexEncodedString() -> String {
        return map { String(format: "%02hhx ", $0) }.joined()
    }
}
