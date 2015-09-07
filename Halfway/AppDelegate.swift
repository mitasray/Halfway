//
//  AppDelegate.swift
//  Halfway
//
//  Created by Mitas Ray on 6/3/15.
//  Copyright (c) 2015 mitas.ray. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let config = Realm.Configuration(
            schemaVersion: 6,
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    migration.enumerate(User.className()) { oldObject, newObject in
                        newObject!["id"] = oldObject!["user_id"] as! Int
                    }
                }
                if oldSchemaVersion < 2 {
                    migration.enumerate(User.className()) { oldObject, newObject in
                        newObject!["friends"] = List<User>()
                    }
                }
                if oldSchemaVersion < 3 {
                    migration.enumerate(User.className()) { oldObject, newObject in
                        newObject!["email"] = ""
                    }
                }
                if oldSchemaVersion < 4 {
                    migration.enumerate(User.className()) { oldObject, newObject in
                        newObject!["events"] = List<Event>()
                    }
                }
                if oldSchemaVersion < 5 {
                    migration.enumerate(User.className()) { oldObject, newObject in
                        newObject!["latitude"] = 0.0
                        newObject!["longitude"] = 0.0
                    }
                }
                if oldSchemaVersion < 6 {
                    migration.enumerate(Event.className()) { oldObject, newObject in
                        newObject!["address"] = ""
                        newObject!["meeting_point"] = ""
                    }
                }
            }
        )
        
        Realm.Configuration.defaultConfiguration = config
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        var initialViewController = storyboard.instantiateViewControllerWithIdentifier("LoginNavigation") as! UIViewController
        if user_logged_in() {
            initialViewController = storyboard.instantiateViewControllerWithIdentifier("reveal") as! UIViewController
        }
        
        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        return true
    }
    
    private func user_logged_in() -> Bool {
        return Realm().objects(User).count > 0
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

