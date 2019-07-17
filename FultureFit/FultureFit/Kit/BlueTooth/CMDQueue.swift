//
// * Copyright © 2015-2018 Anker Innovations Technology Limited All Rights Reserved.
// * The program and materials is not free. Without our permission, any use, including but not limited to reproduction, retransmission, communication, display, mirror, download, modification, is expressly prohibited. Otherwise, it will be pursued for legal liability.

//
//  CMDQueue.swift
//  Headset
//
//  Created by AirohaTool on 2016/8/10.
//  Copyright © 2016年 jayfang. All rights reserved.
//

import Foundation

class CMDQueue {
    
    static let sharedInstance = CMDQueue()
    var thQueue : CMDQueueThread? = nil

    func AddCmdQueue(param: Data) {
        if thQueue == nil {
            thQueue = CMDQueueThread()
            thQueue?.start()
        }
        thQueue?.enqueue(param: param)
    }
    
    func stop() {
        thQueue?.stop()
        thQueue = nil
    }
    
    func clearCmdQueue() {
        thQueue?.cleanCmdQueue()
    }
}

class CMDQueueThread {
    
    let _qCmds = Queue<(Data)>()
    var _threadTimer:DispatchSourceTimer!
    var _createQueue = DispatchQueue(label: "com.zhangxiaofei.app.CmdQueue", attributes: [])
    var _stopflag = true
    
    func cleanCmdQueue() {
        lock(obj: _qCmds) {
            _qCmds.clear()
        }
    }
    
    func enqueue(param: Data) {
        lock(obj: _qCmds) {
            _qCmds.enqueue(param)
        }
    }
    
    func isQueueEmpty() -> Bool {
        var isEmpty = true
        lock(obj: _qCmds) {
            isEmpty = _qCmds.isEmpty()
        }
        return isEmpty
    }
    
    func protected_dequeue () {
        while !isQueueEmpty() {
            if FFBLEManager.sharedInstall.activePeripheral == nil {
                lock(obj: _qCmds) {
                    _qCmds.clear()
                }
                return
            }
            
            if _stopflag {
                return
            }
            
            lock(obj: _qCmds) {
                if isQueueEmpty() {
                    return
                }
                
                if let cmd = self._qCmds.dequeue() {
                    self.excuteCmd(parameter: cmd)
                }
            }
        }
    }
    
    func excuteCmd(parameter: Data) {
        FFBLEManager.sharedInstall.write(data: parameter)
    }
    
    func start() {
        _stopflag = false
        
        if _threadTimer == nil {
            let interval : DispatchTimeInterval = .milliseconds(20)
            _threadTimer = DispatchSource.makeTimerSource(queue: _createQueue)
            _threadTimer.schedule(deadline: .now(), repeating: interval)
            _threadTimer.setEventHandler(handler: {
                if !self._stopflag {
                    self.protected_dequeue()
                }
            })
            _threadTimer.resume()
        }

    }
    
    func stop() {
        _stopflag = true
        self._threadTimer.cancel()
        self._threadTimer = nil
    }
    
    func lock(obj: AnyObject, blk:() -> ()) {
        objc_sync_enter(obj)
        blk()
        objc_sync_exit(obj)
    }
}

class Queue<T> {
    
    typealias Element = T
    
    var _front: _QueueItem<Element>
    var _back: _QueueItem<Element>
    
    init () {
        // Insert dummy item. Will disappear when the first item is added.
        _back = _QueueItem(nil)
        _front = _back
    }
    
    /// Add a new item to the back of the queue.
    func enqueue (_ value: Element) {
        _back.next = _QueueItem(value)
        _back = _back.next!
    }
    
    /// Return and remove the item at the front of the queue.
    func dequeue () -> Element? {
        if let newhead = _front.next {
            _front = newhead
            return newhead.value
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        return _front === _back
    }
    
    func clear() {
        if isEmpty() {
            return
        }
        
        while let _ = dequeue()  {
            // do something with 'value'.
        }
    }
}

class _QueueItem<T> {
    let value: T!
    var next: _QueueItem?
    
    init(_ newvalue: T?) {
        self.value = newvalue
    }
}
