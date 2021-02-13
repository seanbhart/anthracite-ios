//
//  NotionView.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit
import Firebase
//import FirebaseAnalytics
import FirebaseAuth

class NotionView: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, NotionRepositoryDelegate, NotionActionRepositoryDelegate, AccountRepositoryDelegate, HoleViewDelegate {
    let className = "NotionView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var pageTitle = "Gandalf"
    var sortByResponse = true
    var allowUpdates = true
    var localTickers = [Ticker]()
    var localNotions = [Notion]()
    var notionRepository: NotionRepository!
    var notionActionRepository: NotionActionRepository!
    var accountRepository: AccountRepository!
    
    var viewContainer: UIView!
    var headerContainer: UIView!
    var tickerContainer: UIView!
    var tickerTableView: UITableView!
    var tickerTableViewRefreshControl: UIRefreshControl!
    var tickerTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let tickerTableCellIdentifier: String = "NotionTickerCell"
    var notionContainer: UIView!
    var notionTitle: UILabel!
    var notionCountLabel: UILabel!
    var notionIcon: UIImageView!
    var filterButton: UIView!
    var filterIcon: UIImageView!
    var progressViewContainer: UIView!
    var progressViewLeft: ProgressViewRoundedLeft!
    var progressViewRight: ProgressViewRoundedRight!
    var notionTableView: UITableView!
    var notionTableViewRefreshControl: UIRefreshControl!
    var notionTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let notionTableCellIdentifier: String = "NotionCell"
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        print("\(className) - preferredStatusBarStyle")
//        return .lightContent
//    }
    
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
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let notionRepo = notionRepository else { return }
            guard let notionActionRepo = notionActionRepository else { return }
            notionRepo.observeQuery()
            notionActionRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let notionRepo = notionRepository else { return }
            guard let notionActionRepo = notionActionRepository else { return }
            notionRepo.stopObserving()
            notionActionRepo.stopObserving()
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
            headerContainer.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            headerContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            headerContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            headerContainer.heightAnchor.constraint(equalToConstant: 120),
        ])
        NSLayoutConstraint.activate([
            progressViewContainer.bottomAnchor.constraint(equalTo:headerContainer.bottomAnchor, constant: 0),
            progressViewContainer.leftAnchor.constraint(equalTo:headerContainer.leftAnchor, constant: 0),
            progressViewContainer.rightAnchor.constraint(equalTo:headerContainer.rightAnchor, constant: 0),
            progressViewContainer.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            progressViewLeft.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 0),
            progressViewLeft.bottomAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 0),
            progressViewLeft.leftAnchor.constraint(equalTo:progressViewContainer.leftAnchor, constant: 0),
            progressViewLeft.rightAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            progressViewRight.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 0),
            progressViewRight.bottomAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 0),
            progressViewRight.leftAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
            progressViewRight.rightAnchor.constraint(equalTo:progressViewContainer.rightAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            filterButton.topAnchor.constraint(equalTo:headerContainer.topAnchor),
            filterButton.rightAnchor.constraint(equalTo:headerContainer.rightAnchor),
            filterButton.bottomAnchor.constraint(equalTo:progressViewContainer.topAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            filterIcon.topAnchor.constraint(equalTo:filterButton.topAnchor, constant: 20),
            filterIcon.bottomAnchor.constraint(equalTo:filterButton.bottomAnchor, constant: -20),
            filterIcon.rightAnchor.constraint(equalTo:filterButton.rightAnchor, constant: -20),
            filterIcon.leftAnchor.constraint(equalTo:filterButton.leftAnchor, constant: 20),
        ])
        NSLayoutConstraint.activate([
            notionContainer.topAnchor.constraint(equalTo:headerContainer.topAnchor, constant: 10),
            notionContainer.leftAnchor.constraint(equalTo:headerContainer.leftAnchor, constant: 10),
            notionContainer.bottomAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 0),
            notionContainer.rightAnchor.constraint(equalTo:filterButton.leftAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            notionTitle.topAnchor.constraint(equalTo:notionContainer.topAnchor, constant: 0),
            notionTitle.leftAnchor.constraint(equalTo:notionContainer.leftAnchor, constant: 10),
            notionTitle.rightAnchor.constraint(equalTo:filterButton.leftAnchor, constant: -10),
            notionTitle.heightAnchor.constraint(equalToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            notionIcon.topAnchor.constraint(equalTo:notionTitle.topAnchor, constant: 20),
            notionIcon.bottomAnchor.constraint(equalTo:notionContainer.bottomAnchor, constant: -5),
            notionIcon.leftAnchor.constraint(equalTo:notionContainer.leftAnchor, constant: 5),
            notionIcon.widthAnchor.constraint(equalToConstant: 40),
        ])
        NSLayoutConstraint.activate([
            notionCountLabel.topAnchor.constraint(equalTo:notionTitle.bottomAnchor, constant: 0),
            notionCountLabel.bottomAnchor.constraint(equalTo:notionContainer.bottomAnchor, constant: -10),
            notionCountLabel.leftAnchor.constraint(equalTo:notionIcon.rightAnchor, constant: 10),
            notionCountLabel.rightAnchor.constraint(equalTo:filterButton.leftAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            tickerContainer.topAnchor.constraint(equalTo:headerContainer.bottomAnchor),
            tickerContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            tickerContainer.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
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
            notionTableView.topAnchor.constraint(equalTo:headerContainer.bottomAnchor),
            notionTableView.leftAnchor.constraint(equalTo:tickerContainer.rightAnchor),
            notionTableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            notionTableView.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            notionTableViewSpinner.centerXAnchor.constraint(equalTo:notionTableView.centerXAnchor, constant: 0),
            notionTableViewSpinner.centerYAnchor.constraint(equalTo:notionTableView.centerYAnchor, constant: -100),
        ])
        
        if accountRepository == nil {
            if let accountRepo = AccountRepository() {
                accountRepository = accountRepo
                accountRepository.delegate = self
                accountRepository.getAccount()
            } else {
                if let parent = self.tabBarViewDelegate {
                    parent.moveToTab(index: Settings.Tabs.accountVcIndex)
                }
            }
        } else {
            accountRepository.getAccount()
        }
        if notionRepository == nil {
            notionRepository = NotionRepository(recency: 3600)
            notionRepository.delegate = self
        }
        notionRepository.observeQuery()
        if notionActionRepository == nil {
            notionActionRepository = NotionActionRepository(recency: 3600)
            notionActionRepository.delegate = self
        }
        notionActionRepository.observeQuery()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    
    // MARK: -ACCOUNT DELEGATE METHODS
    
    func accountDataUpdate() {
//        print("\(className) - accountDataUpdate")
        // Show the tutorial if it has not been viewed by the current user
        guard let account = accountRepository.account else { self.showTutorial(); return }
        guard let metadata = account.metadata else { self.showTutorial(); return }
        guard let tutorials = metadata.tutorials else { self.showTutorial(); return }
        if (tutorials.firstIndex(of: Settings.currentTutorial + "-" + className) == nil) {
            self.showTutorial()
        }
    }
    
    func requestError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func notSignedIn() {
        // Move the user to the Account View to try logging in again
        if let parent = self.tabBarViewDelegate {
            parent.moveToTab(index: Settings.Tabs.accountVcIndex)
        }
    }
    
    
    func showTutorial() {
        let holeView = HoleView(holeViewPosition: 1, frame: viewContainer.bounds, circleOffsetX: 0, circleOffsetY: 0, circleRadius: 0, textOffsetX: (viewContainer.bounds.width / 2) - 160, textOffsetY: 60, textWidth: 320, textFontSize: 32, text: "Welcome to Gandalf!\n\nGandalf is an investment information app detecting public sentiment regarding tradeable assets to predict future prices.")
        holeView.holeViewDelegate = self
        viewContainer.addSubview(holeView)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        guard let notionRepo = notionRepository else { return }
        guard let notionActionRepo = notionActionRepository else { return }
        notionRepo.stopObserving()
        notionActionRepo.stopObserving()
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
        
        headerContainer = UIView()
        headerContainer.backgroundColor = Settings.Theme.Color.header
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(headerContainer)
        
        let headerContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(scrollTop))
        headerContainerGestureRecognizer.numberOfTapsRequired = 1
        headerContainer.addGestureRecognizer(headerContainerGestureRecognizer)
        
        notionContainer = UIView()
        notionContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(notionContainer)
        
        notionTitle = UILabel()
        notionTitle.font = UIFont(name: Assets.Fonts.Default.black, size: 14)
        notionTitle.textColor = Settings.Theme.Color.text
        notionTitle.textAlignment = NSTextAlignment.left
        notionTitle.numberOfLines = 1
        notionTitle.text = "LAST HOUR"
        notionTitle.isUserInteractionEnabled = false
        notionTitle.translatesAutoresizingMaskIntoConstraints = false
        notionContainer.addSubview(notionTitle)
        
        notionIcon = UIImageView()
        notionIcon.image = UIImage(named: Assets.Images.notionIconWhiteLg)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        notionContainer.addSubview(notionIcon)
        
        notionCountLabel = UILabel()
        notionCountLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 50)
        notionCountLabel.textColor = Settings.Theme.Color.text
        notionCountLabel.textAlignment = NSTextAlignment.left
        notionCountLabel.numberOfLines = 1
        notionCountLabel.text = ""
        notionCountLabel.isUserInteractionEnabled = false
        notionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        notionContainer.addSubview(notionCountLabel)
        
        filterButton = UIView()
        filterButton.isUserInteractionEnabled = true
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(filterButton)
        
        let filterButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(filterToggle))
        filterButtonGestureRecognizer.numberOfTapsRequired = 1
        filterButton.addGestureRecognizer(filterButtonGestureRecognizer)
        
        filterIcon = UIImageView()
        filterIcon.image = UIImage(named: Assets.Images.topIconPurpleLg)
        filterIcon.contentMode = UIView.ContentMode.scaleAspectFit
        filterIcon.clipsToBounds = true
        filterIcon.translatesAutoresizingMaskIntoConstraints = false
        filterButton.addSubview(filterIcon)
        
        progressViewContainer = UIView()
//        progressViewContainer.backgroundColor = .red //Settings.Theme.colorPrimary //.withAlphaComponent(0.5)
        progressViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(progressViewContainer)
        
        progressViewLeft = ProgressViewRoundedLeft()
        progressViewLeft.progressViewStyle = .bar
        progressViewLeft.trackTintColor = .clear
        progressViewLeft.progressTintColor = Settings.Theme.Color.progressbar
        progressViewLeft.progress = 1
        progressViewLeft.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewLeft)
        
        progressViewRight = ProgressViewRoundedRight()
        progressViewRight.progressViewStyle = .bar
        progressViewRight.trackTintColor = Settings.Theme.Color.progressbar
        progressViewRight.progressTintColor = .clear
        progressViewRight.progress = 0
        progressViewRight.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewRight)
        
        tickerContainer = UIView()
        tickerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tickerContainer)
        
        tickerTableViewRefreshControl = UIRefreshControl()
        tickerTableViewRefreshControl.tintColor = .clear
        tickerTableViewRefreshControl.addTarget(self, action: #selector(tickerClear), for: .valueChanged)
        
        tickerTableView = UITableView()
        tickerTableView.dataSource = self
        tickerTableView.delegate = self
        tickerTableView.refreshControl = tickerTableViewRefreshControl
        tickerTableView.dragInteractionEnabled = true
        tickerTableView.register(NotionTickerCell.self, forCellReuseIdentifier: tickerTableCellIdentifier)
        tickerTableView.separatorStyle = .none
        tickerTableView.backgroundColor = .clear
//        tickerTableView.rowHeight = UITableView.automaticDimension
//        tickerTableView.estimatedRowHeight = UITableView.automaticDimension
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
        tickerTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tickerTableView.insetsContentViewsToSafeArea = true
        tickerTableView.translatesAutoresizingMaskIntoConstraints = false
        tickerContainer.addSubview(tickerTableView)
        
        tickerTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        tickerTableViewSpinner.startAnimating()
        tickerTableView.addSubview(tickerTableViewSpinner)
        tickerTableViewSpinner.isHidden = false
        
        notionTableViewRefreshControl = UIRefreshControl()
        notionTableViewRefreshControl.tintColor = Settings.Theme.Color.text
        notionTableViewRefreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        notionTableView = UITableView()
        notionTableView.dataSource = self
        notionTableView.delegate = self
        notionTableView.refreshControl = notionTableViewRefreshControl
        notionTableView.dragInteractionEnabled = true
        notionTableView.register(NotionCell.self, forCellReuseIdentifier: notionTableCellIdentifier)
        notionTableView.separatorStyle = .none
        notionTableView.backgroundColor = .clear
        notionTableView.isSpringLoaded = true
        notionTableView.rowHeight = UITableView.automaticDimension
        notionTableView.estimatedRowHeight = UITableView.automaticDimension
//        notionTableView.estimatedRowHeight = 0
        notionTableView.estimatedSectionHeaderHeight = 0
        notionTableView.estimatedSectionFooterHeight = 0
        notionTableView.isScrollEnabled = true
        notionTableView.bounces = true
        notionTableView.alwaysBounceVertical = true
        notionTableView.showsVerticalScrollIndicator = false
        notionTableView.isUserInteractionEnabled = true
        notionTableView.allowsSelection = true
//        notionTableView.delaysContentTouches = false
        notionTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        notionTableView.insetsContentViewsToSafeArea = true
        notionTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(notionTableView)
        
        notionTableViewSpinner.translatesAutoresizingMaskIntoConstraints = false
        notionTableViewSpinner.startAnimating()
        notionTableView.addSubview(notionTableViewSpinner)
        notionTableViewSpinner.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -CUSTOM DELEGATE METHODS
    
    func showLogin() {
//        self.presentSheet(with: AccountView())
        // TODO: toggle the Account tab
    }
    func notionDataUpdate() {
        if allowUpdates {
            updateDataLists()
        }
    }
    func notionActionDataUpdate() {
        fillNotionActions()
    }
    func getLocalTickers() -> [Ticker] {
        return localTickers
    }
    
    // Returned Set is ProgressBar values: Left, Right
    func progressValues(sentiment: Float, magnitude: Float) -> Set<Float> {
        if sentiment > 0 {
            return Set(arrayLiteral: 0, sentiment)
        } else if sentiment < 0 {
            return Set(arrayLiteral: 0 - abs(sentiment), 0)
        } else {
            return Set(arrayLiteral: 0, 1)
        }
    }
    
    // MARK: -GESTURE RECOGNIZERS
    
//    @objc func loadAccountView(_ sender: UITapGestureRecognizer) {
//        print("\(className) - loadAccountView")
//        self.presentSheet(with: AccountView())
//    }
    @objc func filterToggle(_ sender: UITapGestureRecognizer) {
        print("\(className) - filterToggle")
        if !sortByResponse {
            // Turn on the filter
            sortByResponse = true
            filterIcon.image = UIImage(named: Assets.Images.topIconPurpleLg)
        } else {
            sortByResponse = false
            filterIcon.image = UIImage(named: Assets.Images.topIconWhiteLg)
        }
        sortToggle()
    }
    @objc func scrollTop(_ sender: UITapGestureRecognizer) {
        print("\(className) - scrollTop")
        notionTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    @objc func tickerClear(_ sender: UITapGestureRecognizer) {
        print("\(className) - tickerClear")
        clearTickerFilter()
        self.tickerTableViewRefreshControl.endRefreshing()
    }
    
    
    // MARK: -TABLE VIEW DATA SOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == notionTableView {
            if localNotions.count > 0 {
//                notionTableViewEmptyNote.isHidden = true
                notionTableViewSpinner.stopAnimating()
            } else if Settings.Firebase.auth().currentUser == nil {
//                notionTableViewEmptyNote.isHidden = false
                notionTableViewSpinner.stopAnimating()
                tickerTableViewSpinner.stopAnimating()
            } else {
                notionTableViewSpinner.startAnimating()
            }
//            print("row count: \(localNotions.count)")
            return localNotions.count
            
        } else if tableView == tickerTableView {
            if localTickers.count > 0 {
                tickerTableViewSpinner.stopAnimating()
            } else {
                tickerTableViewSpinner.startAnimating()
            }
            return localTickers.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        if tableView == notionTableView {
            return UITableView.automaticDimension //250
            
        } else if tableView == tickerTableView {
            return 130
        }
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == notionTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: notionTableCellIdentifier, for: indexPath) as! NotionCell
            cell.selectionStyle = .none
            
            let notion = localNotions[indexPath.row]
            cell.id = notion.id
            cell.textView.text = notion.text //String(notion.sentiment) + ", " + String(notion.magnitude)
            
            // Get the Notion actions and set the action indicator
            // and adjust the sentiment by however many actions were taken
            cell.clearTrianges()
            if let sAction = notion.sentimentAction {
                if sAction.quantity < 0 {
                    cell.insertTriangleNegative()
                } else if sAction.quantity > 0 {
                    cell.insertTrianglePositive()
                }
            }
            
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedSum = numberFormatter.string(from: NSNumber(value: notion.responseCount))
            cell.notionCountLabel.text = formattedSum
            
            if notion.tickers.count > 0 {
                let sortedTickers = Array(Set(notion.tickers.sorted(by: { $0 < $1 })))
                var titleText = "$" + sortedTickers[0]
                for i in 1..<sortedTickers.count {
                    titleText += ", $" + sortedTickers[i]
                }
                cell.titleLabel.text = titleText
            }
            if notion.categories.count > 0 {
                let sortedCategories = notion.categories.sorted(by: { $0 < $1 })
                var textTitle = sortedCategories[0]
                for i in 1..<sortedCategories.count {
                    textTitle += ", " + sortedCategories[i]
                }
                cell.textTitle.text = textTitle
            } else {
                cell.textTitle.text = notion.host
            }
            
            let format = DateFormatter()
            format.timeZone = .current
            format.dateFormat = "h:mm a"
            format.amSymbol = "AM"
            format.pmSymbol = "PM"
            let dateString = format.string(from: Date(timeIntervalSince1970: Double(notion.created)))
            cell.ageLabel.text = dateString
            
            if notion.sentiment > 0 {
                cell.progressViewLeft.progress = 1
                cell.progressViewRight.progress = notion.sentiment
            } else if notion.sentiment < 0 {
                cell.progressViewLeft.progress = 1 - abs(notion.sentiment)
                cell.progressViewRight.progress = 0
            } else {
                cell.progressViewLeft.progress = 0
                cell.progressViewRight.progress = 1
            }
            
            if notion.magnitude > 1 {
                cell.progressViewLeft.trackTintColor = Settings.Theme.Color.negative
                cell.progressViewRight.progressTintColor = Settings.Theme.Color.positive
            } else if notion.magnitude > 0.1 {
                cell.progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.Color.negativeLight, color2: Settings.Theme.Color.negative, percent: Double(notion.magnitude))
                cell.progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.Color.positiveLight, color2: Settings.Theme.Color.positive, percent: Double(notion.magnitude))
            } else {
                cell.progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.Color.negativeLight, color2: Settings.Theme.Color.negative, percent: 0.1)
                cell.progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.Color.positiveLight, color2: Settings.Theme.Color.positive, percent: 0.1)
            }
            
            return cell
            
        } else if tableView == tickerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: tickerTableCellIdentifier, for: indexPath) as! NotionTickerCell
            cell.selectionStyle = .none
//            if indexPath.row == 0 {
//                cell.containerBorder.layer.borderColor = UIColor.clear.cgColor
//            }
            let cellTicker = localTickers[indexPath.row]
            if let t = cellTicker.ticker {
                cell.title.text = "$" + t
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let formattedSum = numberFormatter.string(from: NSNumber(value: cellTicker.responseCount))
                cell.countText.text = formattedSum
                
                if cellTicker.wAvgSentiment >= 0 {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconPosLg)
                } else {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconNegLg)
                }
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
        if tableView == notionTableView {
//            print("NOTION ROW \(indexPath.row)")
            
        } else if tableView == tickerTableView {
//            print("TICKER ROW \(indexPath.row)")
            if localTickers[indexPath.row].selected {
                localTickers[indexPath.row].selected = false
            } else {
                localTickers[indexPath.row].selected = true
//                print("TICKER - WAVG SENTIMENT: \(localTickers[indexPath.row].wAvgSentiment), MAGNITUDE: \(localTickers[indexPath.row].wAvgMagnitude)")
            }
            fillLocalNotions()
        }
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        allowUpdates = false
    }
    
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        allowUpdates = true
        notionDataUpdate()
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != notionTableView { return nil }
        let positive = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            print("MOVE POSITIVE: \(indexPath.row)")
            let notion = self.localNotions[indexPath.row]
            guard let notionId = notion.id else { return }
            // Ensure the previous sentiment is not equal to or more than 1 or less than -1
            if abs(notion.sentiment) < 1 {
                self.notionActionRepository.addSentimentAction(notion: notionId, quantity: 1)
//                self.fillNotionActions()
            }
            completionHandler(true)
        }
        positive.backgroundColor = Settings.Theme.Color.positive
        return UISwipeActionsConfiguration(actions: [positive])
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != notionTableView { return nil }
        let negative = UIContextualAction(style: .normal, title: "") { (action, view, completionHandler) in
            print("MOVE NEGATIVE: \(indexPath.row)")
            let notion = self.localNotions[indexPath.row]
            guard let notionId = notion.id else { return }
            // Ensure the previous sentiment is not equal to or more than 1 or less than -1
            if abs(notion.sentiment) < 1 {
                self.notionActionRepository.addSentimentAction(notion: notionId, quantity: -1)
//                self.fillNotionActions()
            }
            completionHandler(true)
        }
        negative.backgroundColor = Settings.Theme.Color.negative
        return UISwipeActionsConfiguration(actions: [negative])
    }
    

    // MARK: -SCROLL VIEW DELEGATE METHODS

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if scrollView == notionTableView {
//            print("notionTableView OFFSET: \(notionTableView.contentOffset), SIZE: \(notionTableView.contentSize)")
//        } else if scrollView == tickerTableView {
//            print("tickerTableView OFFSET: \(notionTableView.contentOffset), SIZE: \(notionTableView.contentSize)")
//        }
    }
    
    
    // MARK: -REFRESH CONTROL
    
    @objc private func refreshTableData(_ sender: Any) {
        // Data is refreshed automatically - pause before dismissing the spinner to convey this to the user.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.notionTableViewRefreshControl.endRefreshing()
        }
    }
    
    
    // MARK: -DATA FUNCTIONS
    
    func clearTickerFilter() {
        // Set all tickers to not selected
        for i in localTickers.indices {
            localTickers[i].selected = false
        }
        
        // Now refill the Notions list
        fillLocalNotions()
    }
    
    func fillNotionActions() {
        // Fill the Notions with associated NotionActions
        // Also fill an additional array with just NotionActions from this user
        // to determine if action indicators need to be set on Notion cells
        for i in localNotions.indices {
            // Filter for the actions for this notion
            // and filter the filtered actions for this account's actions
            let sentimentActions = notionActionRepository.notionActions.filter({ $0.notion == localNotions[i].id && $0.type == "sentiment" })
            // There should only be one sentiment action for this user on this notion
            if sentimentActions.count < 1 { continue }
            localNotions[i].sentimentAction = sentimentActions[0]
            
            // Calculate the total positive and negative corrections and apply the correction total
            // (multiplied by the sentiment adjustment amount - see settings) to the sentiment value
            localNotions[i].sentiment = localNotions[i].sentiment + (Float(sentimentActions[0].quantity) * Settings.sentimentAdjAmt)
        }
        updateDataSummaries()
        sortToggle()
    }
    func fillLocalNotions() {
        guard let notionRepo = notionRepository else { return }
        localNotions.removeAll()
        // Filter the data based on ticker selection ONLY IF ANY ARE SELECTED
        if localTickers.filter({ $0.selected }).count > 0 {
            localNotions = notionRepo.notions.filter({
                let tickers = $0.tickers
                return localTickers.filter({ tickers.contains($0.ticker) && $0.selected }).count > 0
            })
        } else {
            localNotions = notionRepo.notions
        }
        tickerTableView.reloadData()
        fillNotionActions()
    }
    func sortToggle() {
        if sortByResponse {
            localNotions = localNotions.sorted(by: { $0.responseCount > $1.responseCount })
        } else {
            localNotions = localNotions.sorted(by: { $0.created > $1.created })
        }
        notionTableView.reloadData()
    }
    
    func updateDataLists() {
        guard let notionRepo = notionRepository else { return }
        // Get the ids of the cells currently in view
        // then scroll to those cells after the update
//        var topId = ""
//        if tableView.visibleCells.count > 0 {
//            if let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: IndexPath(row: tableView.visibleCells.startIndex, section: 0)) as? NotionCell {
//                print("TOP CELL ID: \(cell.id)")
//                if let id = cell.id {
//                    topId = id
//                }
//            }
//        }
//        print("topId: \(topId)")
        
//        let oldCount = localNotions.count
//        print(oldCount)
        
        // Switch out the local data with newly synced data
        // Handle tickers first to prep for filling notion list
        // Sort tickers first by response then alphabetically
        localTickers.removeAll()
        localTickers = notionRepo.tickers.sorted(by: {
            if $0.responseCount != $1.responseCount {
                return $0.responseCount > $1.responseCount
            } else {
                return $0.ticker < $1.ticker
            }
        })
        fillLocalNotions()
        // Sort after filling the local notion list
        sortToggle()
        
//        // Before updating, find the index of the notion last in
//        // top view and scroll to it after updating
//        if let lastTopIndex = localNotions.firstIndex(where: { $0.id == topId }) {
//            print("scroll to last index: \(lastTopIndex)")
//            let newIndexPath = IndexPath(row: lastTopIndex, section: 0)
//            tableView.reloadData()
//            tableView.scrollToRow(at: newIndexPath, at: .top, animated: true)
//        } else {
//            print("last index not found")
//            tableView.reloadData()
//        }
        
//        if localNotions.count - oldCount > 0 && oldCount > 0 {
//            var initialOffset = notionTableView.contentOffset.y
//            if initialOffset < 0 {
//                initialOffset = 0
//            }
//            print("count diff: \(localNotions.count - oldCount), offset: \(initialOffset)")
//            notionTableView.reloadData()
//            notionTableView.scrollToRow(at: IndexPath(row: localNotions.count - oldCount - 1, section: 0), at: .top, animated: false)
//            notionTableView.contentOffset.y += initialOffset
//        } else {
//            notionTableView.reloadData()
//        }
        
//        let beforeContentSize = tableView.contentSize
//        let beforeContentOffset = tableView.contentOffset
//        tableView.reloadData()
//        tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + tableView.contentSize.height - beforeContentSize.height)
//        print("BEFORE SIZE: \(beforeContentSize), AFTER SIZE: \(tableView.contentSize), BEFORE OFFSET: \(beforeContentOffset), AFTER OFFSET: \(tableView.contentOffset)")
    }
    
    func updateDataSummaries() {
        // Update the notion title to the timestamp of the earliest Notion
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "h:mm a"
        format.amSymbol = "AM"
        format.pmSymbol = "PM"
        if localNotions.count > 0 {
            if let min = localNotions.map({ $0.created }).min() {
                let dateString = format.string(from: Date(timeIntervalSince1970: Double(min)))
                notionTitle.text = "SINCE  " + dateString
            }
        }
        
        // Refresh the header values
        let responseCount = localNotions
            .compactMap { $0.responseCount }
            .reduce(0, +)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedSum = numberFormatter.string(from: NSNumber(value: responseCount))
        notionCountLabel.text = formattedSum
        
        // Handle the aggregated sentiment values
        let wAvgSentiment = localNotions
            .map { $0.sentiment * Float($0.responseCount) }
            .reduce(0, +) / Float(responseCount)
        let wAvgMagnitude = localNotions
            .map { $0.magnitude * Float($0.responseCount) }
            .reduce(0, +) / Float(responseCount)
        
//        print("NOTIONS - WAVG SENTIMENT: \(wAvgSentiment), MAGNITUDE: \(wAvgMagnitude)")
        
        if wAvgSentiment > 0 {
            progressViewLeft.progress = 1
            progressViewRight.progress = wAvgSentiment
        } else if wAvgSentiment < 0 {
            progressViewLeft.progress = 1 - abs(wAvgSentiment)
            progressViewRight.progress = 0
        } else {
            progressViewLeft.progress = 0
            progressViewRight.progress = 1
        }
        if wAvgMagnitude > 1 {
            progressViewLeft.trackTintColor = Settings.Theme.Color.negative
            progressViewRight.progressTintColor = Settings.Theme.Color.positive
        } else if wAvgMagnitude > 0.1 {
            progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.Color.negativeLight, color2: Settings.Theme.Color.negative, percent: Double(wAvgMagnitude))
            progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.Color.positiveLight, color2: Settings.Theme.Color.positive, percent: Double(wAvgMagnitude))
        } else {
            progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.Color.negativeLight, color2: Settings.Theme.Color.negative, percent: 0.1)
            progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.Color.positiveLight, color2: Settings.Theme.Color.positive, percent: 0.1)
        }
    }
    
    
    // MARK: -HOLE VIEW DELEGATE
    
    func holeViewRemoved(removingViewAtPosition: Int) {
        // Give a short tutorial for new users
        switch removingViewAtPosition {
        case 1:
            // Explain the feed.
            print("\(className) - TUTORIAL 2")
            let holeView = HoleView(holeViewPosition: 2, frame: viewContainer.bounds, circleOffsetX: 180, circleOffsetY: 220, circleRadius: 130, textOffsetX: (viewContainer.bounds.width / 2) - 160, textOffsetY: 370, textWidth: 320, textFontSize: 24, text: "Social media posts regarding stocks, cryptocurrencies, or hot investment topics are displayed in the feed.")
            holeView.holeViewDelegate = self
            viewContainer.addSubview(holeView)
        case 2:
            // Explain the response indicator.
            print("\(className) - TUTORIAL 3")
            let holeView = HoleView(holeViewPosition: 3, frame: viewContainer.bounds, circleOffsetX: viewContainer.frame.width - 40, circleOffsetY: 150, circleRadius: 40, textOffsetX: (viewContainer.bounds.width / 2) - 150, textOffsetY: 240, textWidth: 300, textFontSize: 24, text: "The number of responses from the associated social media platform include upvotes, downvotes, awards, and comments to indicate overall attention.")
            holeView.holeViewDelegate = self
            viewContainer.addSubview(holeView)
        case 3:
            // Explain the sentiment bar.
            print("\(className) - TUTORIAL 4")
            let holeView = HoleView(holeViewPosition: 4, frame: viewContainer.bounds, circleOffsetX: (viewContainer.frame.width / 2) + 50, circleOffsetY: 170, circleRadius: 60, textOffsetX: (viewContainer.bounds.width / 2) - 160, textOffsetY: 260, textWidth: 320, textFontSize: 22, text: "The sentiment bar shows green when positive emotion is detected, and red when emotions are negative. Brighter colors indicate more intense emotions.\n\nNot all emotional analyses will be accurate; we are constantly training our artificial intelligence model to better detect emotions regarding investments.")
            holeView.holeViewDelegate = self
            viewContainer.addSubview(holeView)
        case 4:
            allowUpdates = false
            // Explain the sentiment bar.
            print("\(className) - TUTORIAL 5")
            let holeView = HoleView(holeViewPosition: 5, frame: viewContainer.bounds, circleOffsetX: viewContainer.frame.width, circleOffsetY: 250, circleRadius: 140, textOffsetX: (viewContainer.bounds.width / 2) - 150, textOffsetY: 400, textWidth: 300, textFontSize: 24, text: "Swipe the row left or right to correct the sentiment analysis and help train our AI model.\n\nSwipe multiple times for larger corrections.")
            holeView.holeViewDelegate = self
            viewContainer.addSubview(holeView)
            
            if localNotions.count > 0 {
                let cell = notionTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! NotionCell
                cell.tutorialAnimation()
            }
        case 5:
            allowUpdates = true
            // Conclusion.
            print("\(className) - TUTORIAL 6")
            let holeView = HoleView(holeViewPosition: 6, frame: viewContainer.bounds, circleOffsetX: 0, circleOffsetY: 0, circleRadius: 0, textOffsetX: (viewContainer.bounds.width / 2) - 160, textOffsetY: 60, textWidth: 320, textFontSize: 28, text: "We hope you enjoy Gandalf!\n\nThe Gandalf team is constantly adding more sources for sentiment analysis and building features to enhance your own investment conversations and prediction of future prices.")
            holeView.holeViewDelegate = self
            viewContainer.addSubview(holeView)
        default:
            // The tutorial has ended - Record the Tutorial as viewed for this user.
            print("\(className) - TUTORIAL END")
            
            if let accountRepo = accountRepository {
                accountRepo.addTutorialViewFor(view: className)
            }
        }
    }
}
