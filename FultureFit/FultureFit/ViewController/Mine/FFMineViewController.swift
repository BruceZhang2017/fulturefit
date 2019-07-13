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
import Toast_Swift

class FFMineViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
    private let service = FFMineModelService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: - Private
    
    /// 处理Mine所有项
    ///
    /// - Parameter item: 事件项
    private func handleMineItem(_ item: MineItem) {
        switch item {
        case .bleConnection:
            performSegue(withIdentifier: "toBLEScan", sender: self)
        case .versionInfo:
            showVersionInfo()
        case .exit:
            handleMineItemExit()
        }
    }
    
    /// 处理退出项
    private func handleMineItemExit() {
        if FFBaseModel.sharedInstall.mCountDownTimeState != 0 {
            view.makeToast("您当前正在训练中，请先停止当前项目")
            return
        }
        let alert = UIAlertController(title: nil, message: "mine_exit_alert_message".localizable(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "CANCEL".localizable(), style: .default, handler: { (action) in
            
        }))
        alert.addAction(UIAlertAction(title: "OK".localizable(), style: .default, handler: { (action) in
            let storyboard = UIStoryboard(name: "User", bundle: nil)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "FFUserNavigationController") as? FFUserNavigationController
            (UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController = loginVC
            //self.navigationController?.tabBarController = nil
            UserDefaults.standard.removeObject(forKey: "phone")
            UserDefaults.standard.removeObject(forKey: "time")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    private func showVersionInfo() {
        let currentVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
        view.makeToast("当前版本号：V\(currentVersion)")
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
