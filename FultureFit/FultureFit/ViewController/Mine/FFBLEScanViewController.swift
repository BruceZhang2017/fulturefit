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

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var alert: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "蓝牙列表"
        refreshButton.isEnabled = false
        tableView.tableFooterView = UIView()
        service.scanedBLECallback = {
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
            }
        }
        service.scanedBLEFinished = {
            DispatchQueue.main.async {
                [weak self] in
                self?.refreshButton.isEnabled = true
            }
        }
        service.scanedBLEShowAlert = {
            DispatchQueue.main.async {
                [weak self] in
                self?.showAlert()
            }
        }
        service.scanedBLEHideAlert = {
            DispatchQueue.main.async {
                [weak self] in
                self?.alert?.dismiss(animated: false, completion: nil)
                self?.alert = nil 
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if FFBaseModel.sharedInstall.blePowerStatus != .poweredOn { // 如果蓝牙未开启
            showAlert()
        }
    }
    
    private func showAlert() {
        if alert == nil {
            alert = UIAlertController(title: "提示", message: "请开启蓝牙", preferredStyle: .alert)
            alert?.addAction(UIAlertAction(title: "OK", style: .cancel, handler: {[weak self] (action) in
                self?.alert = nil
            }))
            present(alert!, animated: true, completion: nil)
        }
    }

    /// 刷新TableView
    @IBAction func refresh(_ sender: Any) {
        if FFBaseModel.sharedInstall.blePowerStatus != .poweredOn { // 如果蓝牙未开启
            showAlert()
            refreshButton.isHidden = false
            return
        }
        service.refreshScan()
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
        if FFBaseModel.sharedInstall.blePowerStatus != .poweredOn { // 如果蓝牙未开启
            showAlert()
            return
        }
        service.connectPer(index: indexPath.row)
        self.navigationController?.popViewController(animated: true)
    }
}
