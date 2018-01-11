//
//  AppDelegate.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-04.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        do {
            _ = try Realm()
        } catch {
            print("Error initialising realm \(error)")
        }
        
        return true
    }
    
}

