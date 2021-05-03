//
//  StrategyTabView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/1/21.
//

import UIKit

class StrategyTabView: UIViewController {
    let className = "StrategyTabView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        let barItemLogo = UIButton(type: .custom)
        barItemLogo.setImage(UIImage(named: Assets.Images.hatIconPurpleLg), for: .normal)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant: 30),
            barItemLogo.heightAnchor.constraint(equalToConstant: 30),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(className) - viewWillAppear")
//        setNeedsStatusBarAppearanceUpdate()
        // Ensure the navigation bar is not hidden
        if let nc = self.navigationController {
            nc.setNavigationBarHidden(false, animated: animated)
//            nc.navigationBar.barStyle = Settings.Theme.barStyle
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
    }

    override func loadView() {
        super.loadView()
        print("\(className) - loadView")
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.Color.background
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
}



