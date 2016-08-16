//
//  ViewController.swift
//  FPSToolBar
//
//  Created by leafy on 16/6/15.
//  Copyright © 2016年 leafy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let fps = FPSToolBar.sharedInstance
        fps.borderWidth = 2.0
        fps.borderColor = UIColor.redColor()
        let rootView =  UIApplication.sharedApplication().delegate?.window!!.rootViewController?.view
        fps.show(rootView!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

