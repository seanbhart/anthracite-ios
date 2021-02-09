//
//  MessageView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/1/21.
//

import UIKit
import FirebaseAuth

class MessageView: UIViewController {
    let className = "MessageView"
    
    var initialLoad = true
    var allowEndEditing = false
    var currentGroup: Group!
    var localTickers = [Ticker]()
    var localMessages = [MessageGandalf]()
    var messageRepository: MessageRepository!
    var accountNames = [String: String]()
    var inputTickers = [MessageTicker]()
    var inputTickerStrings = [String]()
    
    var viewContainer: UIView!
    var headerLabel: UILabel!
    var inputContainer: UIView!
    let inputTableCellIdentifier: String = "InputCell"
    var inputTableView: UITableView!
    var inputTickerContainer: UIScrollView!
    var accessoryView: UIView!
    var accessoryViewBorder: UIView!
    var tickerContainer: UIView!
    var messageContainer: UIView!
    let tickerTableCellIdentifier: String = "MessageTickerCell"
    var tickerTableView: UITableView!
    var tickerTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let messageTableCellIdentifier: String = "MessageCell"
    var messageTableView: UITableView!
    var messageTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let messageCellHeight: CGFloat = 200
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        
        let title = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        title.backgroundColor = .clear
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 16)
        title.textColor = Settings.Theme.Color.primary
        title.textAlignment = NSTextAlignment.center
        title.numberOfLines = 1
        title.text = "# " + currentGroup.title
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        
//        self.navigationItem.title = "# " + currentGroup.title
        self.navigationItem.titleView = title
        self.navigationItem.hidesBackButton = false
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let messageRepo = messageRepository else { return }
            messageRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let messageRepo = messageRepository else { return }
            messageRepo.stopObserving()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    init(group: Group) {
        super.init(nibName: nil, bundle: nil)
        currentGroup = group
//        loadGroup(group: group)
        
        // Set new data
        guard let groupId = group.id else { return }
        messageRepository = MessageRepository(groupId: groupId)
        messageRepository.delegate = self
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            inputContainer.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
            inputContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            inputContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            inputContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            inputTableView.topAnchor.constraint(equalTo:inputContainer.topAnchor, constant: 0),
            inputTableView.leftAnchor.constraint(equalTo:inputContainer.leftAnchor, constant: 0),
            inputTableView.rightAnchor.constraint(equalTo:inputContainer.rightAnchor, constant: 0),
            inputTableView.bottomAnchor.constraint(equalTo:inputContainer.bottomAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            tickerContainer.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            tickerContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            tickerContainer.bottomAnchor.constraint(equalTo:inputContainer.topAnchor),
            tickerContainer.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            tickerTableView.topAnchor.constraint(equalTo:tickerContainer.topAnchor),
            tickerTableView.leftAnchor.constraint(equalTo:tickerContainer.leftAnchor),
            tickerTableView.rightAnchor.constraint(equalTo:tickerContainer.rightAnchor),
            tickerTableView.bottomAnchor.constraint(equalTo:tickerContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            tickerTableViewSpinner.centerXAnchor.constraint(equalTo:tickerTableView.centerXAnchor, constant: 0),
            tickerTableViewSpinner.centerYAnchor.constraint(equalTo:tickerTableView.centerYAnchor, constant: -100),
        ])
        NSLayoutConstraint.activate([
            messageContainer.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            messageContainer.leftAnchor.constraint(equalTo:tickerContainer.rightAnchor),
            messageContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            messageContainer.bottomAnchor.constraint(equalTo:inputContainer.topAnchor),
        ])
        NSLayoutConstraint.activate([
            messageTableView.topAnchor.constraint(equalTo:messageContainer.topAnchor),
            messageTableView.leftAnchor.constraint(equalTo:messageContainer.leftAnchor),
            messageTableView.rightAnchor.constraint(equalTo:messageContainer.rightAnchor),
            messageTableView.bottomAnchor.constraint(equalTo:messageContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            messageTableViewSpinner.centerXAnchor.constraint(equalTo:messageTableView.centerXAnchor, constant: 0),
            messageTableViewSpinner.centerYAnchor.constraint(equalTo:messageTableView.centerYAnchor, constant: -100),
        ])
        
        guard let messageRepo = messageRepository else { return }
        messageRepo.observeQuery()
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        // If the tutorial has not been viewed, show it for this user
//        if let firUser = Auth.auth().currentUser {
//            Settings.Firebase.db().collection("accounts").document(firUser.uid)
//                .getDocument { (document, error) in
//                    guard let doc = document else { self.showTutorial(); return }
//                    if !doc.exists { self.showTutorial(); return }
//                    guard let accountData = doc.data() else { self.showTutorial(); return }
//                    guard let tutorialsViewed = accountData["tutorials"] as? [String] else { self.showTutorial(); return }
//                    if (tutorialsViewed.firstIndex(of: "v1.0.0") == nil) {
//                        self.showTutorial()
//                    }
//                }
//        } else {
//            self.showTutorial()
//        }
    }
    
//    func showTutorial() {
//        let holeView = HoleView(holeViewPosition: 1, frame: viewContainer.bounds, circleOffsetX: 0, circleOffsetY: 0, circleRadius: 0, textOffsetX: (viewContainer.bounds.width / 2) - 160, textOffsetY: 60, textWidth: 320, textFontSize: 32, text: "Welcome to Gandalf!\n\nGandalf is an investment information app detecting public sentiment regarding tradeable assets to predict future prices.")
//        holeView.holeViewDelegate = self
//        viewContainer.addSubview(holeView)
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        guard let messageRepo = messageRepository else { return }
        messageRepo.addView()
        messageRepo.stopObserving()
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
        
        let viewContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(viewContainerTap))
        viewContainerGestureRecognizer.delegate = self
        viewContainerGestureRecognizer.numberOfTapsRequired = 1
        viewContainer.addGestureRecognizer(viewContainerGestureRecognizer)
        
        headerLabel = UILabel()
        headerLabel.backgroundColor = Settings.Theme.Color.contentBackground
        headerLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        headerLabel.textColor = Settings.Theme.Color.text
        headerLabel.textAlignment = NSTextAlignment.center
        headerLabel.numberOfLines = 1
        headerLabel.text = "Send your first message!"
        headerLabel.isUserInteractionEnabled = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        inputContainer = UIView()
        inputContainer.backgroundColor = Settings.Theme.Color.background
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(inputContainer)
        
        inputTableView = UITableView()
        inputTableView.dataSource = self
        inputTableView.delegate = self
        inputTableView.dragInteractionEnabled = false
        inputTableView.register(MessageInputCell.self, forCellReuseIdentifier: inputTableCellIdentifier)
        inputTableView.separatorStyle = .none
        inputTableView.backgroundColor = .clear
//        inputTableView.rowHeight = UITableView.automaticDimension
        inputTableView.estimatedRowHeight = 0
        inputTableView.estimatedSectionHeaderHeight = 0
        inputTableView.estimatedSectionFooterHeight = 0
        inputTableView.isScrollEnabled = false
        inputTableView.bounces = false
        inputTableView.alwaysBounceVertical = false
        inputTableView.showsVerticalScrollIndicator = false
        inputTableView.isUserInteractionEnabled = true
        inputTableView.allowsSelection = false
//        inputTableView.delaysContentTouches = false
        inputTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        inputTableView.insetsContentViewsToSafeArea = true
        inputTableView.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputTableView)
        
        accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        accessoryView.backgroundColor = Settings.Theme.Color.contentBackground
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        accessoryViewBorder = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        accessoryViewBorder.layer.borderColor = Settings.Theme.Color.textGrayDark.cgColor
        accessoryViewBorder.layer.borderWidth = 1
        accessoryViewBorder.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.addSubview(accessoryViewBorder)
        
        inputTickerContainer = UIScrollView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        inputTickerContainer.showsHorizontalScrollIndicator = false
        inputTickerContainer.backgroundColor = .clear
        inputTickerContainer.translatesAutoresizingMaskIntoConstraints = false
        accessoryView.addSubview(inputTickerContainer)
        
        tickerContainer = UIView()
        tickerContainer.backgroundColor = Settings.Theme.Color.background
        tickerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tickerContainer)
        
        tickerTableView = UITableView()
        tickerTableView.dataSource = self
        tickerTableView.delegate = self
//        tickerTableView.refreshControl = tickerTableViewRefreshControl
        tickerTableView.dragInteractionEnabled = true
        tickerTableView.register(MessageTickerCell.self, forCellReuseIdentifier: tickerTableCellIdentifier)
        tickerTableView.separatorStyle = .none
        tickerTableView.backgroundColor = .clear
        tickerTableView.estimatedRowHeight = 0
        tickerTableView.estimatedSectionHeaderHeight = 0
        tickerTableView.estimatedSectionFooterHeight = 0
        tickerTableView.isScrollEnabled = true
        tickerTableView.bounces = true
        tickerTableView.alwaysBounceVertical = true
        tickerTableView.showsVerticalScrollIndicator = false
        tickerTableView.isUserInteractionEnabled = true
        tickerTableView.allowsSelection = true
//        tickerTableView.delaysContentTouches = false
        tickerTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        tickerTableView.insetsContentViewsToSafeArea = true
        tickerTableView.translatesAutoresizingMaskIntoConstraints = false
        tickerContainer.addSubview(tickerTableView)
        
        tickerTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        tickerTableViewSpinner.startAnimating()
        tickerTableView.addSubview(tickerTableViewSpinner)
        tickerTableViewSpinner.isHidden = false
        
        messageContainer = UIView()
        messageContainer.backgroundColor = Settings.Theme.Color.background
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(messageContainer)
        
        messageTableView = UITableView()
        messageTableView.dataSource = self
        messageTableView.delegate = self
//        messageTableView.refreshControl = messageTableViewRefreshControl
        messageTableView.dragInteractionEnabled = true
        messageTableView.register(MessageCellGandalf.self, forCellReuseIdentifier: messageTableCellIdentifier)
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = .clear
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = UITableView.automaticDimension
//        messageTableView.estimatedRowHeight = 0
        messageTableView.estimatedSectionHeaderHeight = 0
        messageTableView.estimatedSectionFooterHeight = 0
        messageTableView.isScrollEnabled = true
        messageTableView.bounces = true
        messageTableView.alwaysBounceVertical = true
        messageTableView.showsVerticalScrollIndicator = false
        messageTableView.isUserInteractionEnabled = true
        messageTableView.allowsSelection = true
//        messageTableView.delaysContentTouches = false
        messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0)
//        messageTableView.insetsContentViewsToSafeArea = true
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(messageTableView)
        
        messageTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        messageTableViewSpinner.startAnimating()
        messageTableView.addSubview(messageTableViewSpinner)
        messageTableViewSpinner.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
//    @objc func messageTableRefresh(_ sender: Any) {
//        // Data is refreshed automatically - pause before dismissing the spinner to convey this to the user.
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//            self.messageTableViewRefreshControl.endRefreshing()
//        }
//    }
    
//    // MARK: -GROUP DELEGATE
//
//    func loadGroup(group: Group) {
//        guard let groupId = group.id else { return }
//
//        // Reset local data
//        currentGroup = group
//        localMessages.removeAll()
//        messageTableView.reloadData()
//        tickerTableView.reloadData()
//
//        // Set new data
//        messageRepository = MessageRepository(group: groupId)
//        self.barItemTitle.setTitle(group.title, for: .normal)
//    }
    
    
    // MARK: -KEYBOARD METHODS
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height - self.view.safeAreaLayoutGuide.layoutFrame.origin.y + 5
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
