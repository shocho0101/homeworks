//
//  LoginViewController.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/25.
//  Copyright © 2017年 sho. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    let user: User = User.shardInstance

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if user.checkLogin() != User.UserLoginType.None {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    @IBAction func facebook(){
        user.logInbyFacebook(from: self)
    }
    
    @IBAction func twitter(){
        user.logInbyTwitter(from: self)
    }
    
    @IBAction func back(){
        navigationController?.popViewController(animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
