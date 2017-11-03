//
//  SignInViewController.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/25.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit
import LineSDK
import FacebookCore
import FacebookLogin


class SignInViewController: UIViewController {
    
    let user: User = User.shardInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
            
        }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if user.checkLogin() != User.UserLoginType.None {
            self.dismiss(animated: false, completion: nil)
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func back(){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func line(){
//        user.signInbyLINE(from: self)
    }
    
    @IBAction func facebook(){
        user.signInbyFacebook(from: self)
    }
    
    @IBAction func twitter(){
        user.signInbyTwitter(from: self)
    }
    
}
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


