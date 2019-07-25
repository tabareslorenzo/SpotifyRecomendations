///Users/lorenzo/Documents/GitHub/GitTrial/Git
//  AppDelegate.swift
//  Git
//
//  Created by Josh Lubow on 9/12/18.
//  Copyright © 2018 Josh Lubow. All rights reserved.
//

import UIKit
import SpotifyLogin

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//Music-discovery://callback

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        SpotifyLogin.shared.configure(clientID: "023843ccf5c146958e6c80c91a4f8123" , clientSecret: "0651ff860dda49eeb94a8f19ff00f922", redirectURL: URL(string:"Music-discovery://callback")!)
        print("didFinishLaunchingWithOptions")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        
//        // Retrieve the access token
//        SpotifyLogin.shared.getAccessToken { (accessToken, error) in
//            if error != nil {
//                // User is not logged in, show log in flow.
//                print("failed")
//                print(error)
//            }
//            else{
//                print(accessToken)
//                print(SpotifyLogin.shared.username)
////                data().main(token : accessToken!, username: SpotifyLogin.shared.username!)
//            }
//            print("what")
//        }
        data().main()
        print("applicationDidBecomeActive")
       
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let handled = SpotifyLogin.shared.applicationOpenURL(url) { (error) in }
        return handled
    }
    



}

