//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFCodeResponse.swift
//  FultureFit
//
//  Created by ANKER on 2019/7/6.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFCodeResponse: FFBaseResponse {
    var data: CodeData?
}

class CodeData: Codable {
    var template: String
}
