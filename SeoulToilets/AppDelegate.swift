//
//  AppDelegate.swift
//  SeoulToilets
//
//  Created by 김성종 on 2018. 5. 3..
//  Copyright © 2018년 Willicious-k. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window: UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    return true
  }
  
  func applicationWillResignActive(_ application: UIApplication) {
  }
  
  func applicationDidEnterBackground(_ application: UIApplication) {
  }
  
  func applicationWillEnterForeground(_ application: UIApplication) {
    let currentVC = UIApplication.shared.keyWindow?.rootViewController as? MainViewController
    currentVC?.isLocationUpdated = false
  }
  
  func applicationDidBecomeActive(_ application: UIApplication) {
  }
  
  func applicationWillTerminate(_ application: UIApplication) {
  }
  
}

