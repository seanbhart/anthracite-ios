//
//  StrategyView.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit
import FirebaseAuth

protocol StrategyViewDelegate {
//    func loadStrategy(strategy: String)
    func strategyReaction(strategyId: String, type: Int)
}

class StrategyView: UIViewController, UIGestureRecognizerDelegate {
    let className = "StrategyView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var delegate: StrategyViewDelegate!
    var localStrategies = [Strategy]()
    var localAccounts = [Account]()
//    var strategyRepository: StrategyRepository!
    var detailView: StrategyDetailView?
    
    var viewContainer: UIView!
    var strategyTableView: UITableView!
    let strategyTableCellIdentifier: String = "StrategyCell"
    var strategyTableViewSpinner = UIActivityIndicatorView(style: .medium)
    
//    private var observer: NSObjectProtocol?
    
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
        
//        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
//            print("\(className) - willEnterForegroundNotification")
//            guard let strategyRepo = strategyRepository else { return }
//            strategyRepo.observeQuery()
//        }
//        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
//            print("\(className) - didEnterBackgroundNotification")
//            guard let strategyRepo = strategyRepository else { return }
//            strategyRepo.stopObserving()
//        }
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

        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            strategyTableView.topAnchor.constraint(equalTo: viewContainer.topAnchor),
            strategyTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            strategyTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            strategyTableView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            strategyTableViewSpinner.centerXAnchor.constraint(equalTo: strategyTableView.centerXAnchor, constant: 0),
            strategyTableViewSpinner.centerYAnchor.constraint(equalTo: strategyTableView.centerYAnchor, constant: 0),
        ])
        
//        if strategyRepository == nil {
//            strategyRepository = StrategyRepository()
//            strategyRepository.delegate = self
//        }
//        strategyRepository.observeQuery()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
//        guard let strategyRepo = strategyRepository else { return }
//        strategyRepo.stopObserving()
    }

    override func loadView() {
        super.loadView()
        print("\(className) - loadView")
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.Color.background
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        strategyTableView = UITableView()
        strategyTableView.dataSource = self
        strategyTableView.delegate = self
        strategyTableView.dragInteractionEnabled = false
        strategyTableView.register(StrategyCell.self, forCellReuseIdentifier: strategyTableCellIdentifier)
        strategyTableView.separatorStyle = .none
        strategyTableView.backgroundColor = .clear
        strategyTableView.isSpringLoaded = true
        strategyTableView.rowHeight = UITableView.automaticDimension
        strategyTableView.estimatedRowHeight = UITableView.automaticDimension
//        strategyTableView.estimatedRowHeight = 0
        strategyTableView.estimatedSectionHeaderHeight = 0
        strategyTableView.estimatedSectionFooterHeight = 0
        strategyTableView.isScrollEnabled = true
        strategyTableView.bounces = true
        strategyTableView.alwaysBounceVertical = true
        strategyTableView.showsVerticalScrollIndicator = false
        strategyTableView.isUserInteractionEnabled = true
        strategyTableView.allowsSelection = true
//        strategyTableView.delaysContentTouches = false
        strategyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        strategyTableView.insetsContentViewsToSafeArea = true
        strategyTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(strategyTableView)
        
        strategyTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        strategyTableViewSpinner.startAnimating()
        strategyTableView.addSubview(strategyTableViewSpinner)
        strategyTableViewSpinner.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -DATA METHODS
    
    func updateStrategies(strategies: [Strategy]) {
        localStrategies.removeAll()
        localStrategies = strategies
        if strategyTableView != nil {
            strategyTableView.reloadData()
            strategyTableViewSpinner.stopAnimating()
            
            updateDetailViewStrategy()
        }
    }
    
    func updateStrategyReactions(reactions: [StrategyReaction]) {
        for (i, s) in localStrategies.enumerated() {
            localStrategies[i].reactions = reactions.filter { return $0.strategy == s.id }
        }
        if strategyTableView != nil {
            strategyTableView.reloadData()
            strategyTableViewSpinner.stopAnimating()
            
            updateDetailViewStrategy()
        }
    }
    
    func updateDetailViewStrategy() {
        // If a detail view has been created, update the data
        guard let dView = detailView else { return }
        if dView.strategy == nil { return }
        for s in localStrategies {
            if s.id == dView.strategy.id {
                detailView!.updateStrategyData(strategy: s)
                break
            }
        }
    }
    
    func updateAccounts(accounts: [Account]) {
        localAccounts.removeAll()
        localAccounts = accounts
        if strategyTableView != nil {
            strategyTableView.reloadData()
            strategyTableViewSpinner.stopAnimating()
            
            // If a detail view has been created, update the data
            guard let dView = detailView else { return }
            if dView.strategy == nil { return }
            for a in localAccounts {
                if a.id == dView.strategy.creator {
                    detailView!.updateAccountData(account: a)
                    break
                }
            }
        }
    }
}
