//
//  FPSToolBar.swift
//  FPSToolBar
//
//  Created by leafy on 16/6/6.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit

class FPSToolBar: NSObject {
    //单例
    static let sharedInstance = FPSToolBar()
    
    private var disp: CADisplayLink?
    private var text: CATextLayer?
    
    var borderColor = UIColor.clearColor() {
        willSet {
            if text != nil {
                text!.borderColor = newValue.CGColor
            }
        }
    }
    var borderWidth: CGFloat = 0.0 {
        willSet {
            if text != nil {
                text!.borderWidth = newValue
            }
        }
    }
    var fontSize: CGFloat = 16.0 {
        willSet {
            if text != nil {
                text?.fontSize = newValue
            }
        }
    }
    var frame: CGRect = CGRect(x: 70.0, y: 0.0, width: 100.0, height: 21.0) {
        willSet {
            if text != nil {
                text?.frame = frame
            }
        }
    }
    
    override init() {
        super.init()
        
        text = CATextLayer()
        text?.frame = frame
        text?.fontSize = fontSize
        text?.borderColor = borderColor.CGColor
        text?.borderWidth = borderWidth
        text?.alignmentMode = kCAAlignmentCenter
        text?.contentsScale = UIScreen.mainScreen().scale
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(applicationDidBecomeActiveNotification), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func show(view: UIView) {
        guard disp != nil else {
            disp = CADisplayLink(target: self, selector: #selector(tick(_:)))
            disp?.frameInterval = 2
            disp?.paused = false
            disp?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            view.layer.addSublayer(text!)
            return
        }
    }
    
    func dismiss() {
        text?.removeFromSuperlayer()
        disp?.paused = true
        disp?.removeFromRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
        disp?.invalidate()
        disp = nil
    }
    
    @objc private func applicationDidBecomeActiveNotification() {
        disp?.paused = false
    }
    
    @objc private func applicationWillResignActiveNotification() {
        disp?.paused = true
    }
    
    @objc private func tick(disp: CADisplayLink) {
        struct FPSInfo {
            static var frames  = 0  //画面
            static var timeStamp = 0.0
        }
        let nowTime = CFAbsoluteTimeGetCurrent()
        if (nowTime - FPSInfo.timeStamp) > 0.5 {
            let fpsNumber = Double(disp.frameInterval * FPSInfo.frames) / (nowTime - FPSInfo.timeStamp)
            text?.string = "FPS:\(Int(fpsNumber))"
            if fpsNumber >= 45.0 {
                text?.foregroundColor = UIColor.greenColor().CGColor
            } else if fpsNumber >= 30.0 {
                text?.foregroundColor = UIColor.orangeColor().CGColor
            } else {
                text?.foregroundColor = UIColor.redColor().CGColor
            }
            FPSInfo.timeStamp = nowTime
            FPSInfo.frames = 0
        } else {
            FPSInfo.frames += 1
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
