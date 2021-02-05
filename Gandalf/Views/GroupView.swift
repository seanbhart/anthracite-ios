//
//  GroupView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
import FirebaseAuth

protocol GroupViewDelegate {
    func loadGroup(group: String)
}

class GroupView: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, GroupRepositoryDelegate {
    let className = "GroupView"
    
    var delegate: GroupViewDelegate!
    var localGroups = [Group]()
    var groupRepository: GroupRepository!
    
    var viewContainer: UIView!
    var groupTableView: UITableView!
    let groupTableCellIdentifier: String = "GroupCell"
    var groupTableViewRefreshControl: UIRefreshControl!
    var groupTableViewSpinner = UIActivityIndicatorView(style: .medium)
    var addContainer: UIView!
    var addIcon: UIImageView!
    var codeContainer: UIView!
    var codeIcon: UIImageView!
    
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
            addContainer.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor, constant: -5),
            addContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor, constant: 5),
            addContainer.rightAnchor.constraint(equalTo:viewContainer.centerXAnchor, constant: -5),
            addContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            addIcon.centerXAnchor.constraint(equalTo:addContainer.centerXAnchor),
            addIcon.centerYAnchor.constraint(equalTo:addContainer.centerYAnchor),
            addIcon.widthAnchor.constraint(equalToConstant: 50),
            addIcon.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            codeContainer.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor, constant: -5),
            codeContainer.leftAnchor.constraint(equalTo:viewContainer.centerXAnchor, constant: 5),
            codeContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor, constant: -5),
            codeContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            codeIcon.centerXAnchor.constraint(equalTo:codeContainer.centerXAnchor),
            codeIcon.centerYAnchor.constraint(equalTo:codeContainer.centerYAnchor),
            codeIcon.widthAnchor.constraint(equalToConstant: 50),
            codeIcon.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            groupTableView.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            groupTableView.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            groupTableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            groupTableView.bottomAnchor.constraint(equalTo:addContainer.topAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            groupTableViewSpinner.centerXAnchor.constraint(equalTo:groupTableView.centerXAnchor, constant: 0),
            groupTableViewSpinner.centerYAnchor.constraint(equalTo:groupTableView.centerYAnchor, constant: 0),
        ])
        
        guard let groupRepo = groupRepository else { return }
        groupRepo.getGroups()
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
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        addContainer = UIView()
        addContainer.backgroundColor = Settings.Theme.Color.contentBackground
        addContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(addContainer)
        
        let addContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(addGroup))
        addContainerGestureRecognizer.numberOfTapsRequired = 1
        addContainer.addGestureRecognizer(addContainerGestureRecognizer)
        
        addIcon = UIImageView()
        addIcon.image = UIImage(systemName: "plus.square.fill")
        addIcon.contentMode = UIView.ContentMode.scaleAspectFit
        addIcon.clipsToBounds = true
        addIcon.translatesAutoresizingMaskIntoConstraints = false
        addContainer.addSubview(addIcon)
        
        codeContainer = UIView()
        codeContainer.backgroundColor = Settings.Theme.Color.contentBackground
        codeContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(codeContainer)
        
        let codeContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(joinGroup))
        codeContainerGestureRecognizer.numberOfTapsRequired = 1
        codeContainer.addGestureRecognizer(codeContainerGestureRecognizer)
        
        codeIcon = UIImageView()
        codeIcon.image = UIImage(systemName: "plus.magnifyingglass")
        codeIcon.contentMode = UIView.ContentMode.scaleAspectFit
        codeIcon.clipsToBounds = true
        codeIcon.translatesAutoresizingMaskIntoConstraints = false
        codeContainer.addSubview(codeIcon)
        
        groupTableViewRefreshControl = UIRefreshControl()
        groupTableViewRefreshControl.tintColor = Settings.Theme.Color.text
        groupTableViewRefreshControl.addTarget(self, action: #selector(refreshGroups), for: .valueChanged)
        
        groupTableView = UITableView()
        groupTableView.dataSource = self
        groupTableView.delegate = self
        groupTableView.refreshControl = groupTableViewRefreshControl
        groupTableView.dragInteractionEnabled = false
        groupTableView.register(GroupCell.self, forCellReuseIdentifier: groupTableCellIdentifier)
        groupTableView.separatorStyle = .none
        groupTableView.backgroundColor = .clear
        groupTableView.rowHeight = 100
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
        
        groupRepository = GroupRepository()
        groupRepository.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    @objc func refreshGroups() {
        guard let groupRepo = groupRepository else { return }
        groupRepo.getGroups()
    }

    
    // MARK: -TABLEVIEW METHODS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groupTableCellIdentifier, for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.title.text = localGroups[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
        self.navigationController?.pushViewController(MessageView(group: localGroups[indexPath.row]), animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != groupTableView { return nil }
        let copyCode = UIContextualAction(style: .normal, title: "COPY CODE") { (action, view, completionHandler) in
            print("COPY CODE: \(indexPath.row)")
            let group = self.localGroups[indexPath.row]
            guard let groupId = group.id else { return }
            UIPasteboard.general.string = groupId
            
            let alert = UIAlertController(title: "", message: "Copied to clipboard.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            completionHandler(true)
        }
        copyCode.backgroundColor = Settings.Theme.Color.barText
        let editName = UIContextualAction(style: .normal, title: "EDIT NAME") { (action, view, completionHandler) in
            print("EDIT TITLE: \(indexPath.row)")
            let group = self.localGroups[indexPath.row]
            guard let groupId = group.id else { return }
            self.editTitle(groupId: groupId, currentTitle: group.title)
            completionHandler(true)
        }
        editName.backgroundColor = Settings.Theme.Color.contentBackgroundLight
        return UISwipeActionsConfiguration(actions: [copyCode, editName])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != groupTableView { return nil }
        let remove = UIContextualAction(style: .normal, title: "REMOVE ME") { (action, view, completionHandler) in
            print("REMOVE FROM GROUP: \(indexPath.row)")
            let group = self.localGroups[indexPath.row]
            
            // Alert to confirm removal of group
            let alert = UIAlertController(title: "Confirm Remove Group", message: "Are you sure you want to remove yourself from \(group.title)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
                guard let groupId = group.id else { return }
                self.groupRepository.removeCurrentAccount(groupId: groupId)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        remove.backgroundColor = Settings.Theme.Color.negative
        return UISwipeActionsConfiguration(actions: [remove])
    }
    
    // MARK: -REPOSITORY METHODS
    
    func groupDataUpdate() {
        guard let groupRepo = groupRepository else { return }
        localGroups.removeAll()
        localGroups = groupRepo.groups
        groupTableView.reloadData()
        groupTableViewRefreshControl.endRefreshing()
        groupTableViewSpinner.stopAnimating()
    }
    
    func requestError(message: String) {
        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: -GESTURE METHODS
    
    @objc func addGroup(_ sender: UITapGestureRecognizer) {
        print("\(className) - addGroup")
        let alert = UIAlertController(title: "New Group", message: "Please name your new group.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("ADD GROUP: \(textField.text)")
            guard let name = textField.text else { return }
            if name.count > 0 {
                self.groupRepository.createGroup(title: name)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Name"
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.yes
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
                    if let tf = notification.object as? UITextField {
                        let maxLength = 20
                        if let text = tf.text {
                            if text.count > maxLength {
                                tf.text = String(text.prefix(maxLength))
                            }
                        }
                    }
                })
        })
        self.present(alert, animated: true)
    }
    @objc func joinGroup(_ sender: UITapGestureRecognizer) {
        print("\(className) - joinGroup")
        let alert = UIAlertController(title: "Join Group", message: "Please enter a group code provided by a current group member.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("JOIN GROUP: \(textField.text)")
            guard let code = textField.text else { return }
            if code.count > 0 {
                self.groupRepository.joinGroup(code: code)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Code"
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        })
        self.present(alert, animated: true)
    }
    
    func editTitle(groupId: String, currentTitle: String) {
        print("\(className) - editName")
        let alert = UIAlertController(title: "Edit Name", message: "Rename the group. All group members will see the new name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("EDIT GROUP: \(textField.text)")
            guard let title = textField.text else { return }
            if title.count > 0 {
                self.groupRepository.editGroupTitle(groupId: groupId, title: title)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Name"
            textField.text = currentTitle
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
                    if let tf = notification.object as? UITextField {
                        let maxLength = 20
                        if let text = tf.text {
                            if text.count > maxLength {
                                tf.text = String(text.prefix(maxLength))
                            }
                        }
                    }
                })
        })
        self.present(alert, animated: true)
    }
}
