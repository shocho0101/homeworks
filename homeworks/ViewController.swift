//
//  ViewController.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/23.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import LineSDK

class ViewController: UIViewController {

    let user: User = User.shardInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func logOut(){
        user.logOutAndShowLogin(from: self)
    }


}

