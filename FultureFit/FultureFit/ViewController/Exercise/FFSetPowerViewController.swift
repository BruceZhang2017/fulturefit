//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFSetPowerViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/21.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFSetPowerViewController: BaseViewController {

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
            labels[i].text = "\(mCtrlPowerValueArray[i])"
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
            if longTap.state == UILongPressGestureRecognizer.State.ended {
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
                    if mLeftCtrlValue & mCtrlBit1 == 0 {
                        mLeftCtrlValue |= mCtrlBit1
                    } else {
                        mLeftCtrlValue &= mCtrlBitRev1
                    }
                    mCtrlArray1[2] = UInt8(mLeftCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[1] == button {
                    if mLeftCtrlValue & mCtrlBit2 == 0 {
                        mLeftCtrlValue |= mCtrlBit2
                    } else {
                        mLeftCtrlValue &= mCtrlBitRev2
                    }
                    mCtrlArray1[2] = UInt8(mLeftCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[2] == button {
                    if mLeftCtrlValue & mCtrlBit3 == 0 {
                        mLeftCtrlValue |= mCtrlBit3
                    } else {
                        mLeftCtrlValue &= mCtrlBitRev3
                    }
                    mCtrlArray1[2] = UInt8(mLeftCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else if buttons[3] == button {
                    if mLeftCtrlValue & mCtrlBit4 == 0 {
                        mLeftCtrlValue |= mCtrlBit4
                    } else {
                        mLeftCtrlValue &= mCtrlBitRev4
                    }
                    mCtrlArray1[2] = UInt8(mLeftCtrlValue)
                    
                    sendChangeCtrlCommand()
                } else {
                    if mLeftCtrlValue & mCtrlBit5 == 0 {
                        mLeftCtrlValue |= mCtrlBit5
                    } else {
                        mLeftCtrlValue &= mCtrlBitRev5
                    }
                    mCtrlArray1[2] = UInt8(mLeftCtrlValue)
                    
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
        if mCurAdjustIndex != 0 {
            buttons[mCurAdjustIndex - 1].alpha = 1
            mCtrlUIFlashNum = 10
            normalModeUI()
        }
        if buttons[0] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 1
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[0])"
        } else if buttons[1] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 2
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[1])"
        } else if buttons[2] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 3
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[2])"
        } else if buttons[3] == button {
            mIsAdjustMode = true
            mCurAdjustIndex = 4
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[3])"
        } else {
            mIsAdjustMode = true
            mCurAdjustIndex = 5
            calculateView.isHidden = false
            valueLabel.text = "\(mCtrlPowerValueArray[4])"
        }
        if mCurAdjustIndex != 0 {
            mCtrlUIFlashNum = 10
        }
    }
    
    @IBAction func add(_ sender: Any) {
        if (mIsAdjustMode) {
            for i in 0..<5 {
                if mCurAdjustIndex - 1 == i {
                    mCtrlPowerValueArray[i] += 1
                    if mCtrlPowerValueArray[i] > mMaxPowerValue {
                        mCtrlPowerValueArray[i] = UInt8(mMaxPowerValue)
                    }
                    
                    labels[i].text = "\(mCtrlPowerValueArray[i])"
                    valueLabel.text = "\(mCtrlPowerValueArray[i])"

                    sendSinglePowerCommand(i)
                    
                    break
                }
            }
        }
    }
    
    @IBAction func reduce(_ sender: Any) {
        if mIsAdjustMode {
            for i in 0..<5 {
                if mCurAdjustIndex - 1 == i {
                    mCtrlPowerValueArray[i] -= 1
                    if mCtrlPowerValueArray[i] < mMinPowerValue {
                        mCtrlPowerValueArray[i] = UInt8(mMinPowerValue)
                    }
                    
                    labels[i].text = "\(mCtrlPowerValueArray[i])"
                    valueLabel.text = "\(mCtrlPowerValueArray[i])"
                    
                    sendSinglePowerCommand(i)
                    
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
        if mLeftCtrlValue & mCtrlBit1 == 0 {
            buttons[0].setImage(UIImage(named: "4444关闭"), for: .normal)
        } else {
            buttons[0].setImage(UIImage(named: "4444"), for: .normal)
        }

        if mLeftCtrlValue & mCtrlBit2 == 0 {
            buttons[1].setImage(UIImage(named: "1111关闭"), for: .normal)
        } else {
            buttons[1].setImage(UIImage(named: "1111"), for: .normal)
        }

        if mLeftCtrlValue & mCtrlBit3 == 0 {
            buttons[2].setImage(UIImage(named: "2222关闭"), for: .normal)
        } else {
            buttons[2].setImage(UIImage(named: "2222"), for: .normal)
        }

        if mLeftCtrlValue & mCtrlBit4 == 0 {
            buttons[3].setImage(UIImage(named: "3333关闭"), for: .normal)
        } else {
            buttons[3].setImage(UIImage(named: "3333"), for: .normal)
        }

        if mLeftCtrlValue & mCtrlBit5 == 0 {
            buttons[4].setImage(UIImage(named: "5555关闭"), for: .normal)
        } else {
            buttons[4].setImage(UIImage(named: "5555"), for: .normal)
        }
    }
    
}
