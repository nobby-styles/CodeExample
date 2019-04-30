//
//  AppDelegate.swift
//  TUITechTest
//
//  Created by Robert Redmond on 23/03/2018.
//  Copyright © 2018 RNR Apps. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        if let navController = window?.rootViewController as? UINavigationController, let vc = navController.viewControllers[0] as? WeatherViewController{
            let dataProvider = DataProviderImplementation()
            let weatherDataManager = WeatherDataManagerImplementation(dataProvider: dataProvider)
            let weatherViewModel = WeatherViewModel(dataManager: weatherDataManager)
            vc.viewModel = weatherViewModel
        }
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }


}

