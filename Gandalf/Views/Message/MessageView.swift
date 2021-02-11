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
    var accountImages = [String: UIImage]()
    var inputTickers = [MessageTicker]()
    var inputTickerStrings = [String]()
    
    var viewContainer: UIView!
    var headerLabel: UILabel!
    var inputContainer: UIView!
    var inputContainerHeightConstraint: NSLayoutConstraint?
//    let inputTableCellIdentifier: String = "InputCell"
//    var inputTableView: UITableView!
    var inputDollarSignContainer: UIView!
    var inputDollarSign: UILabel!
    var inputPlaceholder: UILabel!
    var inputTextViewContainer: UIView!
    var inputTextView: UITextView!
    var inputSend: UIImageView!
    var accessoryView: UIView!
    var accessoryViewBorder: UIView!
    var inputTickerContainer: UIScrollView!
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
        ])
        inputContainerHeightConstraint = NSLayoutConstraint(item: inputContainer, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 50)
        inputContainer.addConstraint(inputContainerHeightConstraint!)
//        NSLayoutConstraint.activate([
//            inputTableView.topAnchor.constraint(equalTo:inputContainer.topAnchor, constant: 0),
//            inputTableView.leftAnchor.constraint(equalTo:inputContainer.leftAnchor, constant: 0),
//            inputTableView.rightAnchor.constraint(equalTo:inputContainer.rightAnchor, constant: 0),
//            inputTableView.bottomAnchor.constraint(equalTo:inputContainer.bottomAnchor, constant: 0),
//        ])
        NSLayoutConstraint.activate([
            inputDollarSignContainer.topAnchor.constraint(equalTo:inputContainer.topAnchor),
            inputDollarSignContainer.bottomAnchor.constraint(equalTo:inputContainer.bottomAnchor),
            inputDollarSignContainer.leftAnchor.constraint(equalTo:inputContainer.leftAnchor),
            inputDollarSignContainer.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            inputDollarSign.topAnchor.constraint(equalTo:inputDollarSignContainer.topAnchor, constant: 5),
            inputDollarSign.bottomAnchor.constraint(equalTo:inputDollarSignContainer.bottomAnchor, constant: -5),
            inputDollarSign.leftAnchor.constraint(equalTo:inputDollarSignContainer.leftAnchor, constant: 10),
            inputDollarSign.rightAnchor.constraint(equalTo:inputDollarSignContainer.rightAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            inputPlaceholder.topAnchor.constraint(equalTo:inputContainer.topAnchor, constant: 10),
            inputPlaceholder.leftAnchor.constraint(equalTo:inputContainer.leftAnchor, constant: 105),
            inputPlaceholder.rightAnchor.constraint(equalTo:inputContainer.rightAnchor, constant: -10),
            inputPlaceholder.heightAnchor.constraint(equalToConstant: 20)
        ])
        NSLayoutConstraint.activate([
            inputTextViewContainer.topAnchor.constraint(equalTo:inputContainer.topAnchor, constant: 5),
            inputTextViewContainer.bottomAnchor.constraint(equalTo:inputContainer.bottomAnchor, constant: -5),
            inputTextViewContainer.leftAnchor.constraint(equalTo:inputContainer.leftAnchor, constant: 100),
            inputTextViewContainer.rightAnchor.constraint(equalTo:inputContainer.rightAnchor, constant: -5),
        ])
        NSLayoutConstraint.activate([
            inputTextView.topAnchor.constraint(equalTo:inputTextViewContainer.topAnchor, constant: 0),
            inputTextView.bottomAnchor.constraint(equalTo:inputTextViewContainer.bottomAnchor, constant: 0),
            inputTextView.leftAnchor.constraint(equalTo:inputTextViewContainer.leftAnchor, constant: 0),
            inputTextView.rightAnchor.constraint(equalTo:inputTextViewContainer.rightAnchor, constant: -50),
        ])
        NSLayoutConstraint.activate([
            inputSend.bottomAnchor.constraint(equalTo:inputTextViewContainer.bottomAnchor, constant: 0),
            inputSend.rightAnchor.constraint(equalTo:inputTextViewContainer.rightAnchor, constant: 0),
            inputSend.widthAnchor.constraint(equalToConstant: 40),
            inputSend.heightAnchor.constraint(equalToConstant: 40),
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
        // Show the tutorial if it has not been viewed by the current user
//        if let accountRepo = AccountRepository() {
//            accountRepo.getAccount()
//            guard let account = accountRepo.account else { self.showTutorial(); return }
//            guard let metadata = account.metadata else { self.showTutorial(); return }
//            guard let tutorials = metadata.tutorials else { self.showTutorial(); return }
//            if (tutorials.firstIndex(of: accountRepo.currentTutorial + "-" + className) == nil) {
//                self.showTutorial()
//            }
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
        
        inputDollarSignContainer = UIView()
        inputDollarSignContainer.backgroundColor = Settings.Theme.Color.background
        inputDollarSignContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputDollarSignContainer)
        
        let inputDollarSignGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(dollarSignTap))
        inputDollarSignGestureRecognizer.delegate = self
        inputDollarSignGestureRecognizer.numberOfTapsRequired = 1
        inputDollarSignContainer.addGestureRecognizer(inputDollarSignGestureRecognizer)
        
        inputDollarSign = UILabel()
        inputDollarSign.backgroundColor = Settings.Theme.Color.background
        inputDollarSign.font = UIFont(name: Assets.Fonts.Default.bold, size: 30)
        inputDollarSign.textColor = Settings.Theme.Color.primary
        inputDollarSign.textAlignment = NSTextAlignment.center
        inputDollarSign.numberOfLines = 1
        inputDollarSign.text = "$"
        inputDollarSign.isUserInteractionEnabled = false
        inputDollarSign.translatesAutoresizingMaskIntoConstraints = false
        inputDollarSignContainer.addSubview(inputDollarSign)
        
        inputPlaceholder = UILabel()
        inputPlaceholder.backgroundColor = .clear
        inputPlaceholder.font = UIFont(name: Assets.Fonts.Default.medium, size: 16)
        inputPlaceholder.textColor = Settings.Theme.Color.textGrayDark
        inputPlaceholder.textAlignment = NSTextAlignment.left
        inputPlaceholder.numberOfLines = 1
        inputPlaceholder.text = "New Message"
        inputPlaceholder.isUserInteractionEnabled = false
        inputPlaceholder.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputPlaceholder)
        
        accessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        accessoryView.backgroundColor = Settings.Theme.Color.contentBackground
        accessoryView.translatesAutoresizingMaskIntoConstraints = false
        
        accessoryViewBorder = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1))
        accessoryViewBorder.layer.borderColor = Settings.Theme.Color.textGrayDark.cgColor
        accessoryViewBorder.layer.borderWidth = 1
        accessoryViewBorder.translatesAutoresizingMaskIntoConstraints = false
//        accessoryView.addSubview(accessoryViewBorder)
        
        inputTextViewContainer = UIView()
        inputTextViewContainer.backgroundColor = .clear
        inputTextViewContainer.layer.cornerRadius = 5
        inputTextViewContainer.layer.borderColor = Settings.Theme.Color.textGrayDark.cgColor
        inputTextViewContainer.layer.borderWidth = 1
        inputTextViewContainer.translatesAutoresizingMaskIntoConstraints = false
        inputContainer.addSubview(inputTextViewContainer)
        
        inputTextView = UITextView()
        inputTextView.delegate = self
        inputTextView.backgroundColor = .clear
        inputTextView.inputAccessoryView = accessoryView
        inputTextView.font = UIFont(name: Assets.Fonts.Default.regular, size: 16)
        inputTextView.textColor = Settings.Theme.Color.text
        inputTextView.textAlignment = NSTextAlignment.left
        inputTextView.text = ""
        inputTextView.keyboardDismissMode = .none
        inputTextView.keyboardAppearance = .dark
//        inputTextView.keyboardType = .twitter
        inputTextView.returnKeyType = .default
        inputTextView.isScrollEnabled = false
        inputTextView.isUserInteractionEnabled = true
        inputTextView.translatesAutoresizingMaskIntoConstraints = false
        inputTextViewContainer.addSubview(inputTextView)
        
        inputSend = UIImageView()
        inputSend.backgroundColor = .clear
        inputSend.image = UIImage(systemName: "arrow.up.square.fill")
        inputSend.tintColor = Settings.Theme.Color.primary
        inputSend.contentMode = UIView.ContentMode.scaleAspectFit
        inputSend.clipsToBounds = true
        inputSend.translatesAutoresizingMaskIntoConstraints = false
        inputTextViewContainer.addSubview(inputSend)
        
        inputTickerContainer = UIScrollView(frame: CGRect(x: 5, y: 5, width: view.frame.width - 10, height: 40))
        inputTickerContainer.layer.cornerRadius = 5
        inputTickerContainer.layer.borderColor = Settings.Theme.Color.textGrayDark.cgColor
        inputTickerContainer.layer.borderWidth = 1
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
