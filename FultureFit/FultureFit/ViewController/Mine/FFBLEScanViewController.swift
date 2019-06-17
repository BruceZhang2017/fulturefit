//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFBLEScanViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/16.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFBLEScanViewController: BaseViewController {
    
    private let service = FFBLEScanModelService()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "蓝牙列表"
        tableView.tableFooterView = UIView()
        service.scanedBLECallback = {
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
    }

    /// 刷新TableView
    @IBAction func refresh(_ sender: Any) {
        
    }
}

// MARK: - UITableViewDelegate\UITableViewDataSource

extension FFBLEScanViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.getBLEDiscoveredCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = service.getDiscoveredBLE(index: indexPath.row).name
        }
        if let label = cell.viewWithTag(2) as? UILabel {
            label.text = service.getDiscoveredBLE(index: indexPath.row).mac
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
