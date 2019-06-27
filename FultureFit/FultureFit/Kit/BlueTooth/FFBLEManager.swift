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
    var timer: Timer?
    
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
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
        }
    }
    
    func connect(index: Int) {
        startConnectTimer()
        FFBaseModel.sharedInstall.bleConnectStatus = 1
        let per = discoveredManager.peripheral(index: index)
        activePeripheral = per.beripheral
        centralManager.connect(per.beripheral, options: nil)
    }
    
    func startConnectTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    func endConnectTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func handleTimer() {
        endConnectTimer()
        if centralManager.state == .poweredOn && activePeripheral != nil {
            centralManager.cancelPeripheralConnection(activePeripheral)
        }
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
        print("蓝牙状态：\(central.state.rawValue)")
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
        FFBaseModel.sharedInstall.bleConnectStatus = 2
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
        FFBaseModel.sharedInstall.bleConnectStatus = 0
        endConnectTimer()
        activePeripheral.delegate = nil
        activePeripheral = nil
    }
    
    /// 断开BLE连接
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    ///   - error: 错误信息
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        FFBaseModel.sharedInstall.bleConnectStatus = 0
        FFBaseModel.sharedInstall.commandReady = false
        endConnectTimer()
        activePeripheral.delegate = nil
        activePeripheral = nil
    }
    
    
}

extension FFBLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            print("Found Services count = \(services.count)")
            for service in services {
                print("service: \(service)")
                if service.uuid.uuidString == FFBLEConfig.Service_uuid {
                    FFBLEConfig.services[service.uuid.uuidString] = service
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
            if FFBLEConfig.services.count == 0 { // 说明不是JDY
                DispatchQueue.main.async {
                    NotificationCenter.default.post(name: TabNotification, object: "提示！此设备不为JDY系列BLE模块")
                }
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if service.characteristics == nil {
            return
        }
        for characteristic in service.characteristics! as [CBCharacteristic] {
            // only care supported
            if characteristic.uuid.uuidString != FFBLEConfig.Characteristic_uuid_TX || characteristic.uuid.uuidString != FFBLEConfig.Characteristic_uuid_FUNCTION {
                print("not support  \(service.uuid.uuidString) ")
                continue
            }
            FFBLEConfig.characteristics[characteristic.uuid.uuidString] = characteristic
            print("characteristic uuid: \(characteristic.uuid.uuidString)")
            if characteristic.properties.contains(CBCharacteristicProperties.broadcast) {
                print("Properties Broadcast")
            }
            if characteristic.properties.contains(CBCharacteristicProperties.read) {
                print("Properties Read")
            }
            if characteristic.properties.contains(CBCharacteristicProperties.write) {
                print("Properties Write ")
            }
            if characteristic.properties.contains(CBCharacteristicProperties.writeWithoutResponse) {
                print("Properties WriteWithoutResponse")
            }
            if characteristic.properties.contains(CBCharacteristicProperties.notify) {
                print("Properties Notify")
                setNotificationValue(enabled: true, characteristic: characteristic)
            }
            if characteristic.properties.contains(CBCharacteristicProperties.indicate) {
                print("Properties Indicate")
            }
            if characteristic.properties.contains(CBCharacteristicProperties.authenticatedSignedWrites) {
                print("Properties AuthenticatedSignedWrites")
            }
        }
        if FFBLEConfig.characteristics.count >= 2 {
            FFBaseModel.sharedInstall.commandReady = true
            write(data: Data([0xE7, 0xF6]), uuidString: FFBLEConfig.Characteristic_uuid_FUNCTION)
        } else if FFBLEConfig.characteristics.count >= 1 {
            FFBaseModel.sharedInstall.commandReady = true
        } else {
            FFBaseModel.sharedInstall.commandReady = true
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: TabNotification, object: "提示！此设备不为JDY系列BLE模块")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("上报上来的数据为：\(characteristic.value)")
    }
    
    func setNotificationValue(enabled:Bool, characteristic:CBCharacteristic) {
        activePeripheral?.setNotifyValue(enabled, for: characteristic)
    }
}
