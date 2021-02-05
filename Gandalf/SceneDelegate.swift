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
//import SideMenuSwift

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate {
    let className = "SceneDelegate"

    var window: UIWindow?
    
    var notionVC = NotionView()
    var notionVcNavController: UINavigationController!
    let notionVcIndex = 0
    var groupVC = GroupView()
    var groupVcNavController: UINavigationController!
    let groupVcIndex = 1
    var profileVC = ProfileView()
    var profileVcNavController: UINavigationController!
    let profileVcIndex = 2

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = Settings.Theme.Color.barColor
            appearance.shadowColor = .clear
            appearance.titleTextAttributes = [.foregroundColor: Settings.Theme.Color.barText]
            appearance.largeTitleTextAttributes = [.foregroundColor: Settings.Theme.Color.barText]

            UINavigationBar.appearance().barStyle = Settings.Theme.barStyle
            UINavigationBar.appearance().tintColor = Settings.Theme.Color.barText
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barStyle = Settings.Theme.barStyle
            UINavigationBar.appearance().tintColor = Settings.Theme.Color.barText
            UINavigationBar.appearance().barTintColor = Settings.Theme.Color.barColor
            UINavigationBar.appearance().isTranslucent = false
        }
        
        notionVcNavController = UINavigationController(rootViewController: notionVC)
        notionVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        notionVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        notionVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        notionVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageNotionWhite = UIImage(systemName: "globe")?.withTintColor(.white, renderingMode: .alwaysOriginal) //"list.bullet.rectangle" "tablecells.fill"
        let tabImageNotionColor = UIImage(systemName: "globe")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        notionVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageNotionWhite, selectedImage: tabImageNotionColor)
        
        groupVcNavController = UINavigationController(rootViewController: groupVC)
        groupVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        groupVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        groupVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        groupVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
//        let groupVcSideMenuController = SideMenuController(contentViewController: groupVcNavController, menuViewController: groupVC)
        let tabImageGroupWhite = UIImage(systemName: "text.bubble.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let tabImageGroupColor = UIImage(systemName: "text.bubble.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        groupVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageGroupWhite, selectedImage: tabImageGroupColor)
//        SideMenuController.preferences.basic.menuWidth = 300
//        SideMenuController.preferences.basic.position = .sideBySide
//        SideMenuController.preferences.basic.direction = .left
//        SideMenuController.preferences.basic.enablePanGesture = true
//        SideMenuController.preferences.basic.supportedOrientations = .portrait
        
        profileVcNavController = UINavigationController(rootViewController: profileVC)
        profileVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        profileVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        profileVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        profileVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageProfileWhite = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        let tabImageProfileColor = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        profileVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageProfileWhite, selectedImage: tabImageProfileColor)
        
        let tabBarController = UITabBarController()
        tabBarController.delegate = self
//        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.barTintColor = Settings.Theme.Color.background
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.viewControllers = [notionVcNavController, groupVcNavController, profileVcNavController]
        tabBarController.selectedIndex = profileVcIndex
        
        // If a user is not logged in, display the Login screen
        if let firUser = Auth.auth().currentUser {
            print("\(className) - currentUser: \(firUser.uid)")
            tabBarController.selectedIndex = notionVcIndex
        }
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            window.rootViewController = tabBarController
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
    
    
    // MARK: -TABBARCONTROLLER METHODS

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        print("\(className) - tabBarController didSelect: \(viewController)")
        guard let _ = Auth.auth().currentUser else {
            print("\(className) - tabBarController didSelect: No user logged in; remain in Profile view")
            tabBarController.selectedIndex = profileVcIndex
            return
        }
    }

}

