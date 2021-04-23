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

protocol TabBarViewDelegate {
    func moveToTab(index: Int)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate, TabBarViewDelegate, AccountRepositoryDelegate {
    let className = "SceneDelegate"
    
//    // Create a local AccountRepository to access the account
//    // receive callback results if needed
//    var accountRepository: AccountRepository?

    var window: UIWindow?
    var tabBarController: UITabBarController!
    var portfoliosVC: PortfoliosView!
    var portfoliosVcNavController: UINavigationController!
    var accountVC: AccountView!
    var accountVcNavController: UINavigationController!
    
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
        
        portfoliosVC = PortfoliosView()
        portfoliosVC.tabBarViewDelegate = self
        portfoliosVcNavController = UINavigationController(rootViewController: portfoliosVC)
        portfoliosVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        portfoliosVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        portfoliosVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        portfoliosVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
//         chart.pie.fill, circle.dashed.inset.fill, gauge, shield.lefthalf.fill, cone.fill, wand.and.rays
        let tabImageLbGray = UIImage(systemName: "circle.dashed.inset.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let tabImageLbColor = UIImage(systemName: "circle.dashed.inset.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        portfoliosVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageLbGray, selectedImage: tabImageLbColor)

        accountVC = AccountView()
        accountVC.tabBarViewDelegate = self
        accountVcNavController = UINavigationController(rootViewController: accountVC)
        accountVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        accountVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        accountVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        accountVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageAccountGray = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        let tabImageAccountColor = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        accountVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageAccountGray, selectedImage: tabImageAccountColor)
        
        tabBarController = UITabBarController()
        tabBarController.delegate = self
//        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.barTintColor = Settings.Theme.Color.background
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.viewControllers = [portfoliosVcNavController, accountVcNavController]
        tabBarController.selectedIndex = Settings.Tabs.accountVcIndex
        
        // If a user is not logged in, display the Login screen
        if let firUser = Settings.Firebase.auth().currentUser {
            print("\(className) - currentUser: \(firUser.uid)")
            tabBarController.selectedIndex = Settings.Tabs.portfolioVcIndex
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
        
        // If no user has logged in, show the login screen
        if Settings.Firebase.auth().currentUser == nil {
            moveToTab(index: Settings.Tabs.accountVcIndex)
        }
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
        guard let _ = Settings.Firebase.auth().currentUser else {
            print("\(className) - tabBarController didSelect: No user logged in; remain in Account view")
            tabBarController.selectedIndex = Settings.Tabs.accountVcIndex
            return
        }
    }

    
    // MARK: -TAB BAR VIEW METHODS
    func moveToTab(index: Int) {
        tabBarController.selectedIndex = index
    }
    
    
    // MARK: -ACCOUNT REPO METHODS
    
    func accountDataUpdate() {
        print("\(className) - Account Data update")
    }
    
    func requestError(title: String, message: String) {
        print("\(className) - Account Repo error: \(title): \(message)")
    }
    
    func showLogin() {
        moveToTab(index: Settings.Tabs.accountVcIndex)
    }
}
