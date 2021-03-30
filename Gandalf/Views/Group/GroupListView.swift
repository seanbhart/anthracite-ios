//
//  GroupView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit

protocol GroupListViewDelegate {
    func loadGroup(group: String)
}

class GroupListView: UIViewController {
    let className = "GroupListView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var delegate: GroupListViewDelegate!
    var localGroups = [Group]()
    var groupRepository: GroupRepository!
    
    var viewContainer: UIView!
    var groupTableView: UITableView!
    let groupTableCellIdentifier: String = "GroupCell"
    var groupTableViewSpinner = UIActivityIndicatorView(style: .medium)
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        
        let barItemLogo = UIButton(type: .custom)
        barItemLogo.setImage(UIImage(named: Assets.Images.logotypeLg), for: .normal)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:110),
            barItemLogo.heightAnchor.constraint(equalToConstant:20),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItem = nil
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let groupRepo = groupRepository else { return }
            groupRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let groupRepo = groupRepository else { return }
            groupRepo.stopObserving()
        }
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
            viewContainer.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            groupTableView.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            groupTableView.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            groupTableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            groupTableView.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            groupTableViewSpinner.centerXAnchor.constraint(equalTo:groupTableView.centerXAnchor, constant: 0),
            groupTableViewSpinner.centerYAnchor.constraint(equalTo:groupTableView.centerYAnchor, constant: 0),
        ])
        
        if groupRepository == nil {
            groupRepository = GroupRepository()
            groupRepository.delegate = self
        }
        groupRepository.observeQuery()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        guard let groupRepo = groupRepository else { return }
        groupRepo.stopObserving()
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
        
        groupTableView = UITableView()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupTableView.dragInteractionEnabled = false
        groupTableView.register(GroupCell.self, forCellReuseIdentifier: groupTableCellIdentifier)
        groupTableView.separatorStyle = .none
        groupTableView.backgroundColor = .clear
        groupTableView.rowHeight = 40
//        groupTableView.sectionHeaderHeight = 25
        groupTableView.estimatedSectionHeaderHeight = 0
        groupTableView.estimatedSectionFooterHeight = 0
        groupTableView.isScrollEnabled = true
        groupTableView.bounces = true
        groupTableView.alwaysBounceVertical = true
        groupTableView.showsVerticalScrollIndicator = false
        groupTableView.isUserInteractionEnabled = true
        groupTableView.allowsSelection = true
//        groupTableView.delaysContentTouches = false
        groupTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        groupTableView.insetsContentViewsToSafeArea = true
        groupTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(groupTableView)
        
        groupTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        groupTableViewSpinner.startAnimating()
        groupTableView.addSubview(groupTableViewSpinner)
        groupTableViewSpinner.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
}
