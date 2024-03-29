//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFExerciseModelService2.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/26.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

extension FFExerciseModelService {
    
    /// 开始
    func onTimeStart() {
        if FFBaseModel.sharedInstall.mCountDownTimeState == 0 {
            // 当前处于倒计时未启动状态，点击按键若满足条件则进入运行状态
            if (FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady) {
                if (FFBaseModel.sharedInstall.mJsType == 0) {
                    delegate?.callbackForShowMessage("请选择健身内容！")
                } else {
                    FFBaseModel.sharedInstall.mCountDownTimeState = 1
                    mFlagShowPowerSeekBar = false
                    mStartTime = Int(Date().timeIntervalSince1970 * 1000)
                    mSpendTime = 0
                    delegate?.callbackForStartOrPause(true)
                    handle.writeData(mInit)
                    perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER1, afterDelay: 0.05)
                }
            } else {
                delegate?.callbackForShowMessage("请连接设备！")
            }
            
        } else if FFBaseModel.sharedInstall.mCountDownTimeState == 1 {
            // 当前处于倒计时运行状态，点击按键则进入暂停状态
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage(what:)), object: V_MSG_SHOW_TIME)
            FFBaseModel.sharedInstall.mCountDownTimeState = 2
            mSpendTime += Int(Date().timeIntervalSince1970 * 1000) - mStartTime
            delegate?.callbackForStartOrPause(false)
            
            if (mFlagEnd2K) {
                // 2K已结束状态下
                if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
                    if (FFBaseModel.sharedInstall.mJsType == 80) {
                        // 力量训练
                        doStrengthCmdPause(mCurIndex, true)
                    } else if (FFBaseModel.sharedInstall.mJsType == 81) {
                        // 耐力训练
                        doNaiLiCmdPause(mCurIndex, true)
                    } else if (FFBaseModel.sharedInstall.mJsType == 82) {
                        // 肌肉增长
                        doJiRouCmdPause(mCurIndex, true)
                    } else if (FFBaseModel.sharedInstall.mJsType == 83) {
                        // 脂肪燃烧
                        doFatBurnCmdPause(mCurIndex, true)
                    } else if (FFBaseModel.sharedInstall.mJsType == 84) {
                        // 放松身体
                        doRelaxCmdPause(mCurIndex, true)
                    }
                }
            } else {
                // 2K状态
                if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
                    handle.writeData(mPause2K)
                }
            }
        } else if FFBaseModel.sharedInstall.mCountDownTimeState == 2 {
            // 当前处于倒计时暂停状态，点击按键后倒计时恢复运行
            if (mFlagEnd2K) {
                // 2K已结束状态下
                if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
                    if (FFBaseModel.sharedInstall.mJsType == 80) {
                        // 力量训练
                        doStrengthCmdPause(mCurIndex, false)
                    } else if (FFBaseModel.sharedInstall.mJsType == 81) {
                        // 耐力训练
                        doNaiLiCmdPause(mCurIndex, false)
                    } else if (FFBaseModel.sharedInstall.mJsType == 82) {
                        // 肌肉增长
                        doJiRouCmdPause(mCurIndex, false)
                    } else if (FFBaseModel.sharedInstall.mJsType == 83) {
                        // 脂肪燃烧
                        doFatBurnCmdPause(mCurIndex, false)
                    } else if (FFBaseModel.sharedInstall.mJsType == 84) {
                        // 放松身体
                        doRelaxCmdPause(mCurIndex, false)
                    }
                }
            } else {
                // 2K状态
                if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
                    handle.writeData(mResume2K)
                }
            }
            
            mStartTime = Int(Date().timeIntervalSince1970 * 1000)
            FFBaseModel.sharedInstall.mCountDownTimeState = 1
            handleMessage(what: V_MSG_SHOW_TIME)
            delegate?.callbackForStartOrPause(true)
        }
        
    }
    
    func onTimeStartLong() {
        if (FFBaseModel.sharedInstall.mCountDownTimeState == 2) {
            mFinishTime = Int(((mSpendTime + 999) / 1000))
            onTimeStop()
            delegate?.callbackForShowFinishDialog(sportName())
        } else if (FFBaseModel.sharedInstall.mCountDownTimeState == 1) {
            mFinishTime = ((mSpendTime + 999 + Int(Date().timeIntervalSince1970 * 1000) - mStartTime)/1000)
            onTimeStop()
            delegate?.callbackForShowFinishDialog(sportName())
        }
    }
    
    func onTimeStop() {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage(what:)), object: V_MSG_SHOW_TIME)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage2(what:)), object: V_MSG_SET_PROGRESS_UP)
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage2(what:)), object: V_MSG_SET_PROGRESS_DOWN)
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
            handle.writeData(mDeInit)
            perform(#selector(handleMessage2(what:)), with: V_MSG_DEINIT_EXTEND, afterDelay: 0.05)
        }
        
        FFBaseModel.sharedInstall.mCountDownTimeState = 0
        mFlagEnd2K = false
        mFlagShowPowerSeekBar = true
        delegate?.callbackForShowOrHidenYellow(nil, time: "")
        delegate?.callbackForProgress(10)
        delegate?.callbackForShowOrHidenProgress(true)
        mCurIndex = -1
        mCurSlowlyOnIndex = -1
        mCurSlowlyOffIndex = -1
        mCurSlowlyOn2Index = -1
        mCurSlowlyOff2Index = -1
        mFlagStop = true
        mFlagPauseDone = false
        
        for i in 0..<mCtrlPowerValueArray.count {
            mCtrlPowerValueArray[i] = 1;
        }
        
        delegate?.callbackForRefreshTimeLabel("20:00")
        delegate?.callbackForRefreshDurationLabel("00:00")
        delegate?.callbackForCountNumLabel("(0/0)")
        delegate?.callbackForStartOrPause(false)
    }
    
    func addPower() {
        if ((!mFlagEnd2K) && (FFBaseModel.sharedInstall.mCountDownTimeState != 0)) {
            
        } else {
            for i in 0..<mCtrlPowerValueArray.count {
                mCtrlPowerValueArray[i] += 1
                if(mCtrlPowerValueArray[i] > mMaxPowerValue) {
                    mCtrlPowerValueArray[i] = UInt8(mMaxPowerValue)
                }
            }
            
            var curTotalPowerValue = 0
            for i in 0..<mCtrlPowerValueArray.count {
                curTotalPowerValue += Int(mCtrlPowerValueArray[i])
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage2(what:)), object: V_MSG_SET_SEEKBAR)
            mFlagShowPowerSeekBar = true
            delegate?.callbackForShowOrHidenYellow(nil, time: "")
            delegate?.callbackForProgress(CGFloat(curTotalPowerValue))
            delegate?.callbackForShowOrHidenProgress(true)
            if (FFBaseModel.sharedInstall.mCountDownTimeState != 0) {
                perform(#selector(handleMessage2(what:)), with: V_MSG_SET_SEEKBAR, afterDelay: 1)
            }
            
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mAllPowerAddOne)
            }
        }
    }
    
    func reducePower() {
        if ((!mFlagEnd2K) && (FFBaseModel.sharedInstall.mCountDownTimeState != 0)) {
            
        } else {
            for i in 0..<mCtrlPowerValueArray.count {
                mCtrlPowerValueArray[i] -= 1
                if(mCtrlPowerValueArray[i] < mMinPowerValue) {
                    mCtrlPowerValueArray[i] = UInt8(mMinPowerValue)
                }
            }
            
            var curTotalPowerValue = 0
            for i in 0..<mCtrlPowerValueArray.count {
                curTotalPowerValue += Int(mCtrlPowerValueArray[i])
            }
            NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(handleMessage2(what:)), object: V_MSG_SET_SEEKBAR)
            mFlagShowPowerSeekBar = true
            delegate?.callbackForShowOrHidenYellow(nil, time: "")
            delegate?.callbackForProgress(CGFloat(curTotalPowerValue))
            delegate?.callbackForShowOrHidenProgress(true)
            if (FFBaseModel.sharedInstall.mCountDownTimeState != 0) {
                perform(#selector(handleMessage2(what:)), with: V_MSG_SET_SEEKBAR, afterDelay: 1)
            }
            
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mAllPowerDecOne)
            }
        }
    }
    
    func showVideoPic(_ index: Int, _ curSpendTime: Int) {
        print("[\(Date().toString())] showVideoPic: \(index) \(curSpendTime)")
        var temptime = 0
        let offtime = 650
        
        if (FFBaseModel.sharedInstall.mJsType == 80) {
            // 力量训练
            delegate?.callbackForShowOrHidenProgress(false)
            if ((mStrengthTime[index][1] & 0x10) != 0) {
                temptime = (offtime + mStrengthTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("11黄", time: "\(temptime)")
            } else if ((mStrengthTime[index][1] & 0x20) != 0) {
                temptime = (offtime + mStrengthTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("22红", time: "\(temptime)")
            } else if ((mStrengthTime[index][1] & 0x40) != 0) {
                temptime = (offtime + mStrengthTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("33黄", time: "\(temptime)")
            } else if ((mStrengthTime[index][1] & 0x80) != 0) {
                temptime = (offtime + mStrengthTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("44绿", time: "\(temptime)")
            } else {
                delegate?.callbackForShowOrHidenYellow(nil, time: "")
            }
        } else if (FFBaseModel.sharedInstall.mJsType == 81) {
            // 耐力训练
            delegate?.callbackForShowOrHidenProgress(false)
            if ((mNaiLiTime[index][1] & 0x10) != 0) {
                temptime = (offtime + mNaiLiTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("11黄", time: "\(temptime)")
            } else if ((mNaiLiTime[index][1] & 0x20) != 0) {
                temptime = (offtime + mNaiLiTime[index + 1][0] - curSpendTime) / 1000;
                delegate?.callbackForShowOrHidenYellow("22红", time: "\(temptime)")
            } else if ((mNaiLiTime[index][1] & 0x40) != 0) {
                temptime = (offtime + mNaiLiTime[index + 1][0] - curSpendTime) / 1000;
                delegate?.callbackForShowOrHidenYellow("33黄", time: "\(temptime)")
            } else if ((mNaiLiTime[index][1] & 0x80) != 0) {
                temptime = (offtime + mNaiLiTime[index + 1][0] - curSpendTime) / 1000;
                delegate?.callbackForShowOrHidenYellow("44绿", time: "\(temptime)")
            } else {
                delegate?.callbackForShowOrHidenYellow(nil, time: "")
            }
        } else if (FFBaseModel.sharedInstall.mJsType == 82) {
            // 肌肉增长
            delegate?.callbackForShowOrHidenProgress(false)
            if ((mJiRouTime[index][1] & 0x10) != 0) {
                temptime = (offtime + mJiRouTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("11黄", time: "\(temptime)")
            } else if ((mJiRouTime[index][1] & 0x20) != 0) {
                temptime = (offtime + mJiRouTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("22红", time: "\(temptime)")
            } else if ((mJiRouTime[index][1] & 0x40) != 0) {
                temptime = (offtime + mJiRouTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("33黄", time: "\(temptime)")
            } else if ((mJiRouTime[index][1] & 0x80) != 0) {
                temptime = (offtime + mJiRouTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("44绿", time: "\(temptime)")
            } else {
                delegate?.callbackForShowOrHidenYellow(nil, time: "")
            }
        } else if (FFBaseModel.sharedInstall.mJsType == 83) {
            // 燃烧脂肪
            delegate?.callbackForShowOrHidenProgress(false)
            if ((mFatBurnTime[index][1] & 0x10) != 0) {
                temptime = (offtime + mFatBurnTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("11黄", time: "\(temptime)")
            } else if ((mFatBurnTime[index][1] & 0x20) != 0) {
                temptime = (offtime + mFatBurnTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("22红", time: "\(temptime)")
            } else if ((mFatBurnTime[index][1] & 0x40) != 0) {
                temptime = (offtime + mFatBurnTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("33黄", time: "\(temptime)")
            } else if ((mFatBurnTime[index][1] & 0x80) != 0) {
                temptime = (offtime + mFatBurnTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("44绿", time: "\(temptime)")
            } else {
                delegate?.callbackForShowOrHidenYellow(nil, time: "")
            }
        } else if (FFBaseModel.sharedInstall.mJsType == 84) {
            // 放松身体
            delegate?.callbackForShowOrHidenProgress(false)
            if ((mRelaxTime[index][1] & 0x10) != 0) {
                temptime = (offtime + mRelaxTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("11黄", time: "\(temptime)")
            } else if ((mRelaxTime[index][1] & 0x20) != 0) {
                temptime = (offtime + mRelaxTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("22红", time: "\(temptime)")
            } else if ((mRelaxTime[index][1] & 0x40) != 0) {
                temptime = (offtime + mRelaxTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("33黄", time: "\(temptime)")
            } else if ((mRelaxTime[index][1] & 0x80) != 0) {
                temptime = (offtime + mRelaxTime[index + 1][0] - curSpendTime) / 1000
                delegate?.callbackForShowOrHidenYellow("44绿", time: "\(temptime)")
            } else {
                delegate?.callbackForShowOrHidenYellow(nil, time: "")
            }
        }
    }
    
    /// 是handleMessage中一部分
    private func showTime() {
        print("[\(Date().toString())] showTime")
        
        let totalSpendTime = mSpendTime + Int(Date().timeIntervalSince1970 * 1000) - mStartTime
        let totalLeftTime = 1200000 - totalSpendTime
        
        // 10秒钟之时执行停止2K的指令
        if !mFlagEnd2K && totalSpendTime >= TIME_FOR_2K {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mEnd2K)
            }
            mFlagEnd2K = true
        }
        
        if FFBaseModel.sharedInstall.mJsType == 80 {
            // 力量训练
            if mCurIndex < mStrengthTime.count - 1 && totalSpendTime >= mStrengthTime[mCurIndex + 1][0] {
                mCurIndex += 1
                // 当前处于第几个动作，然后发送该动作指令到设备端
                doStrengthCmd(mCurIndex)
            }
            
            if mCurSlowlyOnIndex < mStrengthSlowlyOnTime.count - 1 && totalSpendTime >= mStrengthSlowlyOnTime[mCurSlowlyOnIndex + 1] {
                mCurSlowlyOnIndex += 1
                // 当前处于第几个电压缓慢上升周期，然后发送电压缓慢上升指令到设备端
                doSlowlyOnOff(true)
            }
            
            if mCurSlowlyOffIndex < mStrengthSlowlyOffTime.count - 1 && totalSpendTime >= mStrengthSlowlyOffTime[mCurSlowlyOffIndex + 1] {
                mCurSlowlyOffIndex += 1
                // 当前处于第几个电压缓慢下降周期，然后发送电压缓慢下降指令到设备端
                doSlowlyOnOff(false)
            }
            
        } else if FFBaseModel.sharedInstall.mJsType == 81 {
            // 耐力训练
            if mCurIndex < mNaiLiTime.count - 1 && totalSpendTime >= mNaiLiTime[mCurIndex + 1][0] {
                mCurIndex += 1
                doNaiLiCmd(mCurIndex)
            }
            
            if mCurSlowlyOnIndex < mNaiLiSlowlyOnTime.count - 1 && totalSpendTime >= mNaiLiSlowlyOnTime[mCurSlowlyOnIndex + 1] {
                mCurSlowlyOnIndex += 1
                doSlowlyOnOff(true)
            }
            
            if mCurSlowlyOffIndex < mNaiLiSlowlyOffTime.count - 1 && totalSpendTime >= mNaiLiSlowlyOffTime[mCurSlowlyOffIndex + 1] {
                mCurSlowlyOffIndex += 1
                doSlowlyOnOff(false)
            }
        } else if FFBaseModel.sharedInstall.mJsType == 82 {
            // 肌肉增长
            if mCurIndex < mJiRouTime.count - 1 && totalSpendTime >= mJiRouTime[mCurIndex + 1][0] {
                mCurIndex += 1
                doJiRouCmd(mCurIndex)
            }
            
            // 电压缓慢上升状态1
            if mCurSlowlyOnIndex < mJiRouSlowlyOnTime.count - 1 && totalSpendTime >= mJiRouSlowlyOnTime[mCurSlowlyOnIndex + 1] {
                mCurSlowlyOnIndex += 1
                doSlowlyOnOff(true)
            }
            
            // 电压缓慢下降状态1
            if mCurSlowlyOffIndex < mJiRouSlowlyOffTime.count - 1 && totalSpendTime >= mJiRouSlowlyOffTime[mCurSlowlyOffIndex + 1] {
                mCurSlowlyOffIndex += 1
                doSlowlyOnOff(false)
            }
        } else if FFBaseModel.sharedInstall.mJsType == 83 {
            // 燃烧脂肪
            if mCurIndex < mFatBurnTime.count - 1 && totalSpendTime >= mFatBurnTime[mCurIndex + 1][0] {
                mCurIndex += 1
                doFatBurnCmd(mCurIndex)
            }
            
            if mCurSlowlyOnIndex < mFatBurnSlowlyOnTime.count - 1 && totalSpendTime >= mFatBurnSlowlyOnTime[mCurSlowlyOnIndex + 1] {
                mCurSlowlyOnIndex += 1
                doSlowlyOnOff(true)
            }
            
            if mCurSlowlyOffIndex < mFatBurnSlowlyOffTime.count - 1 && totalSpendTime >= mFatBurnSlowlyOffTime[mCurSlowlyOffIndex + 1] {
                mCurSlowlyOffIndex += 1
                doSlowlyOnOff(false)
            }
        } else if FFBaseModel.sharedInstall.mJsType == 84 {
            // 放松身体
            if mCurIndex < mRelaxTime.count - 1 && totalSpendTime >= mRelaxTime[mCurIndex + 1][0] {
                mCurIndex += 1
                doRelaxCmd(mCurIndex)
            }
            
            if mCurSlowlyOnIndex < mRelaxSlowlyOnTime.count - 1 && totalSpendTime >= mRelaxSlowlyOnTime[mCurSlowlyOnIndex + 1] {
                mCurSlowlyOnIndex += 1
                // 当前处于第几个电压缓慢上升周期，然后发送电压缓慢上升指令到设备端
                doSlowlyOnOff(true)
            }
            
            if mCurSlowlyOffIndex < mRelaxSlowlyOffTime.count - 1 && totalSpendTime >= mRelaxSlowlyOffTime[mCurSlowlyOffIndex + 1] {
                mCurSlowlyOffIndex += 1
                // 当前处于第几个电压缓慢下降周期，然后发送电压缓慢下降指令到设备端
                doSlowlyOnOff(false)
            }
        }
        
        if totalLeftTime <= 0 {
            // 倒计时完成
            mFinishTime = 1200
            delegate?.callbackForRefreshTimeLabel("00:00")
            delegate?.callbackForRefreshDurationLabel("00:00")
            FFBaseModel.sharedInstall.mCountDownTimeState = 3
            perform(#selector(handleMessage(what:)), with: V_MSG_STOP, afterDelay: 1)
        } else {
            // 倒计时进行中
            let minute = totalLeftTime / 60000
            let second = (totalLeftTime / 1000) % 60
            let formatTime = String(format: "%02.0f:%02.0f", Float(minute), Float(second))
            //总倒计时时间显示
            delegate?.callbackForRefreshTimeLabel(formatTime)
            
            if FFBaseModel.sharedInstall.mJsType == 80 {
                // 力量训练
                for i in (1...mStrengthSubStepTime.count).reversed() {
                    if totalSpendTime >= mStrengthSubStepTime[i - 1] {
                        // 子步骤到了第i个步骤
                        let subSpendTime = totalSpendTime - mStrengthSubStepTime[i - 1]
                        var subTotalTime = 0
                        if i == mStrengthSubStepTime.count {
                            subTotalTime = 1200000 - mStrengthSubStepTime[i - 1]
                        } else {
                            subTotalTime = mStrengthSubStepTime[i] - mStrengthSubStepTime[i - 1]
                        }
                        let subLeftTime = subTotalTime - subSpendTime
                        let min = subLeftTime / 60000
                        let sec = (subLeftTime / 1000) % 60
                        let subformatTime = String(format: "%02.0f:%02.0f", Float(min), Float(sec))
                        // 子倒计时时间显示
                        delegate?.callbackForRefreshDurationLabel(subformatTime)
                        // 子倒计时当前步骤显示
                        // 子倒计时总步骤显示
                        delegate?.callbackForCountNumLabel("(\(i)/\(mStrengthSubStepTime.count))")
                        break
                    }
                }
            } else if FFBaseModel.sharedInstall.mJsType == 81 {
                // 耐力训练
                for i in (1...mNaiLiSubStepTime.count).reversed() {
                    if totalSpendTime >= mNaiLiSubStepTime[i - 1] {
                        let subSpendTime = totalSpendTime - mNaiLiSubStepTime[i - 1]
                        var subTotalTime = 0
                        if i == mNaiLiSubStepTime.count {
                            subTotalTime = 1200000 - mNaiLiSubStepTime[i - 1]
                        } else {
                            subTotalTime = mNaiLiSubStepTime[i] - mNaiLiSubStepTime[i - 1]
                        }
                        let subLeftTime = subTotalTime - subSpendTime
                        let min = subLeftTime / 60000
                        let sec = (subLeftTime / 1000) % 60
                        let subformatTime = String(format: "%02.0f:%02.0f", Float(min), Float(sec))
                        // 子倒计时时间显示
                        delegate?.callbackForRefreshDurationLabel(subformatTime)
                        // 子倒计时当前步骤显示
                        // 子倒计时总步骤显示
                        delegate?.callbackForCountNumLabel("(\(i)/\(mNaiLiSubStepTime.count))")
                        break
                    }
                }
            } else if FFBaseModel.sharedInstall.mJsType == 82 {
                // 肌肉增长
                for i in (1...mJiRouSubStepTime.count).reversed() {
                    if totalSpendTime >= mJiRouSubStepTime[i - 1] {
                        let subSpendTime = totalSpendTime - mJiRouSubStepTime[i - 1]
                        var subTotalTime = 0
                        if i == mJiRouSubStepTime.count {
                            subTotalTime = 1200000 - mJiRouSubStepTime[i - 1]
                        } else {
                            subTotalTime = mJiRouSubStepTime[i] - mJiRouSubStepTime[i - 1]
                        }
                        let subLeftTime = subTotalTime - subSpendTime
                        let min = subLeftTime / 60000
                        let sec = (subLeftTime / 1000) % 60
                        let subformatTime = String(format: "%02.0f:%02.0f", Float(min), Float(sec))
                        // 子倒计时时间显示
                        delegate?.callbackForRefreshDurationLabel(subformatTime)
                        // 子倒计时当前步骤显示
                        // 子倒计时总步骤显示
                        delegate?.callbackForCountNumLabel("(\(i)/\(mJiRouSubStepTime.count))")
                        break
                    }
                }
            } else if FFBaseModel.sharedInstall.mJsType == 83 {
                // 燃烧脂肪
                for i in (1...mFatBurnSubStepTime.count).reversed() {
                    if totalSpendTime >= mFatBurnSubStepTime[i - 1] {
                        let subSpendTime = totalSpendTime - mFatBurnSubStepTime[i - 1]
                        var subTotalTime = 0
                        if i == mFatBurnSubStepTime.count {
                            subTotalTime = 1200000 - mFatBurnSubStepTime[i - 1]
                        } else {
                            subTotalTime = mFatBurnSubStepTime[i] - mFatBurnSubStepTime[i - 1]
                        }
                        let subLeftTime = subTotalTime - subSpendTime
                        let min = subLeftTime / 60000
                        let sec = (subLeftTime / 1000) % 60
                        let subformatTime = String(format: "%02.0f:%02.0f", Float(min), Float(sec))
                        // 子倒计时时间显示
                        delegate?.callbackForRefreshDurationLabel(subformatTime)
                        // 子倒计时当前步骤显示
                        // 子倒计时总步骤显示
                        delegate?.callbackForCountNumLabel("(\(i)/\(mFatBurnSubStepTime.count))")
                        break
                    }
                }
            } else if FFBaseModel.sharedInstall.mJsType == 84 {
                // 放松身体
                for i in (1...mRelaxSubStepTime.count).reversed() {
                    if totalSpendTime >= mRelaxSubStepTime[i - 1] {
                        // 子步骤到了第i个步骤
                        let subSpendTime = totalSpendTime - mRelaxSubStepTime[i - 1]
                        var subTotalTime = 0
                        if i == mRelaxSubStepTime.count {
                            subTotalTime = 1200000 - mRelaxSubStepTime[i - 1]
                        } else {
                            subTotalTime = mRelaxSubStepTime[i] - mRelaxSubStepTime[i - 1]
                        }
                        let subLeftTime = subTotalTime - subSpendTime
                        let min = subLeftTime / 60000
                        let sec = (subLeftTime / 1000) % 60
                        let subformatTime = String(format: "%02.0f:%02.0f", Float(min), Float(sec))
                        // 子倒计时时间显示
                        delegate?.callbackForRefreshDurationLabel(subformatTime)
                        // 子倒计时当前步骤显示
                        // 子倒计时总步骤显示
                        delegate?.callbackForCountNumLabel("(\(i)/\(mRelaxSubStepTime.count))")
                        break
                    }
                }
            }
            
            if !mFlagShowPowerSeekBar && mCurIndex >= 0 {
                showVideoPic(mCurIndex, totalSpendTime)
            }
            
            perform(#selector(handleMessage(what:)), with: V_MSG_SHOW_TIME, afterDelay: 0.1)
        }
    }
    
    @objc func handleMessage(what: V) {
        print("[\(Date().toString())] 处理信息：\(what.value)")
        let what: Int = what.value
        if what == MSG_SHOW_TIME {
            showTime()
        } else if what == MSG_SET_POWER1 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[0][2] = mCtrlPowerValueArray[0]
                handle.writeData(mPowerValueArray[0])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER2, afterDelay: 0.05)
        } else if what == MSG_SET_POWER2 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[1][2] = mCtrlPowerValueArray[1]
                handle.writeData(mPowerValueArray[1])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER3, afterDelay: 0.05)
        } else if what == MSG_SET_POWER3 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[2][2] = mCtrlPowerValueArray[2]
                handle.writeData(mPowerValueArray[2])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER4, afterDelay: 0.05)
        } else if what == MSG_SET_POWER4 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[3][2] = mCtrlPowerValueArray[3]
                handle.writeData(mPowerValueArray[3])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER5, afterDelay: 0.05)
        } else if what == MSG_SET_POWER5 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[4][2] = mCtrlPowerValueArray[4]
                handle.writeData(mPowerValueArray[4])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER6, afterDelay: 0.05)
        } else if what == MSG_SET_POWER6 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[5][2] = mCtrlPowerValueArray[5]
                handle.writeData(mPowerValueArray[5])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER7, afterDelay: 0.05)
        } else if what == MSG_SET_POWER7 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[6][2] = mCtrlPowerValueArray[6]
                handle.writeData(mPowerValueArray[6])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER8, afterDelay: 0.05)
        } else if what == MSG_SET_POWER8 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[7][2] = mCtrlPowerValueArray[7]
                handle.writeData(mPowerValueArray[7])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER9, afterDelay: 0.05)
        } else if what == MSG_SET_POWER9 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[8][2] = mCtrlPowerValueArray[8]
                handle.writeData(mPowerValueArray[8])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_POWER10, afterDelay: 0.05)
        } else if what == MSG_SET_POWER10 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[9][2] = mCtrlPowerValueArray[9]
                handle.writeData(mPowerValueArray[9])
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_CTRL1, afterDelay: 0.05)
        } else if what == MSG_SET_CTRL1 {
            // 左侧5组打开/关闭状态
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mCtrlArray1)
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_SET_CTRL2, afterDelay: 0.05)
        } else if what == MSG_SET_CTRL2 {
            // 右侧5组打开/关闭状态
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mCtrlArray2)
            }
            perform(#selector(handleMessage(what:)), with: V_MSG_INIT_EXTEND, afterDelay: 0.05)
        } else if what == MSG_INIT_EXTEND {
            // 初始化完参数后通知设备端
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mInitExtend)
            }
            mStartTime = Int(Date().timeIntervalSince1970 * 1000)
            perform(#selector(handleMessage(what:)), with: V_MSG_SHOW_TIME, afterDelay: 0.05)
        } else if what == MSG_STOP {
            // 倒计时完成
            onTimeStop()
            delegate?.callbackForShowFinishDialog(sportName())
        } else if what == MSG_TOAST {
            delegate?.callbackForShowMessage("设备断开连接，运动停止！")
        }
    }
    
    @objc func handleMessage2(what: V) {
        let whatValue: Int = what.value
        if (whatValue == MSG_SET_CTRL2_EXTTEND) {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady {
                handle.writeData(mCtrlArray2)
            }
        } else if (whatValue == MSG_DEINIT_EXTEND) {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady {
                handle.writeData(mDeInitExtend)
            }
        } else if (whatValue == MSG_SET_PROGRESS_UP) {
            
        } else if (whatValue == MSG_SET_PROGRESS_DOWN) {
            
        } else if (whatValue == MSG_SET_SEEKBAR) {
            mFlagShowPowerSeekBar = false
        }
    }
    
    // 电压缓慢上升或下降
    private func doSlowlyOnOff(_ value: Bool) {
        if value {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady {
                handle.writeData(mSlowlyOn)
            }
        } else {
            if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
                FFBaseModel.sharedInstall.commandReady {
                handle.writeData(mSlowlyOff)
            }
        }
    }
    
    /// 获取设备完成的提示框的提示信息
    ///
    /// - Returns: 信息
    private func sportName() -> String {
        if FFBaseModel.sharedInstall.mJsType >= 80 && (FFBaseModel.sharedInstall.mJsType - 80) < itemNames.count {
            var name = "项目：\(itemNames[FFBaseModel.sharedInstall.mJsType - 80])"
            var minute = 0
            var second = 0
            minute = mFinishTime / 60
            second = mFinishTime % 60
            name += "\n 时长：\(minute)分\(second)秒"
            return name
        }
        return ""
    }
    
    /// 结束锻炼
    public func kill() {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
            handle.writeData(mDeInit)
        }
    }
}

class V: NSObject {
    var value: Int = 0
    
    init(_ value: Int) {
        self.value = value
    }
}
