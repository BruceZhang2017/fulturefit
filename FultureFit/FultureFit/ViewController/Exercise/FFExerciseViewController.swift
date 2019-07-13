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
    @IBOutlet weak var countNumLabel: UILabel!
    @IBOutlet weak var reducePowerButton: UIButton!
    @IBOutlet weak var addPowerButton: UIButton!
    @IBOutlet weak var yellowImageView: UIImageView!
    @IBOutlet weak var yellowLabel: UILabel!
    @IBOutlet weak var progressViewRightLConstraint: NSLayoutConstraint! // 进度右边约束
    @IBOutlet weak var progressViewHeightLConstraint: NSLayoutConstraint! // 进度高度约束
    
    private var service: FFExerciseModelService!
    private var titleLabel: UILabel! // 标题
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
        if FFBaseModel.sharedInstall.mJsType >= 80 { // 刷新标题
            if FFBaseModel.sharedInstall.mJsType - 80 < itemNames.count {
                titleLabel.text = itemNames[FFBaseModel.sharedInstall.mJsType - 80]
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
        progressViewRightLConstraint.constant = screenWidth - 52
    }
    
    private func initializeUI() {
        fitSettingsButton.layer.borderWidth = 1
        fitSettingsButton.layer.borderColor = "a0dc2f".ColorHex()!.cgColor
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:)))
        playOrPauseButton.addGestureRecognizer(longTap)
        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: screenWidth - 80, height: 44))
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        let jsType = UserDefaults.standard.integer(forKey: "JSType")
        if jsType >= 80 {
            FFBaseModel.sharedInstall.mJsType = jsType
            let service = FFItemsModelService()
            titleLabel.text = service.fitItem(index: max(0, min(jsType - 80, service.fitItemsCount()))).name
        } else {
            titleLabel.text = "未选择健身项目"
        }
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(changeSportTile))
        tap.numberOfTapsRequired = 1
        titleLabel.addGestureRecognizer(tap)
        navigationItem.titleView = titleLabel
        bleStatusLabel.isUserInteractionEnabled = true
        let tapScan = UITapGestureRecognizer(target: self, action: #selector(pushToScanDevice))
        tapScan.numberOfTapsRequired = 1
        bleStatusLabel.addGestureRecognizer(tapScan)
    }
    
    private func handleTime(_ time: String) {
        let array = time.split(separator: ":")
        guard array.count == 2 else {
            return
        }
        let minute = Int(array[0]) ?? 0
        let second = Int(array[1]) ?? 0
        if minute == 20 || (minute == 19 && second > 50) {
            fitSettingsButton.isHidden = true
            addPowerButton.isHidden = true
            reducePowerButton.isHidden = true
        } else {
            fitSettingsButton.isHidden = false
            addPowerButton.isHidden = false
            reducePowerButton.isHidden = false
        }
    }
    
    // MARK: - Action
    
    /// 启动或者停止
    ///
    /// - Parameter sender: 按钮
    @IBAction func playOrPause(_ sender: Any) {
        service.onTimeStart()
    }
    
    @IBAction func addPower(_ sender: Any) {
        service.addPower()
        showProgress(true)
    }
    
    @IBAction func reducePower(_ sender: Any) {
        service.reducePower()
        showProgress(true)
    }
    
    /// 长按
    ///
    /// - Parameter sender: 触发者
    @objc private func handleLongTap(_ sender: Any) {
        if let longTap = sender as? UILongPressGestureRecognizer {
            if longTap.state == UILongPressGestureRecognizer.State.began {
                service.onTimeStartLong()
            }
        }
    }
    
    /// 跳转至选择健身项目
    @objc private func changeSportTile() {
        self.navigationController?.tabBarController?.selectedIndex = 1
    }
    
    /// 跳转至蓝牙扫描界面
    @objc private func pushToScanDevice() {
        let storyboard = UIStoryboard(name: "BLE", bundle: nil)
        if let viewController = storyboard.instantiateViewController(withIdentifier: "FFBLEScanViewController") as? FFBLEScanViewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    /// 判断是否显示进度条
    ///
    /// - Parameter value: 显示
    private func showProgress(_ value: Bool) {
        yellowLabel.isHidden = value
        yellowImageView.isHidden = value
        callbackForShowOrHidenProgress(value)
    }
}

extension FFExerciseViewController: FFExerciseModelServiceDelegate {
    
    func callbackForProgress(_ value: CGFloat) { // 最大630
        DispatchQueue.main.async {
            [weak self] in
            self?.progressViewRightLConstraint.constant = screenWidth - 50 - (value / 630 * (screenWidth - 100))
        }
        
    }
    
    func callbackForStartOrPause(_ value: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            if value {
                self?.playOrPauseButton.setImage(UIImage(named: "暂停"), for: .normal)
                self?.playOrPauseButton.setImage(UIImage(named: "暂停点击"), for: .highlighted)
            } else {
                self?.playOrPauseButton.setImage(UIImage(named: "播放"), for: .normal)
                self?.playOrPauseButton.setImage(UIImage(named: "播放点击"), for: .highlighted)
            }
        }
    }
    
    func callbackForShowOrHidenProgress(_ value: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.progressView.isHidden = !value
            self?.progressBackgroundImageView.isHidden = !value
        }
    }
    
    func callbackForShowOrHidenYellow(_ imageName: String?, time: String) {
        DispatchQueue.main.async {
            [weak self] in
            if imageName == nil {
                self?.yellowImageView.isHidden = true
                self?.yellowLabel.isHidden = true
            } else {
                self?.yellowImageView.isHidden = false
                self?.yellowLabel.isHidden = false
                self?.yellowImageView.image = UIImage(named: imageName!)
                self?.yellowLabel.text = time
                if imageName?.contains("黄") == true {
                    self?.yellowLabel.textColor = UIColor.yellow
                } else if imageName?.contains("红") == true {
                    self?.yellowLabel.textColor = UIColor.red
                } else if imageName?.contains("绿") == true {
                    self?.yellowLabel.textColor = UIColor.green
                }
            }
        }
    }
    
    
    func callbackForBLEState(_ value: Bool) {
        DispatchQueue.main.async {
            [weak self] in
            self?.bleSatusImageView.image = UIImage(named: value ? "蓝牙已连接" : "蓝牙未连接")
            self?.bleStatusLabel.text = value ? "蓝牙已连接" : "蓝牙已断开"
            if value {
                self?.navigationController?.tabBarController?.selectedIndex = 0
            }
        }
    }
    
    func callbackForShowMessage(_ message: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.view.makeToast(message)
        }
    }
    
    func callbackForShowFinishDialog(_ message: String) {
        DispatchQueue.main.async {
            [weak self] in
            let alert = UIAlertController(title: "健身完成", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (action) in
                
            }))
            self?.present(alert, animated: true, completion: nil)
        }
    }
    
    func callbackForRefreshTimeLabel(_ value: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.timeLabel.text = value
            if value.contains(":") { // 时间包含冒号
                self?.handleTime(value)
            }
        }
    }
    
    func callbackForRefreshDurationLabel(_ value: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.durationLabel.text = value
        }
    }
    
    func callbackForCountNumLabel(_ value: String) {
        DispatchQueue.main.async {
            [weak self] in
            self?.countNumLabel.text = value
        }
    }
    
}
