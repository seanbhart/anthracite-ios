//
//  SceneDelegate.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit
import SwiftUI
//import FirebaseAnalytics
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    let className = "SceneDelegate"

    var window: UIWindow?
    var navController: UINavigationController!
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = Settings.Theme.Color.barColor
            appearance.titleTextAttributes = [.foregroundColor: Settings.Theme.Color.barText]
            appearance.largeTitleTextAttributes = [.foregroundColor: Settings.Theme.Color.barText]

//            UINavigationBar.appearance().barStyle = .default
            UINavigationBar.appearance().tintColor = Settings.Theme.Color.barText
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
//            UINavigationBar.appearance().barStyle = .default
            UINavigationBar.appearance().tintColor = Settings.Theme.Color.barText
            UINavigationBar.appearance().barTintColor = Settings.Theme.Color.barColor
            UINavigationBar.appearance().isTranslucent = false
        }
        
        // If a user is not logged in, display the Login screen
        var rootView: UIViewController = ProfileView()
        if let firUser = Auth.auth().currentUser {
            print("\(className) - currentUser: \(firUser.uid)")
            rootView = NotionView()
        }
        
        navController = UINavigationController(rootViewController: rootView)
//        navController.navigationBar.barStyle = Settings.Theme.barStyle
//        navController.navigationBar.barTintColor = Settings.Theme.navBarBackground
//        navController.navigationBar.tintColor = Settings.Theme.navBarText
        navController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        navController.navigationBar.topItem?.title = "Gandalf"

        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.rootViewController = navController
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("\(className) - sceneDidDisconnect")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("\(className) - sceneDidBecomeActive")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("\(className) - sceneWillResignActive")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("\(className) - sceneWillEnterForeground")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("\(className) - sceneDidEnterBackground")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

