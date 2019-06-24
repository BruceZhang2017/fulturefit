//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBaseModel.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import CoreBluetooth

class FFBaseModel: NSObject {
    
    static let sharedInstall = FFBaseModel()
    
    var blePowerStatus: CBManagerState = .poweredOff
    // 蓝牙连接状态
    // 0 未连接
    // 1 连接中
    // 2 已连接
    dynamic var bleConnectStatus = 0
    
    dynamic var commandReady = false
    
    var mJsType = 0 // 项目类型
    
    // 当前倒计时状态
    // 0 stop 倒计时还未开始
    // 1 start 开始并运行中
    // 2 pause 开始并暂停中
    // 3 finish 倒计时完成状态，下一秒会跳转到stop状态
    var mCountDownTimeState = 0
}
