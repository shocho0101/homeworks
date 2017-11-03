//
//  LogManager.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/25.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation

class LogManager{
    static func errorPrint(massege: String?){
        if let massegetext = massege{
            print("LOG_ERROR:" + massegetext)
        }else{
            print("LOG_ERROR")
        }
    }
    static func successPrint(massege: String?){
        if let massegetext = massege{
            print("LOG_SUCCESS:" + massegetext)
        }else{
            print("LOG_SUCCESS")
        }
    }
    
}
