//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFMimeViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/15.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit

class FFMineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let service = FFMineModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    // MARK: - Private
    
    /// 处理Mine所有项
    ///
    /// - Parameter item: 事件项
    private func handleMineItem(_ item: MineItem) {
        switch item {
        case .bleConnection:
            print("ble")
        case .registerSave:
            print("save")
        case .versionInfo:
            print("info")
        case .exit:
            handleMineItemExit()
        }
    }
    
    /// 处理退出项
    private func handleMineItemExit() {
        let alert = UIAlertController(title: nil, message: "您确定退出吗？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: <#T##String?#>, style: <#T##UIAlertAction.Style#>, handler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>))
    }
}

// MARK: - UITableViewDelegate\UITableViewDataSource

extension FFMineViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return service.datasourceForMine().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: service.datasourceForMine()[indexPath.row].icon)
        cell.textLabel?.text = service.datasourceForMine()[indexPath.row].title
        cell.textLabel?.textColor = UIColor.white
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let mine = MineItem(rawValue: indexPath.row) else { // 如果不能转换成枚举，则直接return
            return
        }
        handleMineItem(mine)
    }
}