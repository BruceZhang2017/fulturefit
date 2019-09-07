//
// Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.
// 
//  AppDelegate.swift
//  FultureFit
//
//  Created by ANKER on 2019/6/14.
//  Copyright © 2019 PDP-ACC. All rights reserved.
//
	

import UIKit
import CoreData
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var bgTask: UIBackgroundTaskIdentifier?
    var timer: Timer?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let _ = FFBLEManager.sharedInstall
        // 设置Tab bar选中字体颜色
        UITabBarItem.appearance().setTitleTextAttributes([.foregroundColor: "a0dc2f".ColorHex()!], for: .selected)
        //UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white], for: .normal)
        UINavigationBar.appearance().tintColor = UIColor.white
        IQKeyboardManager.shared.enable = true
        if let _ = UserDefaults.standard.string(forKey: "phone") {
            if let timeInternal = UserDefaults.standard.object(forKey: "time") as? TimeInterval {
                let now = Date().timeIntervalSince1970
                let distance: TimeInterval = 7 * 24 * 60 * 60
                if now - timeInternal < distance {
                    let storybaord = UIStoryboard(name: "Tab", bundle: nil)
                    let tabController = storybaord.instantiateViewController(withIdentifier: "FFTabBarController") as? FFTabBarController
                    window?.rootViewController = tabController
                    let network = FFNetworkManager()
                    network.loginRecord()
                } else {
                    UserDefaults.standard.removeObject(forKey: "phone")
                    UserDefaults.standard.removeObject(forKey: "time")
                }
            }
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        print("applicationWillResignActive")
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        print("applicationDidEnterBackground")
        startBackgroundTask()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        print("applicationWillEnterForeground")
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        print("applicationDidBecomeActive")
    }

    func applicationWillTerminate(_ application: UIApplication) {
        print("applicationWillTerminate")
        if FFBaseModel.sharedInstall.bleConnectStatus == 2 && FFBaseModel.sharedInstall.commandReady {
            FFCommandHandle().writeData(mDeInit)
        }
        self.saveContext()
    }
    
    func checkActive() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: false)
    }
    
    @objc func handleTimer() {
        startBackgroundTask()
    }
    
    func startBackgroundTask() {
        if bgTask != nil && bgTask != .invalid {
            UIApplication.shared.endBackgroundTask(bgTask!)
            bgTask = .invalid
        }
        bgTask = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            UIApplication.shared.endBackgroundTask(self.bgTask!)
            self.bgTask = .invalid
        })
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "FultureFit")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

