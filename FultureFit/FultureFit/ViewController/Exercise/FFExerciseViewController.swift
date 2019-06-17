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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressView.layer.cornerRadius = 35.0 / 2
        let layer = CAGradientLayer()
        layer.colors = ["00FF00".ColorHex()!, "FFFF00".ColorHex()!, "FF0000".ColorHex()!]
        layer.startPoint = CGPoint(x: 0.5, y: 0)
        layer.endPoint = CGPoint(x: 0.5, y: 1)
        layer.locations = [0, 0.5, 1]
        
        layer.bounds = CGRect(x: 50, y: 0, width: screenWidth - 100, height: 35)
    }
    
    
    
    @IBAction func fitSettings(_ sender: Any) {
    }
    
    @IBAction func playOrPause(_ sender: Any) {
    }
}
