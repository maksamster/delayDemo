//
//  ViewController.swift
//  延时调用demo
//
//  Created by cceup on 2017/9/4.
//  Copyright © 2017年 . All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let task = delayDemo().delay(5) {
            print("延迟两秒")
        }
        
        delayDemo().cancel(task)
    }
}

