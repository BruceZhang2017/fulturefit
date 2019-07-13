//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFItemsViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import Toast_Swift

class FFItemsViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let service = FFItemsModelService()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

}

// MARK: - UITableViewDelegate\UITableViewDataSource

extension FFItemsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.fitItemsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let label = cell.viewWithTag(1) as? UILabel {
            label.text = service.fitItem(index: indexPath.row).name
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            view.makeToast("您当前正在训练中，请先停止当前项目")
            return
        }
        if FFBaseModel.sharedInstall.mJsType - 80 == indexPath.row {
            navigationController?.tabBarController?.selectedIndex = 0
            return
        }
        let name = service.fitItem(index: indexPath.row).name
        view.makeToast("您选择了 \(name) 项目")
        FFBaseModel.sharedInstall.mJsType = 80 + indexPath.row
        navigationController?.tabBarController?.selectedIndex = 0
    }
}
