//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFExerciseModelService3.swift
//  FultureFit
//
//  Created by ANKER on 2019/8/23.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

extension FFExerciseModelService {
    /// 力量训练
    ///
    /// - Parameter i: index
    func doStrengthCmd(_ i: Int) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 力量训练
            if FFBaseModel.sharedInstall.mJsType == 80 {
                
                if mStrengthTime[i][0] < 60000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn1)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff1)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] < 360000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn2)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff2)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] < 600000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn3)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff3)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] < 900000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn4)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff4)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] < 1140000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn5)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff5)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] < 1200000 {
                    
                    if mStrengthTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mStrengthOn6)
                        mFlagStop = false
                    } else if mStrengthTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mStrengthOff6)
                        mFlagStop = true
                    }
                } else if mStrengthTime[i][0] == 1200000 {
                    handle.writeData(mDeInit)
                }
            }
        }
    }
    
    /// 力量训练中止或重新开始
    ///
    /// - Parameters:
    ///   - i: index
    ///   - pauseAndresume: 中止或重新开始
    func doStrengthCmdPause(_ i: Int, _ pauseAndresume: Bool) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 力量训练
            if (FFBaseModel.sharedInstall.mJsType == 80 && i >= 0) {
                
                if (pauseAndresume && !mFlagStop) {
                    if (mStrengthTime[i][0] < 60000) {
                        handle.writeData(mStrengthOff1)
                        mFlagStop = true
                    } else if (mStrengthTime[i][0] < 360000) {
                        handle.writeData(mStrengthOff2)
                        mFlagStop = true
                    } else if (mStrengthTime[i][0] < 600000) {
                        handle.writeData(mStrengthOff3)
                        mFlagStop = true
                    } else if (mStrengthTime[i][0] < 900000) {
                        handle.writeData(mStrengthOff4)
                        mFlagStop = true
                    } else if (mStrengthTime[i][0] < 1140000) {
                        handle.writeData(mStrengthOff5)
                        mFlagStop = true
                    } else if (mStrengthTime[i][0] < 1200000) {
                        handle.writeData(mStrengthOff6)
                        mFlagStop = true
                    }
                    
                    mFlagPauseDone = true
                }
                
                if (!pauseAndresume && mFlagStop && mFlagPauseDone) {
                    if (mStrengthTime[i][0] < 60000) {
                        handle.writeData(mStrengthOn1)
                        mFlagStop = false
                    } else if (mStrengthTime[i][0] < 360000) {
                        handle.writeData(mStrengthOn2)
                        mFlagStop = false
                    } else if (mStrengthTime[i][0] < 600000) {
                        handle.writeData(mStrengthOn3)
                        mFlagStop = false
                    } else if (mStrengthTime[i][0] < 900000) {
                        handle.writeData(mStrengthOn4)
                        mFlagStop = false
                    } else if (mStrengthTime[i][0] < 1140000) {
                        handle.writeData(mStrengthOn5)
                        mFlagStop = false
                    } else if (mStrengthTime[i][0] < 1200000) {
                        handle.writeData(mStrengthOn6)
                        mFlagStop = false
                    }
                    
                    mFlagPauseDone = false
                }
            }
        }
    }
    
    /// 耐力训练
    ///
    /// - Parameter i: index
    func doNaiLiCmd(_ i: Int) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 耐力训练
            if FFBaseModel.sharedInstall.mJsType == 81 {
                
                if mNaiLiTime[i][0] < 180000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn1)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff1)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 240000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn2)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff2)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 300000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn3)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff3)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 360000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn4)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff4)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 420000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn5)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff5)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 480000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn6)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff6)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 540000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn7)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff7)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 660000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn8)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff8)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 720000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn9)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff9)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 840000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn10)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff10)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 960000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn11)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff11)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 1080000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn12)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff12)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] < 1200000 {
                    
                    if mNaiLiTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mNaiLiOn13)
                        mFlagStop = false
                    } else if mNaiLiTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mNaiLiOff13)
                        mFlagStop = true
                    }
                } else if mNaiLiTime[i][0] == 1200000 {
                    handle.writeData(mDeInit)
                }
            }
        }
    }
    
    /// 耐力训练中止或重新开始
    ///
    /// - Parameters:
    ///   - i: 需要
    ///   - pauseAndresume: 中止或重新开始
    func doNaiLiCmdPause(_ i: Int, _ pauseAndresume: Bool) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 耐力训练
            if (FFBaseModel.sharedInstall.mJsType == 81 && i >= 0) {
                
                if (pauseAndresume && !mFlagStop) {
                    if (mNaiLiTime[i][0] < 180000) {
                        handle.writeData(mNaiLiOff1)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 240000) {
                        handle.writeData(mNaiLiOff2)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 300000) {
                        handle.writeData(mNaiLiOff3)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 360000) {
                        handle.writeData(mNaiLiOff4)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 420000) {
                        handle.writeData(mNaiLiOff5)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 480000) {
                        handle.writeData(mNaiLiOff6)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 540000) {
                        handle.writeData(mNaiLiOff7)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 660000) {
                        handle.writeData(mNaiLiOff8)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 720000) {
                        handle.writeData(mNaiLiOff9)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 840000) {
                        handle.writeData(mNaiLiOff10)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 960000) {
                        handle.writeData(mNaiLiOff11)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 1080000) {
                        handle.writeData(mNaiLiOff12)
                        mFlagStop = true
                    } else if (mNaiLiTime[i][0] < 1200000) {
                        handle.writeData(mNaiLiOff13)
                        mFlagStop = true
                    }
                    
                    mFlagPauseDone = true
                }
                
                if (!pauseAndresume && mFlagStop && mFlagPauseDone) {
                    if (mNaiLiTime[i][0] < 180000) {
                        handle.writeData(mNaiLiOn1)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 240000) {
                        handle.writeData(mNaiLiOn2)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 300000) {
                        handle.writeData(mNaiLiOn3)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 360000) {
                        handle.writeData(mNaiLiOn4)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 420000) {
                        handle.writeData(mNaiLiOn5)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 480000) {
                        handle.writeData(mNaiLiOn6)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 540000) {
                        handle.writeData(mNaiLiOn7)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 660000) {
                        handle.writeData(mNaiLiOn8)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 720000) {
                        handle.writeData(mNaiLiOn9)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 840000) {
                        handle.writeData(mNaiLiOn10)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 960000) {
                        handle.writeData(mNaiLiOn11)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 1080000) {
                        handle.writeData(mNaiLiOn12)
                        mFlagStop = false
                    } else if (mNaiLiTime[i][0] < 1200000) {
                        handle.writeData(mNaiLiOn13)
                        mFlagStop = false
                    }
                    
                    mFlagPauseDone = false
                }
            }
        }
    }
    
    /// 肌肉锻炼
    ///
    /// - Parameter i: index
    func doJiRouCmd(_ i: Int) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 肌肉增长
            if FFBaseModel.sharedInstall.mJsType == 82 {
                
                if mJiRouTime[i][0] < 60000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn1)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff1)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 180000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn2)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff2)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 420000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn3)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff3)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 600000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn4)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff4)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 720000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn5)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff5)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 900000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn6)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff6)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 1080000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn7)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff7)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] < 1200000 {
                    
                    if mJiRouTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mJiRouOn8)
                        mFlagStop = false
                    } else if mJiRouTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mJiRouOff8)
                        mFlagStop = true
                    }
                } else if mJiRouTime[i][0] == 1200000 {
                    handle.writeData(mDeInit)
                }
            }
        }
    }
    
    /// 肌肉锻炼暂停或重新开始
    ///
    /// - Parameters:
    ///   - i: index
    ///   - pauseAndresume: 暂停和重新
    func doJiRouCmdPause(_ i: Int, _ pauseAndresume: Bool) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 肌肉增长
            if FFBaseModel.sharedInstall.mJsType == 82 && i >= 0 {
                
                if pauseAndresume && !mFlagStop {
                    if mJiRouTime[i][0] < 60000 {
                        handle.writeData(mJiRouOff1)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 180000 {
                        handle.writeData(mJiRouOff2)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 420000 {
                        handle.writeData(mJiRouOff3)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 600000 {
                        handle.writeData(mJiRouOff4)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 720000 {
                        handle.writeData(mJiRouOff5)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 900000 {
                        handle.writeData(mJiRouOff6)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 1080000 {
                        handle.writeData(mJiRouOff7)
                        mFlagStop = true
                    } else if mJiRouTime[i][0] < 1200000 {
                        handle.writeData(mJiRouOff8)
                        mFlagStop = true
                    }
                    
                    mFlagPauseDone = true
                }
                
                if !pauseAndresume && mFlagStop && mFlagPauseDone {
                    if mJiRouTime[i][0] < 60000 {
                        handle.writeData(mJiRouOn1)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 180000 {
                        handle.writeData(mJiRouOn2)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 420000 {
                        handle.writeData(mJiRouOn3)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 600000 {
                        handle.writeData(mJiRouOn4)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 720000 {
                        handle.writeData(mJiRouOn5)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 900000 {
                        handle.writeData(mJiRouOn6)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 1080000 {
                        handle.writeData(mJiRouOn7)
                        mFlagStop = false
                    } else if mJiRouTime[i][0] < 1200000 {
                        handle.writeData(mJiRouOn8)
                        mFlagStop = false
                    }
                    
                    mFlagPauseDone = false
                }
            }
        }
    }
    
    /// 燃烧脂肪
    ///
    /// - Parameter i: index
    func doFatBurnCmd(_ i: Int) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 全身燃烧脂肪
            if FFBaseModel.sharedInstall.mJsType == 83 {
                
                if mFatBurnTime[i][0] < 120000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn1)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff1)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 300000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn2)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff2)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 420000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn3)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff3)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 600000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn4)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff4)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 720000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn5)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff5)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 840000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn6)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff6)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 1020000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn7)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff7)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 1140000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn8)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff8)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] < 1200000 {
                    
                    if mFatBurnTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mFatBurnOn9)
                        mFlagStop = false
                    } else if mFatBurnTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mFatBurnOff9)
                        mFlagStop = true
                    }
                } else if mFatBurnTime[i][0] == 1200000 {
                    handle.writeData(mDeInit)
                }
            }
        }
    }
    
    /// 全身燃烧脂肪训练中止或重新开始
    ///
    /// - Parameters:
    ///   - i: index
    ///   - pauseAndresume: 中止和重新
    func doFatBurnCmdPause(_ i: Int, _ pauseAndresume: Bool) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 全身燃烧脂肪
            if FFBaseModel.sharedInstall.mJsType == 83 && i >= 0 {
                
                if pauseAndresume && !mFlagStop {
                    if mFatBurnTime[i][0] < 120000 {
                        handle.writeData(mFatBurnOff1)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 300000 {
                        handle.writeData(mFatBurnOff2)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 420000 {
                        handle.writeData(mFatBurnOff3)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 600000 {
                        handle.writeData(mFatBurnOff4)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 720000 {
                        handle.writeData(mFatBurnOff5)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 840000 {
                        handle.writeData(mFatBurnOff6)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 1020000 {
                        handle.writeData(mFatBurnOff7)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 1140000 {
                        handle.writeData(mFatBurnOff8)
                        mFlagStop = true
                    } else if mFatBurnTime[i][0] < 1200000 {
                        handle.writeData(mFatBurnOff9)
                        mFlagStop = true
                    }
                    
                    mFlagPauseDone = true
                }
                
                if !pauseAndresume && mFlagStop && mFlagPauseDone {
                    if mFatBurnTime[i][0] < 120000 {
                        handle.writeData(mFatBurnOn1)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 300000 {
                        handle.writeData(mFatBurnOn2)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 420000 {
                        handle.writeData(mFatBurnOn3)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 600000 {
                        handle.writeData(mFatBurnOn4)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 720000 {
                        handle.writeData(mFatBurnOn5)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 840000 {
                        handle.writeData(mFatBurnOn6)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 1020000 {
                        handle.writeData(mFatBurnOn7)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 1140000 {
                        handle.writeData(mFatBurnOn8)
                        mFlagStop = false
                    } else if mFatBurnTime[i][0] < 1200000 {
                        handle.writeData(mFatBurnOn9)
                        mFlagStop = false
                    }
                    
                    mFlagPauseDone = false
                }
            }
        }
    }
    
    /// 放松身体训练
    ///
    /// - Parameter i: index
    func doRelaxCmd(_ i : Int) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 放松身体
            if FFBaseModel.sharedInstall.mJsType == 84 {
                
                if mRelaxTime[i][0] < 120000 {
                    
                    if mRelaxTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mRelaxOn1)
                        mFlagStop = false
                    } else if mRelaxTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mRelaxOff1)
                        mFlagStop = true
                    }
                } else if mRelaxTime[i][0] < 240000 {
                    
                    if mRelaxTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mRelaxOn2)
                        mFlagStop = false
                    } else if mRelaxTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mRelaxOff2)
                        mFlagStop = true
                    }
                } else if mRelaxTime[i][0] < 480000 {
                    
                    if mRelaxTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mRelaxOn3)
                        mFlagStop = false
                    } else if mRelaxTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mRelaxOff3)
                        mFlagStop = true
                    }
                } else if mRelaxTime[i][0] < 720000 {
                    
                    if mRelaxTime[i][1] & 0x01 == 0x01 {
                        handle.writeData(mRelaxOn4)
                        mFlagStop = false
                    } else if mRelaxTime[i][1] & 0x02 == 0x02 {
                        handle.writeData(mRelaxOff4)
                        mFlagStop = true
                    }
                } else if mRelaxTime[i][0] < 900000 {
                    
                    if ((mRelaxTime[i][1] & 0x01) == 0x01) {
                        handle.writeData(mRelaxOn5)
                        mFlagStop = false
                    } else if ((mRelaxTime[i][1] & 0x02) == 0x02) {
                        handle.writeData(mRelaxOff5)
                        mFlagStop = true
                    }
                } else if (mRelaxTime[i][0] < 1080000) {
                    
                    if ((mRelaxTime[i][1] & 0x01) == 0x01) {
                        handle.writeData(mRelaxOn6)
                        mFlagStop = false
                    } else if ((mRelaxTime[i][1] & 0x02) == 0x02) {
                        handle.writeData(mRelaxOff6)
                        mFlagStop = true
                    }
                } else if (mRelaxTime[i][0] < 1200000) {
                    
                    if ((mRelaxTime[i][1] & 0x01) == 0x01) {
                        handle.writeData(mRelaxOn7)
                        mFlagStop = false
                    } else if ((mRelaxTime[i][1] & 0x02) == 0x02) {
                        handle.writeData(mRelaxOff7)
                        mFlagStop = true
                    }
                } else if (mRelaxTime[i][0] == 1200000) {
                    handle.writeData(mDeInit)
                }
            }
        }
    }
    
    /// 放松身体中止
    ///
    /// - Parameters:
    ///   - i: index
    ///   - pauseAndresume: 中止和重新
    func doRelaxCmdPause(_ i: Int, _ pauseAndresume: Bool) {
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 &&
            FFBaseModel.sharedInstall.commandReady &&
            FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            // 放松身体
            if (FFBaseModel.sharedInstall.mJsType == 84 && i >= 0) {
                
                if (pauseAndresume && !mFlagStop) {
                    if (mRelaxTime[i][0] < 120000) {
                        handle.writeData(mRelaxOff1)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 240000) {
                        handle.writeData(mRelaxOff2)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 480000) {
                        handle.writeData(mRelaxOff3)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 720000) {
                        handle.writeData(mRelaxOff4)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 900000) {
                        handle.writeData(mRelaxOff5)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 1080000) {
                        handle.writeData(mRelaxOff6)
                        mFlagStop = true
                    } else if (mRelaxTime[i][0] < 1200000) {
                        handle.writeData(mRelaxOff7)
                        mFlagStop = true
                    }
                    
                    mFlagPauseDone = true
                }
                
                if (!pauseAndresume && mFlagStop && mFlagPauseDone) {
                    if (mRelaxTime[i][0] < 120000) {
                        handle.writeData(mRelaxOn1)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 240000) {
                        handle.writeData(mRelaxOn2)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 480000) {
                        handle.writeData(mRelaxOn3)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 720000) {
                        handle.writeData(mRelaxOn4)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 900000) {
                        handle.writeData(mRelaxOn5)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 1080000) {
                        handle.writeData(mRelaxOn6)
                        mFlagStop = false
                    } else if (mRelaxTime[i][0] < 1200000) {
                        handle.writeData(mRelaxOn7)
                        mFlagStop = false
                    }
                    
                    mFlagPauseDone = false
                }
            }
        }
    }
}
