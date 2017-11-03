//
//  User.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/25.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation
import UIKit
import LineSDK
import FacebookLogin
import FacebookCore
import TwitterKit
import Alamofire
import SwiftyJSON


class User: NSObject, LineSDKLoginDelegate{
    static let shardInstance = User()
    private override init(){
        super.init()
        LineSDKLogin.sharedInstance().delegate = self
    }
    
    //MARK: - All
    public enum UserLoginType: String {
        case LINE = "LINE"
        case Facebook = "Facebook"
        case Twitter = "Twitter"
        case None = "None"
    }
    
    func checkLogin() -> UserLoginType{
        if AccessToken.current != nil {
            return UserLoginType.Facebook
        }else if Twitter.sharedInstance().sessionStore.hasLoggedInUsers(){
            return UserLoginType.Twitter
        }else{
            deleteToken()
            return UserLoginType.None
        }
    }
    
    func checkIntegrity() -> Bool{
        if (checkLogin() != UserLoginType.None && token() == nil) || (checkLogin() == UserLoginType.None && token() != nil){
            return false
        }else{
            return true
        }
    }
    
    func logOutAndShowLogin(from viewController: UIViewController){
        while checkLogin() != UserLoginType.None {
            switch checkLogin() {
            case .Facebook:
                LoginManager().logOut()
                LogManager.successPrint(massege: "Facebookからログアウトしました")
            case .Twitter:
                let userID = Twitter.sharedInstance().sessionStore.session()?.userID
                Twitter.sharedInstance().sessionStore.logOutUserID(userID!)
                LogManager.successPrint(massege: "Twitterからログアウトしました")
            default:
                break
            }
        }
        
        deleteToken()
        
        let loginView = UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController()
        viewController.present(loginView!, animated: false, completion: nil)
    }
    
    
    //MARK: Line
    func signInbyLINE(from viewcontroller: UIViewController){
        LineSDKLogin.sharedInstance().start()
        
    }
    
    func didLogin(_ login: LineSDKLogin, credential: LineSDKCredential?, profile: LineSDKProfile?, error: Error?) {
        if error != nil{
            LogManager.errorPrint(massege: error?.localizedDescription)
        }else{
            LogManager.successPrint(massege: "LINEでログイン成功")
        }
    }
    
    //MARK: Facebook
    func signInbyFacebook(from viewcontroller: UIViewController){
        LoginManager().logIn(readPermissions: [.email,.publicProfile], viewController: viewcontroller) { (result) in
            switch result{
            case let .success(grantedPermissions: _, declinedPermissions: _, token: token):
                LogManager.successPrint(massege: "Facebookにログインしました")
                GraphRequest(graphPath: "me", parameters: ["fields": "name, email"], accessToken: token, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion).start({
                    response, result in
                    switch result {
                    case .success(let response) :
                        self.authRegister(userID: response.dictionaryValue!["id"]! as! String, password: response.dictionaryValue!["id"]! as! String, username: response.dictionaryValue!["name"]! as! String, loginType: UserLoginType.Facebook)
                        break
                    case .failed(let error):
                        print("error:\(error.localizedDescription)")
                        
                    }
                    
                })
                //self.authRegister(userID: (UserProfile.current?.userId)!, password: (UserProfile.current?.userId)!, username: (UserProfile.current?.fullName)!, loginType: UserLoginType.Facebook)
            case let .failed(error):
                LogManager.errorPrint(massege: error.localizedDescription)
            case .cancelled:
                break
            }
        }
    }
    
    func logInbyFacebook(from viewcontroller: UIViewController){
        LoginManager().logIn(readPermissions: [.email,.publicProfile], viewController: viewcontroller) { (result) in
            switch result{
            case let .success(grantedPermissions: _, declinedPermissions: _, token: token):
                LogManager.successPrint(massege: "Facebookにログインしました")
                GraphRequest(graphPath: "me", parameters: ["fields": "name, email"], accessToken: token, httpMethod: .GET, apiVersion: GraphAPIVersion.defaultVersion).start({
                    response, result in
                    switch result {
                    case .success(let response) :
                        self.getToken(userID: response.dictionaryValue!["id"]! as! String, password: response.dictionaryValue!["id"]! as! String)
                        break
                    case .failed(let error):
                        print("error:\(error.localizedDescription)")
                        
                    }
                    
                })
            case let .failed(error):
                LogManager.errorPrint(massege: error.localizedDescription)
            case .cancelled:
                break
            }
        }
    }
    
    //MARK: Twitter
    func signInbyTwitter(from viewcontroller: UIViewController){
        Twitter.sharedInstance().logIn(with: viewcontroller) { (session, error) in
            if let error = error{
                LogManager.errorPrint(massege: error.localizedDescription)
                
            }else{
                LogManager.successPrint(massege: "\(String(describing: session?.userName))としてTwtterにログインしました")
                self.authRegister(userID: (session?.userID)!, password: (session?.userID)!, username: (session?.userName)!, loginType: UserLoginType.Twitter)
            }
        }
    }
    
    func logInbyTwitter(from viewcontroller: UIViewController){
        Twitter.sharedInstance().logIn(with: viewcontroller) { (session, error) in
            if let error = error{
                LogManager.errorPrint(massege: error.localizedDescription)
                
            }else{
                LogManager.successPrint(massege: "\(String(describing: session?.userName))としてTwtterにログインしました")
                self.getToken(userID: (session?.userID)!, password: (session?.userID)!)
            }
        }
    }
    
    //MARK: backend
    enum BackendURL: String {
        case authRegister = "http://35.200.109.16:8000/api/register/"
        case getToken = "http://35.200.109.16:8000/api/get-token/"
    }
    
    let userDefaults = UserDefaults.standard
    
    let headers: HTTPHeaders = ["name": "value"]
    
    func authRegister(userID: String, password: String, username: String, loginType: UserLoginType){
        
        let parameter = ["userID": userID, "username": username, "password": password, "loginType": loginType.rawValue]
        
        Alamofire.request(BackendURL.authRegister.rawValue, method: HTTPMethod.post , parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { (responce) in
            print(responce)
            if responce.error == nil{
                self.getToken(userID: userID, password: userID)
            }else{
                LogManager.errorPrint(massege: responce.error?.localizedDescription)
                self.logOutAndShowLogin(from: UIApplication.topViewController()!)
            }
        }
        
    }
    
    func getToken(userID: String, password: String){
        let parameter = ["userID": userID, "password": password]
        Alamofire.request(BackendURL.getToken.rawValue, method: HTTPMethod.post , parameters: parameter, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            print(response)
            let json = JSON(response.result.value!)
            if response.error == nil {
                self.userDefaults.set(json["token"].string, forKey: "token")
                
            }else{
                LogManager.errorPrint(massege: response.error?.localizedDescription)
                self.logOutAndShowLogin(from: UIApplication.topViewController()!)
            }
        }
    }
    
    func deleteToken(){
        userDefaults.set(nil, forKey: "token")
    }
    
    func token() -> String?{
        return userDefaults.string(forKey: "token")
    }
    
    
    
}
