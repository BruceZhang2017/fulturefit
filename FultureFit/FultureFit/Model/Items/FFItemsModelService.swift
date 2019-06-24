//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFItemsModelService.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFItemsModelService: NSObject {
    
    private var fitItems : [FitItem] = []
    
    override init() {
        super.init()
        for item in itemNames {
            fitItems.append(FitItem(name: item))
        }
    }
    
    func fitItemsCount() -> Int {
        return fitItems.count
    }
    
    func fitItem(index: Int) -> FitItem {
        assert(index < fitItems.count)
        return fitItems[index]
    }
}
