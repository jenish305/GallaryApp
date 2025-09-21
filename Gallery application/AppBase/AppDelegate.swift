//
//  AppDelegate.swift
//  Gallery application
//
//  Created by Jenish  Mac  on 19/09/25.
//

import UIKit
import GoogleSignIn
import CoreData


@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let model = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.managedObjectModel
        for entity in model.entities {
            print("Loaded entity: \(entity.name ?? "nil")")
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Core Data stack
       lazy var persistentContainer: NSPersistentContainer = {
           let container = NSPersistentContainer(name: "GalleryModelDM") // 👈 must match your .xcdatamodeld file name
           container.loadPersistentStores(completionHandler: { (_, error) in
               if let error = error as NSError? {
                   fatalError("❌ Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()

       // MARK: - Core Data Saving support
       func saveContext () {
           let context = persistentContainer.viewContext
           if context.hasChanges {
               do {
                   try context.save()
               } catch {
                   let nserror = error as NSError
                   fatalError("❌ Unresolved error \(nserror), \(nserror.userInfo)")
               }
           }
       }


}

