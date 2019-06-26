//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFExercisemodelServiceDelegate.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/26.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

protocol FFExerciseModelServiceDelegate: NSObjectProtocol {
    
    /// 回调BLE状态
    ///
    /// - Parameter value: 是否BLE已连接
    func callbackForBLEState(_ value: Bool)
    
    /// 回调显示一些提示文案
    ///
    /// - Parameter message: 文案
    func callbackForShowMessage(_ message: String)
    
    /// 显示完成提示
    ///
    /// - Parameter message: 提示内容
    func callbackForShowFinishDialog(_ message: String)
    
    /// 回调显示或者隐藏进度条
    ///
    /// - Parameter value: true显示，false不显示
    func callbackForShowOrHidenProgress(_ value: Bool)
    
    /// 显示黄红黄绿的逻辑
    ///
    /// - Parameters:
    ///   - imageName: 图片
    ///   - time: 时间字符串
    func callbackForShowOrHidenYellow(_ imageName: String?, time: String)
    
    /// 回调刷新开始或暂停
    ///
    /// - Parameter value: true暂停 false开始
    func callbackForStartOrPause(_ value: Bool)
    
    /// 回调刷新进度条
    ///
    /// - Parameter value: 当前的值
    func callbackForProgress(_ value: CGFloat)
    
    /// 回调刷新时间
    ///
    /// - Parameter value: 当前时间字符串
    func callbackForRefreshTimeLabel(_ value: String)
    
    /// 回调刷新子时间
    ///
    /// - Parameter value: 时间字符串
    func callbackForRefreshDurationLabel(_ value: String)
    
    /// 回调记录数
    ///
    /// - Parameter value: 数量
    func callbackForCountNumLabel(_ value: String)
}


