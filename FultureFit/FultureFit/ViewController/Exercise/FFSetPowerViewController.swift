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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func tap(_ sender: Any) {
        
    }
    
    @IBAction func add(_ sender: Any) {
    }
    
    @IBAction func reduce(_ sender: Any) {
    }
    
}
