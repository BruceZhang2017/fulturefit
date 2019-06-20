//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBLEManager.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import CoreBluetooth

class FFBLEManager: NSObject {
    
    static let sharedInstall = FFBLEManager() // 使用单例管理
    private var centralManager: CBCentralManager! // 中心
    var activePeripheral: CBPeripheral! // 激活状态的附件
    var discoveredManager = FFBLEDiscoveredManager() // 发现管理器
    
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: DispatchQueue(label: "FultureFit"), options: [CBCentralManagerOptionShowPowerAlertKey: false])
    }
    
    /// 开始扫描
    func scan() {
        discoveredManager.removePeriphrals()
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
    }
    
    /// 停止扫描
    func stopScan() {
        centralManager.stopScan()
    }
    
    func connect(index: Int) {
        let per = discoveredManager.peripheral(index: index)
        centralManager.connect(per.beripheral, options: nil)
    }
    
    /// 写数据
    ///
    /// - Parameters:
    ///   - data: 数据
    ///   - uuidString: 特征UUID
    func write(data: Data, uuidString: String? = nil) {
        var uuid = ""
        if uuidString == nil {
            uuid = FFBLEConfig.Characteristic_uuid_TX
        } else {
            uuid = uuidString!
        }
        guard let characteristic = FFBLEConfig.characteristics[uuid] else {
            return
        }
        var type: CBCharacteristicWriteType = .withResponse
        if ((characteristic.properties.rawValue & CBCharacteristicProperties.writeWithoutResponse.rawValue) != 0 ) {
            type = .withoutResponse
        }
        activePeripheral.writeValue(data, for: characteristic, type: type)
    }
}

extension FFBLEManager: CBCentralManagerDelegate {
    
    /// 中心状态回调
    ///
    /// - Parameter central: 中心
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        FFBaseModel.sharedInstall.blePowerStatus = central.state
    }
    
    /// 发送设备
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    ///   - advertisementData: 广播数据
    ///   - RSSI: 信号强度
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("搜索到的设备：\(peripheral.name ?? "no name")")
        if discoveredManager.isHavenPeriphral(uuid: peripheral.identifier.uuidString) {
            return
        }
        discoveredManager.addPeriphral(uuid: peripheral.identifier.uuidString, peripheral: peripheral)
    }
    
    /// 连接成功
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        activePeripheral = peripheral
        activePeripheral.delegate = self
        activePeripheral.discoverServices(nil)
    }
    
    /// 连接失败
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    ///   - error: 报错信息
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        
    }
    
    /// 断开BLE连接
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    ///   - error: 错误信息
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        
    }
    
    
}

extension FFBLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
}
