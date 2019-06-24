//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFExerciseViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import Toast_Swift

/// 锻炼主界面
class FFExerciseViewController: BaseViewController {

    @IBOutlet weak var progressBackgroundImageView: UIImageView!
    @IBOutlet weak var bleSatusImageView: UIImageView!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var fitSettingsButton: UIButton!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var bleStatusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var reducePowerButton: UIButton!
    @IBOutlet weak var addPowerButton: UIButton!
    @IBOutlet weak var yellowImageView: UIImageView!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var progressViewRightLConstraint: NSLayoutConstraint! // 进度右边约束
    @IBOutlet weak var progressViewHeightLConstraint: NSLayoutConstraint! // 进度高度约束
    
    private var service: FFExerciseModelService!
    var mFlagShowPowerSeekBar = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service = FFExerciseModelService(delegate: self)
        addGradient() // 添加渐变图片
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        initializeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if FFBaseModel.sharedInstall.mJsType >= 80 {
            if FFBaseModel.sharedInstall.mJsType - 80 < itemNames.count {
                title = itemNames[FFBaseModel.sharedInstall.mJsType - 80]
            }
        }
    }
    
    // MARK: - PRIVATE
    
    /// 添加渐变色
    private func addGradient() {
        progressView.layer.cornerRadius = 7
        let height: CGFloat = 14 // (screenWidth - 100) * 71 / 736
        progressView.clipsToBounds = true
        let layer = CAGradientLayer()
        layer.colors = ["00FF00".ColorHex()!.cgColor, "FFFF00".ColorHex()!.cgColor, "FF0000".ColorHex()!.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 0.5)
        layer.endPoint = CGPoint(x: 1, y: 0.5)
        layer.locations = [0, 0.5, 1]
        layer.anchorPoint = CGPoint(x: 0, y: 0)
        let rect = CGRect(x: 0, y: 0, width: screenWidth - 100, height: height)
        layer.bounds = rect
        progressView.layer.addSublayer(layer)
        
        let fieldPath = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .bottomLeft], cornerRadii: CGSize(width: height / 2, height: height / 2))
        let fieldLayer = CAShapeLayer()
        fieldLayer.frame = rect
        fieldLayer.path = fieldPath.cgPath
        progressView.layer.mask = fieldLayer
        progressViewRightLConstraint.constant = 50
        progressView.isHidden = true
    }
    
    private func initializeUI() {
        fitSettingsButton.layer.borderWidth = 1
        fitSettingsButton.layer.borderColor = "a0dc2f".ColorHex()!.cgColor
    }
    
    // MARK: - Action
    
    @IBAction func fitSettings(_ sender: Any) {
        
    }
    
    /// 启动或者停止
    ///
    /// - Parameter sender: 按钮
    @IBAction func playOrPause(_ sender: Any) {
        if (FFBaseModel.sharedInstall.mCountDownTimeState == 0) {
            // 当前处于倒计时未启动状态，点击按键若满足条件则进入运行状态
            if (FFBaseModel.sharedInstall.bleConnectStatus == 3 && FFBaseModel.sharedInstall.commandReady) {
                if (FFBaseModel.sharedInstall.mJsType == 0) {
                    view.makeToast("请选择健身内容！")
                } else {
                    FFBaseModel.sharedInstall.mCountDownTimeState = 1
                    service.mStartTime = Int(Date().timeIntervalSince1970)
                    service.mSpendTime = 0
                    playOrPauseButton.setImage(UIImage(named: "暂停"), for: .normal)
                    playOrPauseButton.setImage(UIImage(named: "暂停点击"), for: .highlighted)
                    service.startSport()
                }
            } else {
                view.makeToast("请连接设备！")
            }
            
        }
    }
    
    @IBAction func addPower(_ sender: Any) {
        service.vibrator()
    }
    
    @IBAction func reducePower(_ sender: Any) {
        service.vibrator()
    }
}

extension FFExerciseViewController: FFExerciseModelServiceDelegate {
    
    func callbackForBLEState(_ value: Bool) {
        bleSatusImageView.image = UIImage(named: value ? "蓝牙已连接" : "蓝牙未连接")
        bleStatusLabel.text = value ? "蓝牙已连接" : "蓝牙已断开"
    }
    
    func callbackForShowMessage(_ message: String) {
        view.makeToast(message)
    }
    
    func callbackForShowFinishDialog(_ message: String) {
        let alert = UIAlertController(title: "健身完成", message: message, preferredStyle: .alert)
        //alert.addAction()
    }
    
}
