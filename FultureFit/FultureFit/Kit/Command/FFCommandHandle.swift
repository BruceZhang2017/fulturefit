//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFCommandHandle.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/17.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

/// 封装指令
class FFCommandHandle: NSObject {
    
    /// 增加Power
    func powerAdd() {
        writeData(mAllPowerAddOne)
    }
    
    /// 减少Power
    func powerSub() {
        writeData(mAllPowerDecOne)
    }
    
    /// 开始运动
    func startSport() {
        writeData(mInit)
    }
    
    /// 向设备端写数据
    ///
    /// - Parameter value: 数据
    func writeData(_ value: Data) {
        let handle = FFPeripheralHandleData()
        handle.write(data: value)
    }
}
