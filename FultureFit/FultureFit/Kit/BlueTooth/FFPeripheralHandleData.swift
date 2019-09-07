//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFPeripheralHandleData.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/19.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFPeripheralHandleData: NSObject {

    /// 写数据
    ///
    /// - Parameter data: 数据
    func write(data: Data) {
        handleBackgroundTask()
        DispatchQueue.global().async {
            if data.count == 0 {
                return
            }
            let count = data.count / 20
            let extra = data.count % 20
            for i in 0..<count {
                let start = i * 20
                let end = (i + 1) * 20
                let subData = data.subdata(in: start..<end)
                CMDQueue.sharedInstance.AddCmdQueue(param: subData)
            }
            if extra > 0 {
                let start = count * 20
                let end = data.count
                let subData = data.subdata(in: start..<end)
                CMDQueue.sharedInstance.AddCmdQueue(param: subData)
            }
        }
    }
    
    /// 处理返回数据
    ///
    /// - Parameter data: 数据
    func handle(data: Data) {
        
    }
    
    func handleBackgroundTask() {
        if UIApplication.shared.applicationState != .active {
            guard let appdelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appdelegate.checkActive()
        }
    }
}
