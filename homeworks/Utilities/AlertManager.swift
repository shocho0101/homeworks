//
//  File.swift
//  homeworks
//
//  Created by 張翔 on 2017/10/25.
//  Copyright © 2017年 sho. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    static func AlertWithOKButton(on viewcontroller: UIViewController,title: String?, message: String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(OK)
        viewcontroller.present(alert, animated: true, completion: nil)
    }
}
