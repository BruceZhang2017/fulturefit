//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  Constant.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/22.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

let itemNames = ["力量训练*性感", "耐力训练*年轻", "肌肉增长*马甲线翘臀", "全身燃烧脂肪*消耗卡路里", "身体放松*柔软"]

// 常量
let screenWidth = UIScreen.main.bounds.size.width
let screenHight = UIScreen.main.bounds.size.height

let ACTION_CHANGE_SINGLE_POWER = "cn.miha.futurefit.ACTION_CHANGE_SINGLE_POWER"
let ACTION_SINGLE_INDEX_EXTRA = "extra_sigle_index"
let ACTION_CHANGE_CTRL_ARRAY = "cn.miha.futurefit.ACTION_CHANGE_CTRL_ARRAY"
let FFExerciseModelServiceNotification = Notification.Name("FFExerciseModelService")
let TabNotification = Notification.Name("Tab")

// 左侧5组开关值 默认全部打开
// 0x01 第1组
// 0x02 第2组
// 0x04 第3组
// 0x08 第4组
// 0x10 第5组
var mLeftCtrlValue: UInt8 = 0x1f

// 右侧5组开关值 默认全部打开
// 0x01 第6组
// 0x02 第7组
// 0x04 第8组
// 0x08 第9组
// 0x10 第10组
var mRightCtrlValue: UInt8 = 0x1f

// 10组开关状态进行位运算时的常量
let mCtrlBit1: UInt8 = 0x01
let mCtrlBit2: UInt8 = 0x02
let mCtrlBit3: UInt8 = 0x04
let mCtrlBit4: UInt8 = 0x08
let mCtrlBit5: UInt8 = 0x10

// 10组开关状态进行逆位运算时的常量
let mCtrlBitRev1: UInt8 = 0x1e
let mCtrlBitRev2: UInt8 = 0x1d
let mCtrlBitRev3: UInt8 = 0x1b
let mCtrlBitRev4: UInt8 = 0x17
let mCtrlBitRev5: UInt8 = 0x0f

var mCtrlPowerValueArray: [UInt8] = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
let mMinPowerValue = 1
let mMaxPowerValue = 63

// 左侧5组和右侧5组开关状态 发送到设备端的指令
// 注意：由于设备端限制，更改任何一组开关状态后都要发送2条指令，不要只发送其中1条指令
var mCtrlArray1 = Data([0x74, 0x69, 0x1f, 0x75])
var mCtrlArray2 = Data([0x74, 0x6a, 0x1f, 0x75])

let mDeInit = Data([0x74, 0x66, 0x00, 0x75]) // 健身设备结束指令
