//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFMineModelService.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFMineModelService: NSObject {
    
    func datasourceForMine() -> [FFMineModel] {
        var models : [FFMineModel] = []
        models.append(FFMineModel(icon: "蓝牙", title: "蓝牙连接"))
        models.append(FFMineModel(icon: "存档", title: "注册存档"))
        models.append(FFMineModel(icon: "版本", title: "版本信息"))
        models.append(FFMineModel(icon: "设置", title: "退出"))
        return models
    }
}
