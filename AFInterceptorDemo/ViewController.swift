//
//  ViewController.swift
//  AFInterceptorDemo
//
//  Created by Omar Juarez Ortiz on 2019-07-20.
//  Copyright © 2019 Segartek Software. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MyAPIManager.shared.refreshTokens { (succeded, newtoken) in
            if succeded {
                MyAPIManager.shared.authInterceptor.accessToken = newtoken
                MyAPIManager.shared.playlistFromG8()
            }
        }
        
    }


}

