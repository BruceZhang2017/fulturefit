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

class FFExerciseViewController: BaseViewController {

    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var fitSettingsButton: UIButton!
    @IBOutlet weak var playOrPauseButton: UIButton!
    @IBOutlet weak var bleStatusLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var progressViewRightLConstraint: NSLayoutConstraint! // 进度右边约束
    @IBOutlet weak var progressViewHeightLConstraint: NSLayoutConstraint! // 进度高度约束
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient() // 添加渐变图片
    }
    
    // MARK: - PRIVATE
    
    /// 添加渐变色
    private func addGradient() {
        //progressView.layer.cornerRadius = 35.0 / 2 // 736 * 71
        let height = (screenWidth - 100) * 71 / 736
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
        
        progressViewRightLConstraint.constant = -(screenWidth - 101)
    }
    
    // MARK: - Action
    
    @IBAction func fitSettings(_ sender: Any) {
        
    }
    
    /// 启动或者停止
    ///
    /// - Parameter sender: 按钮
    @IBAction func playOrPause(_ sender: Any) {
        
    }
}
