//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFSetPowerBackViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/21.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFSetPowerBackViewController: BaseViewController {

    @IBOutlet var buttons: [UIButton]!
    @IBOutlet var labels: [UILabel]!
    @IBOutlet weak var calculateView: UIView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var reduceButton: UIButton!
    @IBOutlet weak var valueLabel: UILabel!
    
    var mIsAdjustMode = false
    var mCurAdjustIndex = 0
    var mCtrlUIFlashNum: CGFloat = 10
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calculateView.isHidden = true
        for button in buttons {
            let longTap = UILongPressGestureRecognizer(target: self, action: #selector(handleLongTap(_:)))
            button.addGestureRecognizer(longTap)
        }
        for i in 0..<labels.count {
            labels[i].text = "\(mCtrlPowerValueArray[i + 5])"
        }
        
        normalModeUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
        timer = nil
    }
    
    @objc private func handleLongTap(_ sender: Any) {
        if let longTap = sender as? UILongPressGestureRecognizer {
            if longTap.state == UILongPressGestureRecognizer.State.began {
                if mIsAdjustMode {
                    mIsAdjustMode = false
                    if mCurAdjustIndex != 0 {
                        buttons[mCurAdjustIndex - 1].alpha = 1
                        mCtrlUIFlashNum = 10
                    }
                    mCurAdjustIndex = 0
                    calculateView.isHidden = true
                }
                guard let button = longTap.view as? UIButton else {
                    return
                }
                if buttons[0] == button {
                    if mRightCtrlValue & mCtrlBit1 == 0 {
                        mRightCtrlValue |= mCtrlBit1
                    } else {
                        mRightCtrlValue &= mCtrlBitRev1
                    }
                    mCtrlArray2[2] = UInt8(mRightCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[1] == button {
                    if mRightCtrlValue & mCtrlBit2 == 0 {
                        mRightCtrlValue |= mCtrlBit2
                    } else {
                        mRightCtrlValue &= mCtrlBitRev2
                    }
                    mCtrlArray2[2] = UInt8(mRightCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[2] == button {
                    if mRightCtrlValue & mCtrlBit3 == 0 {
                        mRightCtrlValue |= mCtrlBit3
                    } else {
                        mRightCtrlValue &= mCtrlBitRev3
                    }
                    mCtrlArray2[2] = UInt8(mRightCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[3] == button {
                    if mRightCtrlValue & mCtrlBit4 == 0 {
                        mRightCtrlValue |= mCtrlBit4
                    } else {
                        mRightCtrlValue &= mCtrlBitRev4
                    }
                    mCtrlArray2[2] = UInt8(mRightCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else {
                    if mRightCtrlValue & mCtrlBit5 == 0 {
                        mRightCtrlValue |= mCtrlBit5
                    } else {
                        mRightCtrlValue &= mCtrlBitRev5
                    }
                    mCtrlArray2[2] = UInt8(mRightCtrlValue)
                    
                    sendChangeCtrlCommand()
                }
                normalModeUI()
            }
        }
    }

    @IBAction func tap(_ sender: Any) {
        guard let button = sender as? UIButton else {
            return
        }
        if (mRightCtrlValue & mCtrlBit1 == 0) && buttons[0] == button {
            return
        }
        if (mRightCtrlValue & mCtrlBit2 == 0) && buttons[1] == button {
            return
        }
        if (mRightCtrlValue & mCtrlBit3 == 0) && buttons[2] == button {
            return
        }
        if (mRightCtrlValue & mCtrlBit4 == 0) && buttons[3] == button {
            return
        }
        if (mRightCtrlValue & mCtrlBit5 == 0) && buttons[4] == button {
            return
        }
        if buttons[0] == button && mCurAdjustIndex == 1 {
            return
        }
        if buttons[1] == button && mCurAdjustIndex == 2 {
            return
        }
        if buttons[2] == button && mCurAdjustIndex == 3 {
            return
        }
        if buttons[3] == button && mCurAdjustIndex == 4 {
            return
        }
        if buttons[4] == button && mCurAdjustIndex == 5 {
            return
        }
        if mCurAdjustIndex != 0 {
            buttons[mCurAdjustIndex - 1].alpha = 1
            mCtrlUIFlashNum = 10
            normalModeUI()
        }
        if buttons[0] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 1
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[5])"
        } else if buttons[1] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 2
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[6])"
        } else if buttons[2] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 3
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[7])"
        } else if buttons[3] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 4
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[8])"
        } else {
            mIsAdjustMode = true
            mCurAdjustIndex = 5
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[9])"
        }
        if mCurAdjustIndex != 0 {
            mCtrlUIFlashNum = 10
        }
    }
    
    @IBAction func add(_ sender: Any) {
        if (mIsAdjustMode) {
            for i in 0..<5 {
                if mCurAdjustIndex - 1 == i {
                    mCtrlPowerValueArray[i + 5] += 1
                    if mCtrlPowerValueArray[i + 5] > mMaxPowerValue {
                        mCtrlPowerValueArray[i + 5] = UInt8(mMaxPowerValue)
                    }
                    
                    labels[i].text = "\(mCtrlPowerValueArray[i + 5])"
                    valueLabel.text = "\(mCtrlPowerValueArray[i + 5])"
                    
                    sendSinglePowerCommand(i + 5)
                    
                    break
                }
            }
        }
    }
    
    @IBAction func reduce(_ sender: Any) {
        if mIsAdjustMode {
            for i in 0..<5 {
                if mCurAdjustIndex - 1 == i {
                    mCtrlPowerValueArray[i + 5] -= 1
                    if mCtrlPowerValueArray[i + 5] < mMinPowerValue {
                        mCtrlPowerValueArray[i + 5] = UInt8(mMinPowerValue)
                    }
                    
                    labels[i].text = "\(mCtrlPowerValueArray[i + 5])"
                    valueLabel.text = "\(mCtrlPowerValueArray[i + 5])"
                    
                    sendSinglePowerCommand(i + 5)
                    
                    break;
                }
            }
        }
    }
    
    var arg = 0
    
    @objc func handleTimer() {
        if mIsAdjustMode && mCurAdjustIndex != 0 {
            
            if mCtrlUIFlashNum < 5 {
                arg = 1
            } else if mCtrlUIFlashNum > 9 {
                arg = -1
            }
            
            mCtrlUIFlashNum += CGFloat(1 * arg)
            
            buttons[mCurAdjustIndex - 1].alpha = 0.1 * mCtrlUIFlashNum
            
        }
    }
    
    // MARK: - Private
    
    private func sendSinglePowerCommand(_ i: Int) {
        NotificationCenter.default.post(name: FFExerciseModelServiceNotification, object: ACTION_CHANGE_SINGLE_POWER, userInfo: [ACTION_SINGLE_INDEX_EXTRA: i])
    }
    
    private func sendChangeCtrlCommand() {
        NotificationCenter.default.post(name: FFExerciseModelServiceNotification, object: ACTION_CHANGE_CTRL_ARRAY, userInfo: nil)
    }
    
    private func normalModeUI() {
        if mRightCtrlValue & mCtrlBit1 == 0 {
            buttons[0].setImage(UIImage(named: "101010关闭"), for: .normal)
        } else {
            buttons[0].setImage(UIImage(named: "101010"), for: .normal)
        }
        
        if mRightCtrlValue & mCtrlBit2 == 0 {
            buttons[1].setImage(UIImage(named: "6666关闭"), for: .normal)
        } else {
            buttons[1].setImage(UIImage(named: "6666"), for: .normal)
        }
        
        if mRightCtrlValue & mCtrlBit3 == 0 {
            buttons[2].setImage(UIImage(named: "7777关闭"), for: .normal)
        } else {
            buttons[2].setImage(UIImage(named: "7777"), for: .normal)
        }
        
        if mRightCtrlValue & mCtrlBit4 == 0 {
            buttons[3].setImage(UIImage(named: "8888关闭"), for: .normal)
        } else {
            buttons[3].setImage(UIImage(named: "8888"), for: .normal)
        }
        
        if mRightCtrlValue & mCtrlBit5 == 0 {
            buttons[4].setImage(UIImage(named: "9999关闭"), for: .normal)
        } else {
            buttons[4].setImage(UIImage(named: "9999"), for: .normal)
        }
    }
}
