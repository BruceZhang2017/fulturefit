//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBLEScanModelService.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/16.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFBLEScanModelService: NSObject {
    
    var scanedBLECallback: (() -> ())?
 
    override init() {
        super.init()
        startKVO()
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            FFBLEManager.sharedInstall.scan()
        }
    }
    
    deinit {
        endKVO()
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            FFBLEManager.sharedInstall.stopScan()
        }
    }
    
    // MARK: - Public
    
    /// 获取已发现设备数量
    ///
    /// - Returns: 数量
    public func getBLEDiscoveredCount() -> Int {
        return FFBLEManager.sharedInstall.discoveredManager.count()
    }
    
    /// 获取指定序号的附件对象
    ///
    /// - Parameter index: 指定序号
    /// - Returns: 附件对象
    public func getDiscoveredBLE(index: Int) -> Beripheral {
        return FFBLEManager.sharedInstall.discoveredManager.peripheral(index: index)
    }
    
    public func refreshScan() {
        FFBLEManager.sharedInstall.stopScan()
        FFBLEManager.sharedInstall.scan()
    }
    
    // MARK: - Private
    
    /// 监听扫描到的设备数组
    private func startKVO() {
        FFBLEManager.sharedInstall.discoveredManager.addObserve(key: NSStringFromClass(self.classForCoder), pro: self)
    }
    
    /// 取消监听扫描到的设备数组
    private func endKVO() {
        FFBLEManager.sharedInstall.discoveredManager.removeObserve(key: NSStringFromClass(self.classForCoder))
    }
    
}


extension FFBLEScanModelService: FFBLEDiscoveredProtocol {
    func discovered() {
        scanedBLECallback?()
    }
    
    
}
