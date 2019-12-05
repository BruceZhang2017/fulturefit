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
        addConnectedDevice() // 如果已经连接了设备，则先将已连接的设备加入队列中
        centralManager.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey : false])
    }
    
    private func addConnectedDevice() {
        guard let peripheral = FFBLEManager.sharedInstall.activePeripheral else {
            return
        }
        let uuid = peripheral.identifier.uuidString
        FFBLEManager.sharedInstall.discoveredManager.addPeriphral(uuid: uuid, peripheral: peripheral, services: peripheral.services?.count ?? 0)
    }
    
    /// 停止扫描
    func stopScan() {
        if centralManager.state == .poweredOn {
            centralManager.stopScan()
        }
    }
    
    /// 连接指定设备
    ///
    /// - Parameter index: 数据列表中的index
    func connect(index: Int) {
        if activePeripheral != nil && centralManager.state == .poweredOn {
            centralManager.cancelPeripheralConnection(activePeripheral) // 断开已连接的设备
            perform(#selector(connectDevice(index:)), with: V(index), afterDelay: 0.1)
            return
        }
        connectDevice(index: V(index))
    }
    
    @objc private func connectDevice(index: V) {
        startConnectTimer()
        FFBaseModel.sharedInstall.bleConnectStatus = 1
        let per = discoveredManager.peripheral(index: index.value)
        activePeripheral = per.beripheral
        centralManager.connect(per.beripheral, options: nil)
    }
    
    /// 初始化连接定时器
    func startConnectTimer() {
        timer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
        RunLoop.main.add(timer!, forMode: .common)
    }
    
    /// 销毁连接定时器
    func endConnectTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    /// 处理定时器事件
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
        print("向设备端写指令：\(data.hexEncodedString())")
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
        if activePeripheral != nil && central.state != .poweredOn {
            centralManager.cancelPeripheralConnection(activePeripheral) // 断开已连接的设备
            activePeripheral = nil
        }
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
        let services = advertisementData["kCBAdvDataServiceUUIDs"] as? [Any]
        discoveredManager.addPeriphral(uuid: peripheral.identifier.uuidString, peripheral: peripheral, services: services?.count ?? 0)
    }
    
    /// 连接成功
    ///
    /// - Parameters:
    ///   - central: 中心
    ///   - peripheral: 附件
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("蓝牙连接成功: \(peripheral.name ?? "no name")")
        endConnectTimer()
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
        print("蓝牙连接失败: \(error?.localizedDescription ?? "no error")")
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
        print("蓝牙断开连接: \(error?.localizedDescription ?? "no error")")
        FFBaseModel.sharedInstall.bleConnectStatus = 0
        FFBaseModel.sharedInstall.commandReady = false
        endConnectTimer()
        activePeripheral.delegate = nil
        activePeripheral = nil
        FFBLEConfig.services.removeAll()
        FFBLEConfig.characteristics.removeAll()
    }
    
}

extension FFBLEManager: CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            print("Found Services count = \(services.count)")
            for service in services {
                print("service: \(service)")
                if service.uuid.uuidString.lowercased() == FFBLEConfig.Service_uuid.lowercased() {
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
            if characteristic.uuid.uuidString != FFBLEConfig.Characteristic_uuid_TX &&
                characteristic.uuid.uuidString != FFBLEConfig.Characteristic_uuid_FUNCTION {
                print("not support  [\(characteristic.uuid.uuidString)]")
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
            //peripheral.discoverDescriptors(for: FFBLEConfig.characteristics.values.first!)
        } else {
            FFBaseModel.sharedInstall.commandReady = true
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: TabNotification, object: "提示！此设备不为JDY系列BLE模块")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        print("上报上来的数据为：\(String(describing: characteristic.value))")
    }
    
    func setNotificationValue(enabled:Bool, characteristic:CBCharacteristic) {
        activePeripheral?.setNotifyValue(enabled, for: characteristic)
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard let descriptors = characteristic.descriptors else {
            return
        }
        for descriptor in descriptors {
            print("descriptor: \(descriptor.uuid.uuidString)")
            if descriptor.uuid.uuidString.lowercased() == "2902" {
                activePeripheral?.writeValue(Data([0x01, 0x00]), for: descriptor)
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor descriptor: CBDescriptor, error: Error?) {
        print("write descriptor error: \(error?.localizedDescription ?? "no error")")
    }
}
