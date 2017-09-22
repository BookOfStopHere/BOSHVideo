//
//  ViewController.swift
//  SDKSwiftDemo
//
//  Created by Yeelik on 2017/4/21.
//  Copyright © 2017年 Tencent. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        BLogInfo("Enter %s", #file)
        
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        button.setTitle("点击触发崩溃", for: [])
        button.addTarget(self, action: #selector(self.crashButtonTapped(_:)), for: .touchUpInside)
        view.addSubview(button)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func crashButtonTapped(_ sender: AnyObject) {
        NSLog("Test crash");
        let array = [1]
        print(array[2])
    }


}

