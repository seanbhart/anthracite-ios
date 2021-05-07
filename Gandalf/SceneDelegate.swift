//
//  SceneDelegate.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit
import SwiftUI
//import FirebaseAnalytics
//import FirebaseAuth

protocol TabBarViewDelegate {
    func moveToTab(index: Int)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, UITabBarControllerDelegate, TabBarViewDelegate, AccountPrivateViewDelegate, StrategyViewDelegate, StrategyCreateViewDelegate, StrategyRepositoryDelegate, StrategyReactionRepositoryDelegate, AccountRepositoryDelegate, AccountPrivateRepositoryDelegate {
    let className = "SceneDelegate"
    
    // Create a local AccountRepository to access the account
    // receive callback results if needed
    var accountRepository: AccountRepository?
    var accountPrivateRepository: AccountPrivateRepository?
    var strategyRepository: StrategyRepository?
    var strategyReactionRepository: StrategyReactionRepository?

    var window: UIWindow?
    var tabBarController: UITabBarController!
    var strategyVC: StrategyView!
    var strategyVcNavController: UINavigationController!
    var strategyTabVC: StrategyTabView!
    var strategyTabVcNavController: UINavigationController!
    var accountVC: AccountPrivateView!
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
        
        strategyVC = StrategyView()
        strategyVC.delegate = self
        strategyVC.tabBarViewDelegate = self
        strategyVcNavController = UINavigationController(rootViewController: strategyVC)
        strategyVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        strategyVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        strategyVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        strategyVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageStrategyWhite = UIImage(systemName: "square.stack.3d.forward.dottedline.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        let tabImageStrategyColor = UIImage(systemName: "square.stack.3d.forward.dottedline.fill")?.withTintColor(Settings.Theme.Color.primaryLight, renderingMode: .alwaysOriginal)
        strategyVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageStrategyWhite, selectedImage: tabImageStrategyColor)
        
        strategyTabVC = StrategyTabView()
        strategyTabVC.tabBarViewDelegate = self
        strategyTabVcNavController = UINavigationController(rootViewController: strategyTabVC)
        strategyTabVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        strategyTabVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        strategyTabVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        strategyTabVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageStrategyCreateWhite = UIImage(systemName: "plus")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        let tabImageStrategyCreateColor = UIImage(systemName: "plus")?.withTintColor(Settings.Theme.Color.primaryLight, renderingMode: .alwaysOriginal)
        strategyTabVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageStrategyCreateWhite, selectedImage: tabImageStrategyCreateColor)
        
        accountVC = AccountPrivateView()
        accountVC.delegate = self
        accountVC.tabBarViewDelegate = self
        accountVcNavController = UINavigationController(rootViewController: accountVC)
        accountVcNavController.navigationBar.barStyle = Settings.Theme.barStyle
        accountVcNavController.navigationBar.barTintColor = Settings.Theme.Color.barColor
        accountVcNavController.navigationBar.tintColor = Settings.Theme.Color.barText
        accountVcNavController.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: Settings.Theme.Color.barText]
        let tabImageAccountWhite = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.barText, renderingMode: .alwaysOriginal)
        let tabImageAccountColor = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.secondary, renderingMode: .alwaysOriginal)
        accountVcNavController.tabBarItem = UITabBarItem(title: "", image: tabImageAccountWhite, selectedImage: tabImageAccountColor)
        
        tabBarController = UITabBarController()
        tabBarController.delegate = self
//        tabBarController.tabBar.barStyle = .black
        tabBarController.tabBar.backgroundColor = Settings.Theme.Color.barColor
        tabBarController.tabBar.barTintColor = Settings.Theme.Color.barColor
        tabBarController.tabBar.isTranslucent = false
        tabBarController.tabBar.clipsToBounds = true
        tabBarController.viewControllers = [strategyVcNavController, strategyTabVcNavController, accountVcNavController]
        tabBarController.selectedIndex = Settings.Tabs.strategyVcIndex
        
//        // If a user is not logged in, display the Login screen
//        if let firUser = Settings.Firebase.auth().currentUser {
//            print("\(className) - currentUser: \(firUser.uid)")
//            tabBarController.selectedIndex = Settings.Tabs.strategyVcIndex
//        }
        
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
        
        if strategyRepository == nil {
            strategyRepository = StrategyRepository()
            strategyRepository!.delegate = self
            strategyRepository!.observeQuery()
        } else {
            strategyRepository!.observeQuery()
        }
        
        if strategyReactionRepository == nil {
            strategyReactionRepository = StrategyReactionRepository()
            strategyReactionRepository!.delegate = self
            strategyReactionRepository!.observeQuery()
        } else {
            strategyReactionRepository!.observeQuery()
        }
        
        if accountRepository == nil {
            accountRepository = AccountRepository()
            accountRepository!.delegate = self
            accountRepository!.observeQuery()
        } else {
            accountRepository!.observeQuery()
        }
        
        if accountPrivateRepository == nil {
            accountPrivateRepository = AccountPrivateRepository()
            accountPrivateRepository!.delegate = self
            accountPrivateRepository!.observeDoc()
        } else {
            accountPrivateRepository!.observeDoc()
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("\(className) - sceneDidEnterBackground")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        if let strategyRepo = strategyRepository {
            strategyRepo.stopObserving()
        }
        
        if let strategyReactionRepo = strategyReactionRepository {
            strategyReactionRepo.stopObserving()
        }
        
        if let accountRepo = accountRepository {
            accountRepo.stopObserving()
        }
        
        if let accountPrivateRepo = accountPrivateRepository {
            accountPrivateRepo.stopObserving()
        }
    }
    
    
    // MARK: -TABBARCONTROLLER METHODS
//    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
//        print("\(className) - tabBarController didSelect: \(viewController)")
//        guard let _ = Settings.Firebase.auth().currentUser else {
//            print("\(className) - tabBarController didSelect: No user logged in; remain in Account view")
//            tabBarController.selectedIndex = Settings.Tabs.accountVcIndex
//            return
//        }
//    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        print("\(className) - tabBarController shouldSelect: \(viewController.children)")
        if viewController.children.filter({ $0 is StrategyTabView }).count > 0 {
            print("\(className) - tabBarController presentSheet")
            let strategyCreateView = StrategyCreateView()
            strategyCreateView.delegate = self
            let navigationController = UINavigationController(rootViewController: strategyCreateView)
            navigationController.modalPresentationStyle = UIModalPresentationStyle.pageSheet
            navigationController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            tabBarController.present(navigationController, animated: true, completion: nil)
//            tabBarController.presentSheet(with: strategyCreateVcNavController)
            return false
        }
        return true
    }

    
    // MARK: -TAB BAR VIEW METHODS
    func moveToTab(index: Int) {
        print("\(self.className) - moveToTab: \(index)")
        tabBarController.selectedIndex = index
    }
    
    
    // MARK: -STRATEGY VIEW METHODS
    func strategyReaction(strategyId: String, type: Int) {
        print("\(self.className) - strategyReaction")
        if let strategyReactionRepo = self.strategyReactionRepository {
            strategyReactionRepo.createReaction(strategyId: strategyId, type: type)
        } else {
            self.strategyReactionRepository = StrategyReactionRepository()
            self.strategyReactionRepository!.delegate = self
            self.strategyReactionRepository!.createReaction(strategyId: strategyId, type: type)
            self.strategyReactionRepository!.observeQuery()
        }
    }
    
    
    // MARK: -STRATEGY CREATE METHODS
    func createStrategy(strategy: Strategy) {
        print("\(className) - strategy: \(strategy)")
        tabBarController.dismiss(animated: true, completion: {
            print("\(self.className) - create strategy")
            if let strategyRepo = self.strategyRepository {
                strategyRepo.createStrategy(strategy: strategy)
            } else {
                self.strategyRepository = StrategyRepository()
                self.strategyRepository!.delegate = self
                self.strategyRepository!.createStrategy(strategy: strategy)
                self.strategyRepository!.observeQuery()
            }
        })
    }
    
    
    // MARK: -STRATEGY REPO METHODS
    
    func strategyDataUpdate() {
        guard let strategyRepo = strategyRepository else { return }
        strategyVC.updateStrategies(strategies: strategyRepo.strategies)
        accountVC.updateStrategies(strategies: strategyRepo.strategies)
    }
    
    func showLogin() {
        print("\(className) - showLogin")
        moveToTab(index: Settings.Tabs.accountVcIndex)
    }
    
    
    // MARK: -STRATEGY REACTION REPO METHODS
    
    func strategyReactionDataUpdate() {
        print("\(className) - strategyReactionDataUpdate")
        guard let strategyReactionRepo = strategyReactionRepository else { return }
        strategyVC.updateStrategyReactions(reactions: strategyReactionRepo.reactions)
        accountVC.updateStrategyReactions(reactions: strategyReactionRepo.reactions)
    }
    
    
    // MARK: -ACCOUNT REPOS METHODS
    
    func accountDataUpdate() {
        print("\(className) - Account Data update")
        guard let accountRepo = accountRepository else { return }
        strategyVC.updateAccounts(accounts: accountRepo.accounts)
    }
    
    func accountPrivateDataUpdate() {
        print("\(className) - Account Private Data update")
    }
    
    func requestError(title: String, message: String) {
        print("\(className) - Account Repo error: \(title): \(message)")
    }
}
