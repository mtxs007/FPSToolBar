//
//  FPSToolBar.swift
//  FPSToolBar
//
//  Created by leafy on 16/6/6.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit

class FPSToolBar: NSObject {
    // Singleton
    static let sharedInstance = FPSToolBar()
    
    private var disp: CADisplayLink?
    private var text: CATextLayer?
    private var lastTime: CFTimeInterval = 0
    private var count: UInt = 0
    
    var borderColor = UIColor.clearColor() {
        willSet {
            if let `text` = text {
                text.borderColor = newValue.CGColor
            }
        }
    }
    var borderWidth: CGFloat = 0.0 {
        willSet {
            if let `text` = text {
                text.borderWidth = newValue
            }
        }
    }
    var fontSize: CGFloat = 12.0 {
        willSet {
            if let `text` = text {
                text.fontSize = newValue
            }
        }
    }
    var frame: CGRect = CGRect(x: 1.0, y: 24.0, width: 50.0, height: 15.0) {
        willSet {
            if let `text` = text {
                text.frame = frame
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
        text?.drawsAsynchronously = true
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(applicationDidBecomeActiveNotification), name: UIApplicationDidBecomeActiveNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(applicationWillResignActiveNotification), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func show(view: UIView) {
        guard disp != nil else {
            disp = CADisplayLink(target: self, selector: #selector(tick(_:)))
            disp?.paused = false
            disp?.addToRunLoop(NSRunLoop.mainRunLoop(), forMode: NSRunLoopCommonModes)
            
            if let `text` = text {
                view.layer.addSublayer(`text`)
            }
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
        guard lastTime != 0 else {
            lastTime = disp.timestamp
            return
        }
        
        count += 1
        let interval = disp.timestamp - lastTime
        if interval < 0.5 { return }
        lastTime = disp.timestamp
        let fps = CFTimeInterval(count) / interval
        count = 0
        
        text?.string = String(format: "FPS:%02ld", Int(round(fps)))
        if fps >= 45.0 {
            text?.foregroundColor = UIColor.greenColor().CGColor
        } else if fps >= 30.0 {
            text?.foregroundColor = UIColor.orangeColor().CGColor
        } else {
            text?.foregroundColor = UIColor.redColor().CGColor
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
