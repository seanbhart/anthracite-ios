//
//  GroupView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/1/21.
//

import UIKit
import FirebaseAuth

class GroupView: UIViewController, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIGestureRecognizerDelegate, MessageRepositoryDelegate {
    let className = "GroupView"
    
    var initialLoad = true
    var allowEndEditing = false
    var localGroups = [Group]()
//    var groupRepository: GroupRepository!
    var localTickers = [Ticker]()
    var localMessages = [Message]()
    var messageRepository: MessageRepository!
    var accountNames = [String: String]()
    var inputTickers = [String]()
    
    var viewContainer: UIView!
    var headerLabel: UILabel!
    var inputContainer: UIView!
    let inputTableCellIdentifier: String = "InputCell"
    var inputTableView: UITableView!
    var accessoryView: UIView!
    var accessoryClearButton: UILabel!
    var accessorySendButton: UILabel!
    var tickerContainer: UIView!
    var messageContainer: UIView!
    let tickerTableCellIdentifier: String = "GroupTickerCell"
//    var tickerTableViewRefreshControl: UIRefreshControl!
    var tickerTableView: UITableView!
    var tickerTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let messageTableCellIdentifier: String = "MessageCell"
//    var messageTableViewRefreshControl: UIRefreshControl!
    var messageTableView: UITableView!
    var messageTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let messageCellHeight: CGFloat = 200
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        
        let barItemLogo = UIButton(type: .custom)
        barItemLogo.setImage(UIImage(named: Assets.Images.hatIconPurpleLg), for: .normal)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:30),
            barItemLogo.heightAnchor.constraint(equalToConstant:30),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            messageRepository.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            messageRepository.stopObserving()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            inputContainer.heightAnchor.constraint(equalToConstant: 100),
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
        
        if messageRepository != nil {
            messageRepository.observeQuery()
        }
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
        if messageRepository != nil {
            messageRepository.stopObserving()
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
        inputContainer.backgroundColor = Settings.Theme.Color.contentBackground
        inputContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(inputContainer)
        
        inputTableView = UITableView()
        inputTableView.dataSource = self
        inputTableView.delegate = self
        inputTableView.dragInteractionEnabled = false
        inputTableView.register(GroupInputCell.self, forCellReuseIdentifier: inputTableCellIdentifier)
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
        
//        accessoryView = UIView()
//        accessoryView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//        accessoryView.backgroundColor = Settings.Theme.Color.contentBackground
//        accessoryView.translatesAutoresizingMaskIntoConstraints = false
//        inputTextView.inputAccessoryView = accessoryView
        
        tickerContainer = UIView()
        tickerContainer.backgroundColor = Settings.Theme.Color.background
        tickerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tickerContainer)
        
        messageContainer = UIView()
        messageContainer.backgroundColor = Settings.Theme.Color.background
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(messageContainer)
        
        tickerTableView = UITableView()
        tickerTableView.dataSource = self
        tickerTableView.delegate = self
//        tickerTableView.refreshControl = tickerTableViewRefreshControl
        tickerTableView.dragInteractionEnabled = true
        tickerTableView.register(GroupTickerCell.self, forCellReuseIdentifier: tickerTableCellIdentifier)
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
        
        messageTableView = UITableView()
        messageTableView.dataSource = self
        messageTableView.delegate = self
//        messageTableView.refreshControl = messageTableViewRefreshControl
        messageTableView.dragInteractionEnabled = true
        messageTableView.register(MessageCell.self, forCellReuseIdentifier: messageTableCellIdentifier)
        messageTableView.separatorStyle = .none
        messageTableView.backgroundColor = .clear
//        messageTableView.rowHeight = UITableView.automaticDimension
//        messageTableView.estimatedRowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 0
        messageTableView.estimatedSectionHeaderHeight = 0
        messageTableView.estimatedSectionFooterHeight = 0
        messageTableView.isScrollEnabled = true
        messageTableView.bounces = true
        messageTableView.alwaysBounceVertical = true
        messageTableView.showsVerticalScrollIndicator = false
        messageTableView.isUserInteractionEnabled = true
        messageTableView.allowsSelection = true
//        messageTableView.delaysContentTouches = false
        messageTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        messageTableView.insetsContentViewsToSafeArea = true
        messageTableView.translatesAutoresizingMaskIntoConstraints = false
        messageContainer.addSubview(messageTableView)
        
        messageTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        messageTableViewSpinner.startAnimating()
        messageTableView.addSubview(messageTableViewSpinner)
        messageTableViewSpinner.isHidden = false
        
        getGroups()
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
    
    
    // MARK: -GESTURE RECOGNIZERS

    @objc func loadGroupsView(_ sender: UITapGestureRecognizer) {
        print("\(className) - loadGroupsView")
//        self.presentSheet(with: GroupsView())
    }
    @objc func viewContainerTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - viewContainerTap")
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell {
            allowEndEditing = true
            cell.textView.endEditing(true)
            allowEndEditing = false
        }
    }
    
    // Ensure a tap to a cell falls through to the cell and not caught by the view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var tapPoint = touch.location(in: messageTableView)
        var indexPath = messageTableView.indexPathForRow(at: tapPoint)
        if indexPath != nil {
            return false
        }
        tapPoint = touch.location(in: tickerTableView)
        indexPath = tickerTableView.indexPathForRow(at: tapPoint)
        if indexPath != nil {
            return false
        }
        return true
    }
    
    
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
    
    
    // MARK: -TEXTVIEW METHODS
    
    func textViewDidChange(_ textView: UITextView) {
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell {
            if textView == cell.textView {
                if textView.text == "" {
                    cell.placeholder.text = "New Message"
                } else {
                    cell.placeholder.text = ""
                    textView.textColor = Settings.Theme.Color.text
                    // formatInputText returns a tuple with the formatted text and a list of found ticker strings
                    let result = formatInputText(text: String(textView.text.prefix(200)), textColor: Settings.Theme.Color.barText)
                    textView.attributedText = result.0
                    inputTickers = result.1
//                    print(inputTickers)
                }
            }
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        print("\(className) - textViewShouldEndEditing")
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell {
            if textView == cell.textView {
                return allowEndEditing
            }
        }
        return true
    }
    
    
    // MARK: -TABLEVIEW DATA SOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == inputTableView {
            return 1
            
        } else if tableView == messageTableView {
            if localMessages.count > 0 {
                messageTableViewSpinner.stopAnimating()
            } else if !initialLoad {
                messageTableViewSpinner.startAnimating()
            }
            return localMessages.count
            
        } else if tableView == tickerTableView {
            if localTickers.count > 0 {
                tickerTableViewSpinner.stopAnimating()
            } else if !initialLoad {
                tickerTableViewSpinner.startAnimating()
            }
            return localTickers.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        if tableView == inputTableView {
            return 100
            
        } else if tableView == messageTableView {
            return messageCellHeight
            
        } else if tableView == tickerTableView {
            return 130
        }
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == inputTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: inputTableCellIdentifier, for: indexPath) as! GroupInputCell
            cell.selectionStyle = .none
            cell.textView.delegate = self
            
            return cell
            
        } else if tableView == messageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellIdentifier, for: indexPath) as! MessageCell
            cell.selectionStyle = .none

            let message = localMessages[indexPath.row]
            cell.textView.attributedText = formatMessageText(text: message.text, textColor: Settings.Theme.Color.barText)
            
            cell.title.text = "loading..."
            for a in accountNames {
                if a.key == localMessages[indexPath.row].account {
                    cell.title.text = a.value
                    break
                }
            }
            
            cell.timeLabel.text = Settings.formatDateString(timestamp: localMessages[indexPath.row].timestamp)
            return cell
            
        } else if tableView == tickerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: tickerTableCellIdentifier, for: indexPath) as! GroupTickerCell
            cell.selectionStyle = .none
            let cellTicker = localTickers[indexPath.row]
            if let t = cellTicker.ticker {
                cell.title.text = "$" + t
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let formattedSum = numberFormatter.string(from: NSNumber(value: cellTicker.responseCount))
                cell.countText.text = formattedSum
                
//                if cellTicker.wAvgSentiment >= 0 {
//                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconPosLg)
//                } else {
//                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconNegLg)
//                }
            }
            if cellTicker.selected {
                cell.containerView.backgroundColor = Settings.Theme.Color.selected
            } else {
                cell.containerView.backgroundColor = Settings.Theme.Color.contentBackground
            }
            
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell {
            allowEndEditing = true
            cell.textView.endEditing(true)
            allowEndEditing = false
        }
        
        if tableView == messageTableView {
            print("MESSAGE ROW \(indexPath.row)")
            
        } else if tableView == tickerTableView {
            print("TICKER ROW \(indexPath.row)")
            if localTickers[indexPath.row].selected {
                localTickers[indexPath.row].selected = false
            } else {
                localTickers[indexPath.row].selected = true
            }
            fillLocalMessages()
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != inputTableView { return nil }
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell else { return nil }
        let positive = UIContextualAction(style: .normal, title: "SEND") { (action, view, completionHandler) in
            print("SEND MESSAGE: \(indexPath.row)")
            self.messageRepository.createMessage(text: cell.textView.text, tickers: self.inputTickers)
            cell.textView.text = ""
            cell.placeholder.text = "New Message"
            cell.endEditing(true)
            self.inputTickers.removeAll()
            
            if let cell = self.inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell {
                self.allowEndEditing = true
                cell.textView.endEditing(true)
                self.allowEndEditing = false
            }
            completionHandler(true)
        }
        positive.backgroundColor = Settings.Theme.Color.barText
        return UISwipeActionsConfiguration(actions: [positive])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == inputTableView {
            guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? GroupInputCell else { return nil }
            let negative = UIContextualAction(style: .normal, title: "CLEAR") { (action, view, completionHandler) in
                print("CLEAR MESSAGE: \(indexPath.row)")
                cell.textView.text = ""
                cell.placeholder.text = "New Message"
                cell.endEditing(true)
                self.inputTickers.removeAll()
                completionHandler(true)
            }
            negative.backgroundColor = Settings.Theme.Color.negative
            return UISwipeActionsConfiguration(actions: [negative])
            
        } else if tableView == messageTableView {
            guard let firUser = Auth.auth().currentUser else { return nil }
            if localMessages[indexPath.row].account != firUser.uid { return nil }
            let negative = UIContextualAction(style: .normal, title: "DELETE") { (action, view, completionHandler) in
                print("DELETE MESSAGE: \(indexPath.row)")
                self.messageRepository.deleteMessage(id: self.localMessages[indexPath.row].id)
                completionHandler(true)
            }
            negative.backgroundColor = Settings.Theme.Color.negative
            return UISwipeActionsConfiguration(actions: [negative])
        }
        return nil
    }
    

    // MARK: -SCROLL VIEW DELEGATE METHODS

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tickerTableView {
//            print("tickerTableView OFFSET: \(tickerTableView.contentOffset), SIZE: \(tickerTableView.contentSize), FRAME: \(tickerTableView.frame.size)")
//            print(tickerTableView.contentOffset.y - (tickerTableView.contentSize.height - tickerTableView.frame.size.height))
            if tickerTableView.contentOffset.y - (tickerTableView.contentSize.height - tickerTableView.frame.size.height) > 70 {
                clearTickerFilter()
            }
        }
    }
    
    
    // MARK: -CUTSTOM FUNCTIONS
    
    func noMessagesSetup() {
        print("noMessagesSetup 1")
        viewContainer.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
        // Reload the tables in case there was data and then deleted
        localTickers.removeAll()
        localMessages.removeAll()
        messageTableView.reloadData()
        tickerTableView.reloadData()
        tickerTableViewSpinner.stopAnimating()
        messageTableViewSpinner.stopAnimating()
    }
    func messagesSetup() {
        headerLabel.removeFromSuperview()
    }
    
    
    // MARK: -REPO METHODS
    
    func getLocalTickers() -> [Ticker] {
        return localTickers
    }
    func messageDataUpdate() {
        if messageRepository.messages.count < 1 {
            noMessagesSetup()
            return
        } else {
            messagesSetup()
        }
        
        // Switch out the local data with newly synced data
        // Handle tickers first to prep for filling notion list
        localTickers.removeAll()
        localTickers = messageRepository.tickers.sorted(by: { $0.responseCount < $1.responseCount })
        
        fillLocalMessages()
        accountNames = messageRepository.accountNames
        
        let bottomDist = messageTableView.contentSize.height - messageTableView.contentOffset.y - messageTableView.frame.height
        if initialLoad || bottomDist < messageCellHeight * 2 {
            if localMessages.count > 0 {
                messageTableView.scrollToRow(at: IndexPath(row: localMessages.count-1, section: 0), at: .top, animated: true)
            }
            if localTickers.count > 0 {
                tickerTableView.scrollToRow(at: IndexPath(row: localTickers.count-1, section: 0), at: .top, animated: true)
            }
            initialLoad = false
        }
    }
    
    
    // MARK: -DATA FUNCTIONS
    
    func clearTickerFilter() {
        // Set all tickers to not selected
        for i in localTickers.indices {
            localTickers[i].selected = false
        }
        if localTickers.count > 0 {
            tickerTableView.scrollToRow(at: IndexPath(row: localTickers.count-1, section: 0), at: .top, animated: true)
        }
        
        // Now refill the Message list
        fillLocalMessages()
    }
    func fillLocalMessages() {
        localMessages.removeAll()
        // Filter the data based on ticker selection ONLY IF ANY ARE SELECTED
        if localTickers.filter({ $0.selected }).count > 0 {
            localMessages = messageRepository.messages.filter({
                let tickers = $0.tickers
                return localTickers.filter({ tickers?.contains($0.ticker) ?? false && $0.selected }).count > 0
            })
        } else {
            localMessages = messageRepository.messages
        }
        localMessages = localMessages.sorted(by: { $0.timestamp < $1.timestamp })
        messageTableView.reloadData()
        if localMessages.count > 0 {
            messageTableView.scrollToRow(at: IndexPath(row: localMessages.count-1, section: 0), at: .top, animated: true)
        }
        tickerTableView.reloadData()
    }
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func formatInputText(text: String, textColor: UIColor) -> (NSMutableAttributedString, [String]) {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 30
        let string: NSMutableAttributedString = NSMutableAttributedString(string: String(text.prefix(200)), attributes: [ //String(text.prefix(140))
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.regular, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.paragraphStyle : style
        ])
        var words: [String] = text.components(separatedBy: " ")
        var tickers = [String]()
        for i in words.indices {
            words[i] = words[i].trimmingCharacters(in: .punctuationCharacters)
            if words[i].hasPrefix("$") {
                tickers.append(String(words[i].dropFirst().uppercased()))
                let range: NSRange = (string.string as NSString).range(of: words[i])
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
                string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Assets.Fonts.Default.black, size: 24) ?? UIFont.boldSystemFont(ofSize: 24), range: range)
                string.replaceCharacters(in: range, with: words[i].uppercased())
            }
        }
        return (string, tickers)
    }
    func formatMessageText(text: String, textColor: UIColor) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        let string: NSMutableAttributedString = NSMutableAttributedString(string: text, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.regular, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.paragraphStyle : style
        ])
        var words: [String] = text.components(separatedBy: " ")
        for i in words.indices {
            words[i] = words[i].trimmingCharacters(in: .punctuationCharacters)
            if words[i].hasPrefix("$") {
                let range: NSRange = (string.string as NSString).range(of: words[i])
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
                string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Assets.Fonts.Default.black, size: 20) ?? UIFont.boldSystemFont(ofSize: 20), range: range)
                string.replaceCharacters(in: range, with: words[i].uppercased())
            }
        }
        return string
    }
    
    
    // MARK: -FIRESTORE FUNCTIONS
    
    func getGroups() {
        print("\(className) - getGroups")
        guard let firUser = Auth.auth().currentUser else { return }
        Settings.Firebase.db().collection("group")
            .whereField("members", arrayContains: firUser.uid)
            .getDocuments(completion: { (snapshot, error) in
                if let err = error { print("\(self.className) - getGroups ERROR: \(err)") }
                guard let snapshot = snapshot else { print("\(self.className) getGroups snapshot error: \(error!)"); return }
                
                self.localGroups = snapshot.documents.compactMap { queryDocumentSnapshot -> Group? in
                    return try? queryDocumentSnapshot.data(as: Group.self)
                }
                // TODO: populate group menu with all groups
                if self.localGroups.count > 0 {
                    guard let groupId = self.localGroups[0].id else { return }
                    self.messageRepository = MessageRepository(group: groupId)
                    self.messageRepository.delegate = self
                    self.messageRepository.observeQuery()
                    
                    self.navigationItem.title = self.localGroups[0].title
                }
            })
    }
}
