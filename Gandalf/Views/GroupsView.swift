//
//  GroupsView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
import FirebaseAuth

class GroupsView: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, GroupRepositoryDelegate {
    let className = "GroupsView"
    
    var localGroups = [Group]()
    var groupRepository: GroupRepository!
    
    var viewContainer: UIView!
    var addContainer: UIView!
    var addField: UITextField!
    var addLabel: UILabel!
    var groupsTableView: UITableView!
    let groupsTableCellIdentifier: String = "GroupsCell"
    var groupsTableViewRefreshControl: UIRefreshControl!
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            groupRepository.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            groupRepository.stopObserving()
        }
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
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
            addContainer.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            addContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            addContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            addContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            addField.topAnchor.constraint(equalTo:addContainer.topAnchor),
            addField.leftAnchor.constraint(equalTo:addContainer.leftAnchor),
            addField.rightAnchor.constraint(equalTo:addContainer.rightAnchor),
            addField.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            addLabel.topAnchor.constraint(equalTo:addField.bottomAnchor),
            addLabel.leftAnchor.constraint(equalTo:addContainer.leftAnchor),
            addLabel.rightAnchor.constraint(equalTo:addContainer.rightAnchor),
            addLabel.bottomAnchor.constraint(equalTo:addContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            groupsTableView.topAnchor.constraint(equalTo:addContainer.bottomAnchor),
            groupsTableView.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            groupsTableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            groupsTableView.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
        ])
        
        if groupRepository != nil {
            groupRepository.observeQuery()
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        if groupRepository != nil {
            groupRepository.stopObserving()
        }
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
        
        addContainer = UIView()
        addContainer.backgroundColor = Settings.Theme.Color.contentBackground
        addContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(addContainer)
        
        addField = UITextField()
        addField.backgroundColor = .clear
        addField.placeholder = "Group Code"
        addField.font = UIFont(name: Assets.Fonts.Default.extraBold, size: 30)
        addField.textColor = Settings.Theme.Color.text
        addField.textAlignment = NSTextAlignment.center
        addField.isUserInteractionEnabled = true
        addField.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(addField)
        
        addLabel = UILabel()
        addLabel.backgroundColor = Settings.Theme.Color.contentBackground
        addLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        addLabel.textColor = Settings.Theme.Color.text
        addLabel.textAlignment = NSTextAlignment.center
        addLabel.numberOfLines = 1
        addLabel.text = "New Group"
        addLabel.isUserInteractionEnabled = false
        addLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(addLabel)
        
        groupsTableView = UITableView()
        groupsTableView.dataSource = self
        groupsTableView.delegate = self
        groupsTableView.dragInteractionEnabled = false
        groupsTableView.register(GroupCell.self, forCellReuseIdentifier: groupsTableCellIdentifier)
        groupsTableView.separatorStyle = .none
        groupsTableView.backgroundColor = .clear
        groupsTableView.estimatedRowHeight = 0
        groupsTableView.estimatedSectionHeaderHeight = 0
        groupsTableView.estimatedSectionFooterHeight = 0
        groupsTableView.isScrollEnabled = false
        groupsTableView.bounces = false
        groupsTableView.alwaysBounceVertical = false
        groupsTableView.showsVerticalScrollIndicator = false
        groupsTableView.isUserInteractionEnabled = true
        groupsTableView.allowsSelection = false
//        groupsTableView.delaysContentTouches = false
        groupsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        groupsTableView.insetsContentViewsToSafeArea = true
        groupsTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(groupsTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: -TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groupsTableCellIdentifier, for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.title.text = localGroups[indexPath.row].title
        return cell
    }
    
    
    // MARK: -REPOSITORY METHODS
    
    func groupDataUpdate() {
        localGroups = groupRepository.groups
    }
}
