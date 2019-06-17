//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBLEDiscoveredManager.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/16.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import CoreBluetooth

class FFBLEDiscoveredManager: NSObject {
    
    private var peripherals: [Beripheral] = [] // 附件数组
    var protocols: [String : FFBLEDiscoveredProtocol] = [:] // 观察者字典
    
    /// 是否已包含指定的附件
    ///
    /// - Parameter uuid: 附件的唯一标识
    /// - Returns: yes-是，no-否
    func isHavenPeriphral(uuid: String) -> Bool {
        for item in peripherals {
            if item.uuid == uuid {
                return true
            }
        }
        return false
    }
    
    /// 添加附件
    ///
    /// - Parameters:
    ///   - uuid: 附件唯一表示
    ///   - peripheral: 附件
    func addPeriphral(uuid: String, peripheral: CBPeripheral) {
        let per = Beripheral(uuid: peripheral.identifier.uuidString,
                             beripheral: peripheral,
                             name: peripheral.name ?? "未知设备",
                             mac: "00:00:00:00:00:00")
        peripherals.append(per)
        notifyAllObservser()
    }
    
    /// 移除所有附件
    func removePeriphrals() {
        peripherals.removeAll()
        notifyAllObservser()
    }
    
    /// 附件总数
    ///
    /// - Returns: 数量
    func count() -> Int {
        return peripherals.count
    }
    
    /// 获取指定index的附件对象
    ///
    /// - Parameter index: 指定index
    /// - Returns: 附件对象
    func peripheral(index: Int) -> Beripheral {
        return peripherals[index]
    }
    
    /// 新增观察者
    ///
    /// - Parameters:
    ///   - key: 观察者唯一标识
    ///   - pro: 观察者
    func addObserve(key: String, pro: FFBLEDiscoveredProtocol) {
        protocols[key] = pro
    }
    
    /// 移除观察者
    ///
    /// - Parameter key: 观察者的唯一标识
    func removeObserve(key: String) {
        protocols[key] = nil
    }
    
    /// 通知所有的观察者
    private func notifyAllObservser() {
        for (_, value) in protocols {
            value.discovered()
        }
    }
}

/// 附件对象，可扩展
struct Beripheral {
    var uuid: String
    var beripheral: CBPeripheral
    var name: String
    var mac: String
}

protocol FFBLEDiscoveredProtocol {
    func discovered()
}
