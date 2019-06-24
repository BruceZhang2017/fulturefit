//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  FFPowerViewController.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/21.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import SnapKit
import Then

class FFPowerViewController: BaseViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    private var setPowerFrontVC: FFSetPowerViewController! // 前面视图
    private var setPowerBackVC: FFSetPowerBackViewController! // 背面视图
    private var frontButton: UIButton! // 前面按钮
    private var backButton: UIButton! // 背面按钮
    private var lineImageView: UIImageView! // 线视图
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeUI()
        initializeTitleView()
    }
    
    private func initializeUI() {
        let storyboard = UIStoryboard(name: "Sport", bundle: nil)
        setPowerFrontVC = storyboard.instantiateViewController(withIdentifier: "FFSetPowerViewController") as? FFSetPowerViewController
        setPowerBackVC = storyboard.instantiateViewController(withIdentifier: "FFSetPowerBackViewController") as? FFSetPowerBackViewController
        addChild(setPowerFrontVC)
        addChild(setPowerBackVC)
        let top: CGFloat = isSameToIphoneX() ? 88 : 64
        scrollView.addSubview(setPowerFrontVC.view)
        scrollView.addSubview(setPowerBackVC.view)
        setPowerFrontVC.view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(screenWidth)
            $0.left.equalToSuperview()
            $0.height.equalTo(screenHight - top)
        }
        setPowerBackVC.view.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.width.equalTo(screenWidth)
            $0.left.equalTo(setPowerFrontVC.view.snp.right)
            $0.height.equalTo(screenHight - top)
        }
        scrollView.contentSize = CGSize(width: screenWidth * 2, height: screenHight - top)
    }
    
    /// 初始化TitleView
    private func initializeTitleView() {
        let tView = UIView(frame: CGRect(x: 0, y: 0, width: 120, height: 44))
        navigationItem.titleView = tView
        frontButton = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 44)).then {
            $0.setTitle("前面", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor("a0dc2f".ColorHex()!, for: .selected)
            $0.isSelected = true
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.addTarget(self, action: #selector(change(_:)), for: .touchUpInside)
        }
        tView.addSubview(frontButton)
        backButton = UIButton(frame: CGRect(x: 60, y: 0, width: 60, height: 44)).then {
            $0.setTitle("背面", for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.setTitleColor("a0dc2f".ColorHex()!, for: .selected)
            $0.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            $0.addTarget(self, action: #selector(change(_:)), for: .touchUpInside)
        }
        tView.addSubview(backButton)
        lineImageView = UIImageView(frame: CGRect(x: 0, y: 43, width: 60, height: 1))
        lineImageView.backgroundColor = "a0dc2f".ColorHex()!
        tView.addSubview(lineImageView)
    }
    
    @objc private func change(_ sender: UIButton) {
        if frontButton == sender {
            if frontButton.isSelected {
                return
            }
            frontButton.isSelected = true
            backButton.isSelected = false
            lineImageView.frame = CGRect(x: 0, y: 43, width: 60, height: 1)
            scrollView.contentOffset = CGPoint(x: 0, y: 0)
            return
        }
        if backButton.isSelected {
            return
        }
        frontButton.isSelected = false
        backButton.isSelected = true
        lineImageView.frame = CGRect(x: 60, y: 43, width: 60, height: 1)
        scrollView.contentOffset = CGPoint(x: screenWidth, y: 0)
    }
    
    /// 判断是否为IphoneX系列
    private func isSameToIphoneX() -> Bool {
        if #available(iOS 11.0, *) {
            if let window = UIApplication.shared.delegate?.window {
                if (window?.safeAreaInsets.bottom ?? 0) > 0 {
                    return true
                }
            }
        }
        return false
    }

}

extension FFPowerViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        if page == 0 {
            frontButton.isSelected = true
            backButton.isSelected = false
            lineImageView.frame = CGRect(x: 0, y: 43, width: 60, height: 1)
        } else {
            frontButton.isSelected = false
            backButton.isSelected = true
            lineImageView.frame = CGRect(x: 60, y: 43, width: 60, height: 1)
        }
    }
    
}
