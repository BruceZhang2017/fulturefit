//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFExerciseModelService.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/22.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import AudioToolbox

class FFExerciseModelService: NSObject {
    
    private let bleConnectStatusKeyPath = "bleConnectStatus" // BLE连接状态
    private weak var delegate: FFExerciseModelServiceDelegate!
    var mStartTime = 0
    var mSpendTime = 0
    private let handle = FFCommandHandle()
    
    init(delegate: FFExerciseModelServiceDelegate) {
        self.delegate = delegate
        super.init()
        startKVO()
    }
    
    deinit {
        endKVO()
    }
    
    /// 开始KVO监听BLE连接状态
    private func startKVO() {
        FFBaseModel.sharedInstall.addObserver(self, forKeyPath: bleConnectStatusKeyPath, options: .new, context: nil)
    }
    
    /// 结束KVO监听BLE连接状态
    private func endKVO() {
        FFBaseModel.sharedInstall.removeObserver(self, forKeyPath: bleConnectStatusKeyPath)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == bleConnectStatusKeyPath {
            delegate?.callbackForBLEState(FFBaseModel.sharedInstall.bleConnectStatus >= 2)
        } else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    /// 实现震动功能
    func vibrator() {
        let soundID = SystemSoundID(kSystemSoundID_Vibrate)
        AudioServicesPlaySystemSound(soundID)
    }
    
    /// 开始
    func startSport() {
        handle.startSport()
    }
    
    func showTime() {
//        let totalSpendTime = (int)(mSpendTime + System.currentTimeMillis() - mStartTime);
//        int totalLeftTime = 1200000 - totalSpendTime;
//
//        // 10秒钟之时执行停止2K的指令
//        if ((!mFlagEnd2K) && (totalSpendTime >= TIME_FOR_2K)) {
//            if (connect_status_bit && mConnected && (mBluetoothLeService != null) && (mCountDownTimeState != 0)){
//                mBluetoothLeService.txxx(mEnd2K,true);
//            }
//            mFlagEnd2K = true;
//        }
//
//        if (mJsType == 80) {
//            // 力量训练
//            if ((mCurIndex < mStrengthTime.length - 1) && (totalSpendTime >= mStrengthTime[mCurIndex + 1][0])) {
//                mCurIndex++;
//                // 当前处于第几个动作，然后发送该动作指令到设备端
//                doStrengthCmd(mCurIndex);
//            }
//
//            if ((mCurSlowlyOnIndex < mStrengthSlowlyOnTime.length - 1) && (totalSpendTime >= mStrengthSlowlyOnTime[mCurSlowlyOnIndex + 1])) {
//                mCurSlowlyOnIndex++;
//                // 当前处于第几个电压缓慢上升周期，然后发送电压缓慢上升指令到设备端
//                doSlowlyOnOff(true);
//            }
//
//            if ((mCurSlowlyOffIndex < mStrengthSlowlyOffTime.length - 1) && (totalSpendTime >= mStrengthSlowlyOffTime[mCurSlowlyOffIndex + 1])) {
//                mCurSlowlyOffIndex++;
//                // 当前处于第几个电压缓慢下降周期，然后发送电压缓慢下降指令到设备端
//                doSlowlyOnOff(false);
//            }
//
//        } else if (mJsType == 81) {
//            // 耐力训练
//            if ((mCurIndex < mNaiLiTime.length - 1) && (totalSpendTime >= mNaiLiTime[mCurIndex + 1][0])) {
//                mCurIndex++;
//                doNaiLiCmd(mCurIndex);
//            }
//
//            if ((mCurSlowlyOnIndex < mNaiLiSlowlyOnTime.length - 1) && (totalSpendTime >= mNaiLiSlowlyOnTime[mCurSlowlyOnIndex + 1])) {
//                mCurSlowlyOnIndex++;
//                doSlowlyOnOff(true);
//            }
//
//            if ((mCurSlowlyOffIndex < mNaiLiSlowlyOffTime.length - 1) && (totalSpendTime >= mNaiLiSlowlyOffTime[mCurSlowlyOffIndex + 1])) {
//                mCurSlowlyOffIndex++;
//                doSlowlyOnOff(false);
//            }
//        } else if (mJsType == 82) {
//            // 肌肉增长
//            if ((mCurIndex < mJiRouTime.length - 1) && (totalSpendTime >= mJiRouTime[mCurIndex + 1][0])) {
//                mCurIndex++;
//                doJiRouCmd(mCurIndex);
//            }
//
//            // 电压缓慢上升状态1
//            if ((mCurSlowlyOnIndex < mJiRouSlowlyOnTime.length - 1) && (totalSpendTime >= mJiRouSlowlyOnTime[mCurSlowlyOnIndex + 1])) {
//                mCurSlowlyOnIndex++;
//                doSlowlyOnOff(true);
//            }
//
//            // 电压缓慢下降状态1
//            if ((mCurSlowlyOffIndex < mJiRouSlowlyOffTime.length - 1) && (totalSpendTime >= mJiRouSlowlyOffTime[mCurSlowlyOffIndex + 1])) {
//                mCurSlowlyOffIndex++;
//                doSlowlyOnOff(false);
//            }
//            /*
//             // 电压缓慢上升状态2
//             if ((mCurSlowlyOn2Index < mJiRouSlowly2OnTime.length - 1) && (totalSpendTime >= mJiRouSlowly2OnTime[mCurSlowlyOn2Index + 1])) {
//             mCurSlowlyOn2Index++;
//             doSlowlyOnOff2(true);
//             }
//
//             // 电压缓慢下降状态2
//             if ((mCurSlowlyOff2Index < mJiRouSlowly2OffTime.length - 1) && (totalSpendTime >= mJiRouSlowly2OffTime[mCurSlowlyOff2Index + 1])) {
//             mCurSlowlyOff2Index++;
//             doSlowlyOnOff2(false);
//             }
//             */
//        } else if (mJsType == 83) {
//            // 燃烧脂肪
//            if ((mCurIndex < mFatBurnTime.length - 1) && (totalSpendTime >= mFatBurnTime[mCurIndex + 1][0])) {
//                mCurIndex++;
//                doFatBurnCmd(mCurIndex);
//            }
//
//            if ((mCurSlowlyOnIndex < mFatBurnSlowlyOnTime.length - 1) && (totalSpendTime >= mFatBurnSlowlyOnTime[mCurSlowlyOnIndex + 1])) {
//                mCurSlowlyOnIndex++;
//                doSlowlyOnOff(true);
//            }
//
//            if ((mCurSlowlyOffIndex < mFatBurnSlowlyOffTime.length - 1) && (totalSpendTime >= mFatBurnSlowlyOffTime[mCurSlowlyOffIndex + 1])) {
//                mCurSlowlyOffIndex++;
//                doSlowlyOnOff(false);
//            }
//        } else if (mJsType == 84) {
//            // 放松身体
//            if ((mCurIndex < mRelaxTime.length - 1) && (totalSpendTime >= mRelaxTime[mCurIndex + 1][0])) {
//                mCurIndex++;
//                doRelaxCmd(mCurIndex);
//            }
//
//            if ((mCurSlowlyOnIndex < mRelaxSlowlyOnTime.length - 1) && (totalSpendTime >= mRelaxSlowlyOnTime[mCurSlowlyOnIndex + 1])) {
//                mCurSlowlyOnIndex++;
//                // 当前处于第几个电压缓慢上升周期，然后发送电压缓慢上升指令到设备端
//                doSlowlyOnOff(true);
//            }
//
//            if ((mCurSlowlyOffIndex < mRelaxSlowlyOffTime.length - 1) && (totalSpendTime >= mRelaxSlowlyOffTime[mCurSlowlyOffIndex + 1])) {
//                mCurSlowlyOffIndex++;
//                // 当前处于第几个电压缓慢下降周期，然后发送电压缓慢下降指令到设备端
//                doSlowlyOnOff(false);
//            }
//        }
//
//        if (totalLeftTime <= 0) {
//            // 倒计时完成
//            mFinishTime = 1200;
//            mTimeText.setText("00:00");
//            mSubTimeText.setText("00:00");
//            mCountDownTimeState = 3;
//            mHandler.sendEmptyMessageDelayed(MSG_STOP,1000);
//        } else {
//            // 倒计时进行中
//            int minute = totalLeftTime / 60000;
//            int second = (totalLeftTime / 1000) % 60;
//            String formatTime = String.format("%02d:%02d", minute, second);
//            //总倒计时时间显示
//            mTimeText.setText(formatTime);
//
//            if (mJsType == 80) {
//                // 力量训练
//                for(int i = mStrengthSubStepTime.length; i > 0; i--){
//                    if (totalSpendTime >= mStrengthSubStepTime[i - 1]) {
//                        // 子步骤到了第i个步骤
//                        int subSpendTime = totalSpendTime - mStrengthSubStepTime[i - 1];
//                        int subTotalTime;
//                        if (i == mStrengthSubStepTime.length) {
//                            subTotalTime = 1200000 - mStrengthSubStepTime[i - 1];
//                        } else {
//                            subTotalTime = mStrengthSubStepTime[i] - mStrengthSubStepTime[i - 1];
//                        }
//                        int subLeftTime = subTotalTime - subSpendTime;
//                        int min = subLeftTime / 60000;
//                        int sec = (subLeftTime / 1000) % 60;
//                        String subformatTime = String.format("%02d:%02d", min, sec);
//                        // 子倒计时时间显示
//                        mSubTimeText.setText(subformatTime);
//                        // 子倒计时当前步骤显示
//                        mSubCountNumText.setText("" + i);
//                        // 子倒计时总步骤显示
//                        mTotalCountNumText.setText("" + mStrengthSubStepTime.length);
//                        break;
//                    }
//                }
//            } else if (mJsType == 81) {
//                // 耐力训练
//                for(int i = mNaiLiSubStepTime.length; i > 0; i--){
//                    if (totalSpendTime >= mNaiLiSubStepTime[i - 1]) {
//                        int subSpendTime = totalSpendTime - mNaiLiSubStepTime[i - 1];
//                        int subTotalTime;
//                        if (i == mNaiLiSubStepTime.length) {
//                            subTotalTime = 1200000 - mNaiLiSubStepTime[i - 1];
//                        } else {
//                            subTotalTime = mNaiLiSubStepTime[i] - mNaiLiSubStepTime[i - 1];
//                        }
//                        int subLeftTime = subTotalTime - subSpendTime;
//                        int min = subLeftTime / 60000;
//                        int sec = (subLeftTime / 1000) % 60;
//                        String subformatTime = String.format("%02d:%02d", min, sec);
//                        mSubTimeText.setText(subformatTime);
//                        mSubCountNumText.setText("" + i);
//                        mTotalCountNumText.setText("" + mNaiLiSubStepTime.length);
//                        break;
//                    }
//                }
//            } else if (mJsType == 82) {
//                // 肌肉增长
//                for(int i = mJiRouSubStepTime.length; i > 0; i--){
//                    if (totalSpendTime >= mJiRouSubStepTime[i - 1]) {
//                        int subSpendTime = totalSpendTime - mJiRouSubStepTime[i - 1];
//                        int subTotalTime;
//                        if (i == mJiRouSubStepTime.length) {
//                            subTotalTime = 1200000 - mJiRouSubStepTime[i - 1];
//                        } else {
//                            subTotalTime = mJiRouSubStepTime[i] - mJiRouSubStepTime[i - 1];
//                        }
//                        int subLeftTime = subTotalTime - subSpendTime;
//                        int min = subLeftTime / 60000;
//                        int sec = (subLeftTime / 1000) % 60;
//                        String subformatTime = String.format("%02d:%02d", min, sec);
//                        mSubTimeText.setText(subformatTime);
//                        mSubCountNumText.setText("" + i);
//                        mTotalCountNumText.setText("" + mJiRouSubStepTime.length);
//                        break;
//                    }
//                }
//            } else if (mJsType == 83) {
//                // 燃烧脂肪
//                for(int i = mFatBurnSubStepTime.length; i > 0; i--){
//                    if (totalSpendTime >= mFatBurnSubStepTime[i - 1]) {
//                        int subSpendTime = totalSpendTime - mFatBurnSubStepTime[i - 1];
//                        int subTotalTime;
//                        if (i == mFatBurnSubStepTime.length) {
//                            subTotalTime = 1200000 - mFatBurnSubStepTime[i - 1];
//                        } else {
//                            subTotalTime = mFatBurnSubStepTime[i] - mFatBurnSubStepTime[i - 1];
//                        }
//                        int subLeftTime = subTotalTime - subSpendTime;
//                        int min = subLeftTime / 60000;
//                        int sec = (subLeftTime / 1000) % 60;
//                        String subformatTime = String.format("%02d:%02d", min, sec);
//                        mSubTimeText.setText(subformatTime);
//                        mSubCountNumText.setText("" + i);
//                        mTotalCountNumText.setText("" + mFatBurnSubStepTime.length);
//                        break;
//                    }
//                }
//            } else if (mJsType == 84) {
//                // 放松身体
//                for(int i = mRelaxSubStepTime.length; i > 0; i--){
//                    if (totalSpendTime >= mRelaxSubStepTime[i - 1]) {
//                        // 子步骤到了第i个步骤
//                        int subSpendTime = totalSpendTime - mRelaxSubStepTime[i - 1];
//                        int subTotalTime;
//                        if (i == mRelaxSubStepTime.length) {
//                            subTotalTime = 1200000 - mRelaxSubStepTime[i - 1];
//                        } else {
//                            subTotalTime = mRelaxSubStepTime[i] - mRelaxSubStepTime[i - 1];
//                        }
//                        int subLeftTime = subTotalTime - subSpendTime;
//                        int min = subLeftTime / 60000;
//                        int sec = (subLeftTime / 1000) % 60;
//                        String subformatTime = String.format("%02d:%02d", min, sec);
//                        // 子倒计时时间显示
//                        mSubTimeText.setText(subformatTime);
//                        // 子倒计时当前步骤显示
//                        mSubCountNumText.setText("" + i);
//                        // 子倒计时总步骤显示
//                        mTotalCountNumText.setText("" + mRelaxSubStepTime.length);
//                        break;
//                    }
//                }
//            }
//
//            if ((!mFlagShowPowerSeekBar) && (mCurIndex >= 0)) {
//                showVideoPic(mCurIndex, totalSpendTime);
//            }
//
//            mHandler.sendEmptyMessageDelayed(MSG_SHOW_TIME, 100);
//        }
    }
    
    @objc func handleMessage(what: Int) {
        if what == MSG_SHOW_TIME {
            
        } else if what == MSG_SET_POWER1 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[0][2] = mCtrlPowerValueArray[0]
                handle.writeData(mPowerValueArray[0])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER2, afterDelay: 0.05)
        } else if what == MSG_SET_POWER2 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[1][2] = mCtrlPowerValueArray[1]
                handle.writeData(mPowerValueArray[1])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER3, afterDelay: 0.05)
        } else if what == MSG_SET_POWER3 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[2][2] = mCtrlPowerValueArray[2]
                handle.writeData(mPowerValueArray[2])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER4, afterDelay: 0.05)
        } else if what == MSG_SET_POWER4 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[3][2] = mCtrlPowerValueArray[3]
               handle.writeData(mPowerValueArray[3])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER5, afterDelay: 0.05)
        } else if what == MSG_SET_POWER5 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[4][2] = mCtrlPowerValueArray[4]
                handle.writeData(mPowerValueArray[4])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER6, afterDelay: 0.05)
        } else if what == MSG_SET_POWER6 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[5][2] = mCtrlPowerValueArray[5]
                handle.writeData(mPowerValueArray[5])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER7, afterDelay: 0.05)
        } else if what == MSG_SET_POWER7 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[6][2] = mCtrlPowerValueArray[6]
                handle.writeData(mPowerValueArray[6])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER8, afterDelay: 0.05)
        } else if what == MSG_SET_POWER8 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[7][2] = mCtrlPowerValueArray[7]
                handle.writeData(mPowerValueArray[7])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER9, afterDelay: 0.05)
        } else if what == MSG_SET_POWER9 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[8][2] = mCtrlPowerValueArray[8]
                handle.writeData(mPowerValueArray[8])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_POWER10, afterDelay: 0.05)
        } else if what == MSG_SET_POWER10 {
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                mPowerValueArray[9][2] = mCtrlPowerValueArray[9]
                handle.writeData(mPowerValueArray[9])
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_CTRL1, afterDelay: 0.05)
        } else if what == MSG_SET_CTRL1 {
            // 左侧5组打开/关闭状态
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mCtrlArray1)
            }
            perform(#selector(handleMessage(what:)), with: MSG_SET_CTRL2, afterDelay: 0.05)
        } else if what == MSG_SET_CTRL2 {
            // 右侧5组打开/关闭状态
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mCtrlArray2)
            }
            perform(#selector(handleMessage(what:)), with: MSG_INIT_EXTEND, afterDelay: 0.05)
        } else if what == MSG_INIT_EXTEND {
            // 初始化完参数后通知设备端
            if FFBaseModel.sharedInstall.bleConnectStatus == 3 &&
                FFBaseModel.sharedInstall.commandReady &&
                FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
                handle.writeData(mInitExtend)
            }
            mStartTime = Int(Date().timeIntervalSince1970)
            perform(#selector(handleMessage(what:)), with: MSG_SHOW_TIME, afterDelay: 0.05)
        } else if what == MSG_STOP {
            // 倒计时完成
            //onTimeStop(null);
            //ShowFinishDialog();
            let message = ""
        } else if what == MSG_TOAST {
            delegate?.callbackForShowMessage("设备断开连接，运动停止！")
        }
    }
    
    private func sportName() -> String {
        if FFBaseModel.sharedInstall.mJsType >= 80 {
            
        }
        return ""
    }
}

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
}
