//
//  AppDelegate.swift
//  Batman
//
//  Created by Romain Pouclet on 2017-04-12.
//  Copyright © 2017 Perfectly-Cooked. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let token = ProcessInfo.processInfo.environment["ASANA_TOKEN"].flatMap(Token.init)!
        print("Token = \(token)")
        
        let client = Client(token: token)
        client.projects().startWithResult { result in
            print("Result = \(result)")
        }
        
        return true
    }

}

