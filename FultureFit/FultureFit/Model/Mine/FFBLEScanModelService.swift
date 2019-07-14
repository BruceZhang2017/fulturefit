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
    var scanedBLEFinished: (() -> ())?
    var scanedBLEShowAlert: (() -> ())?
    var scanedBLEHideAlert: (() -> ())?
    var timer: Timer?
    let blePowerStatusKeyPath = "blePowerStatus"
    let bleConnectStatusKeyPath = "bleConnectStatus"
 
    override init() {
        super.init()
        startKVO()
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            FFBLEManager.sharedInstall.scan()
            endTimer()
            startTimer()
        }
    }
    
    deinit {
        endKVO()
        endTimer()
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            FFBLEManager.sharedInstall.stopScan()
        }
    }
    
    /// 监听扫描时间定时器
    private func startTimer() {
        print("启动定时器")
        if timer == nil {
            timer = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
            RunLoop.current.add(timer!, forMode: .common)
        }
    }
    
    /// 结束定时器
    private func endTimer() {
        print("取消定时器")
        timer?.invalidate()
        timer = nil
    }
    
    /// 处理定时器
    @objc private func handleTimer() {
        print("定时器被激活")
        endTimer()
        stopScan()
        scanedBLEFinished?()
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
        FFBLEManager.sharedInstall.discoveredManager.removePeriphrals()
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            endTimer()
            startTimer()
            FFBLEManager.sharedInstall.stopScan()
            FFBLEManager.sharedInstall.scan()
        } else {
            scanedBLEShowAlert?()
        }
    }
    
    public func connectPer(index: Int) {
        FFBLEManager.sharedInstall.connect(index: index)
    }
    
    public func stopScan() {
        if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
            FFBLEManager.sharedInstall.stopScan()
        }
    }
    
    // MARK: - Private
    
    /// 监听扫描到的设备数组
    private func startKVO() {
        FFBLEManager.sharedInstall.discoveredManager.addObserve(key: NSStringFromClass(self.classForCoder), pro: self)
        FFBaseModel.sharedInstall.addObserver(self, forKeyPath: blePowerStatusKeyPath, options: .new, context: nil)
        FFBaseModel.sharedInstall.addObserver(self, forKeyPath: bleConnectStatusKeyPath, options: .new, context: nil)
    }
    
    /// 取消监听扫描到的设备数组
    private func endKVO() {
        FFBLEManager.sharedInstall.discoveredManager.removeObserve(key: NSStringFromClass(self.classForCoder))
        FFBaseModel.sharedInstall.removeObserver(self, forKeyPath: blePowerStatusKeyPath)
        FFBaseModel.sharedInstall.removeObserver(self, forKeyPath: bleConnectStatusKeyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == blePowerStatusKeyPath {
            DispatchQueue.main.async {
                [weak self] in
                if FFBaseModel.sharedInstall.blePowerStatus == .poweredOn {
                    self?.startTimer()
                    self?.scanedBLEHideAlert?()
                    FFBLEManager.sharedInstall.scan()
                } else {
                    self?.scanedBLEShowAlert?()
                    self?.endTimer()
                    FFBLEManager.sharedInstall.stopScan()
                }
            }
            
        } else if keyPath == bleConnectStatusKeyPath {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 {
                endTimer()
            }
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
}


extension FFBLEScanModelService: FFBLEDiscoveredProtocol {
    func discovered() {
        scanedBLECallback?()
    }
    
    
}
