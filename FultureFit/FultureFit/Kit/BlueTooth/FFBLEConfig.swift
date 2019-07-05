//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBLEConfig.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/16.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import CoreBluetooth

class FFBLEConfig: NSObject {
    
    public static var HEART_RATE_MEASUREMENT = "00002a37-0000-1000-8000-00805f9b34fb";
    public static var CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb";
    
    public static var Service_uuid = "FFE0";
    public static var Characteristic_uuid_TX = "FFE1";
    public static var Characteristic_uuid_RX = "FFE1";
    public static var Characteristic_uuid_FUNCTION = "FFE2"
    
    public static var services : [String : CBService] = [:]
    public static var characteristics : [String : CBCharacteristic] = [:]

}
