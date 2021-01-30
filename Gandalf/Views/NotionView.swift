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

class NotionView: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, RepositoryDelegate {
    let viewName = "NotionView"
    
    var pageTitle = "Gandalf"
    var sortByResponse = false
    var localTickers = [Ticker]()
    var localNotions = [Notion]()
    var notionRepository: NotionRepository!
    
    var viewContainer: UIView!
    var headerContainer: UIView!
    var tickerContainer: UIView!
    var tickerTableView: UITableView!
    var tickerTableViewRefreshControl: UIRefreshControl!
    var tickerTableViewSpinner = UIActivityIndicatorView(style: .medium)
    let tickerTableCellIdentifier: String = "TickerCell"
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
    var notionTableViewSpinner = UIActivityIndicatorView(style: .large)
    var notionTableViewEmptyNote: UILabel!
    let notionTableCellIdentifier: String = "NotionCell"
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        print("\(viewName) - preferredStatusBarStyle")
//        return .lightContent
//    }
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(viewName) - viewDidLoad")
        self.navigationItem.title = ""
        
        let barItemLogo = UIButton(type: .custom)
//        barItemAdd.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        barItemLogo.setTitle(pageTitle, for: .normal)
        barItemLogo.titleLabel?.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        barItemLogo.titleLabel?.textAlignment = .left
        barItemLogo.setTitleColor(Settings.Theme.navBarText, for: .normal)
        let barItemProfile = UIButton(type: .custom)
        barItemProfile.setImage(UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.navBarText, renderingMode: .alwaysOriginal), for: .normal)
        barItemProfile.addTarget(self, action: #selector(loadProfileView), for: .touchUpInside)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:120),
            barItemProfile.widthAnchor.constraint(equalToConstant:70),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barItemProfile)]
        self.navigationItem.hidesBackButton = true
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(viewName) - willEnterForegroundNotification")
            notionRepository.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(viewName) - didEnterBackgroundNotification")
            notionRepository.stopObserving()
        }
//        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToForeground), name: Notification.Name.NSExtensionHostWillEnterForeground, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(appMovedToBackground), name: Notification.Name.NSExtensionHostDidEnterBackground, object: nil)
    }
    
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(viewName) - viewWillAppear")
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
            notionIcon.topAnchor.constraint(equalTo:notionTitle.topAnchor, constant: 10),
            notionIcon.bottomAnchor.constraint(equalTo:notionContainer.bottomAnchor, constant: -5),
            notionIcon.leftAnchor.constraint(equalTo:notionContainer.leftAnchor, constant: 5),
            notionIcon.widthAnchor.constraint(equalToConstant: 50),
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
            tickerContainer.widthAnchor.constraint(equalToConstant: 120),
        ])
        NSLayoutConstraint.activate([
            tickerClearButton.topAnchor.constraint(equalTo:tickerContainer.topAnchor),
            tickerClearButton.leftAnchor.constraint(equalTo:tickerContainer.leftAnchor),
            tickerClearButton.rightAnchor.constraint(equalTo:tickerContainer.rightAnchor),
            tickerClearButton.heightAnchor.constraint(equalToConstant: 70),
        ])
        NSLayoutConstraint.activate([
            tickerClearIcon.topAnchor.constraint(equalTo:tickerClearButton.topAnchor, constant: 20),
            tickerClearIcon.leftAnchor.constraint(equalTo:tickerClearButton.leftAnchor, constant: 20),
            tickerClearIcon.rightAnchor.constraint(equalTo:tickerClearButton.rightAnchor, constant: -20),
            tickerClearIcon.bottomAnchor.constraint(equalTo:tickerClearButton.bottomAnchor, constant: -20),
        ])
        NSLayoutConstraint.activate([
            tickerTableView.topAnchor.constraint(equalTo:tickerClearButton.bottomAnchor),
            tickerTableView.leftAnchor.constraint(equalTo:tickerContainer.leftAnchor),
            tickerTableView.rightAnchor.constraint(equalTo:tickerContainer.rightAnchor),
            tickerTableView.bottomAnchor.constraint(equalTo:tickerContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            tickerTableViewSpinner.centerXAnchor.constraint(equalTo:tickerTableView.centerXAnchor, constant: 0),
            tickerTableViewSpinner.centerYAnchor.constraint(equalTo:tickerTableView.centerYAnchor, constant: -130),
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
        NSLayoutConstraint.activate([
            notionTableViewEmptyNote.topAnchor.constraint(equalTo:notionTableView.topAnchor, constant: 40),
            notionTableViewEmptyNote.leftAnchor.constraint(equalTo:viewContainer.leftAnchor, constant: 20),
            notionTableViewEmptyNote.rightAnchor.constraint(equalTo:viewContainer.rightAnchor, constant: -20),
            notionTableViewEmptyNote.heightAnchor.constraint(equalToConstant: 200),
        ])
        
        notionRepository.observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(viewName) - viewWillDisappear")
//        navigationController?.setNavigationBarHidden(false, animated: animated)
        notionRepository.stopObserving()
    }

    override func loadView() {
        super.loadView()
        print("\(viewName) - loadView")
        notionRepository = NotionRepository(recency: 3600)
        notionRepository.repoDelegate = self
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.background
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        headerContainer = UIView()
        headerContainer.backgroundColor = Settings.Theme.colorPrimaryLight
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
        notionTitle.textColor = Settings.Theme.text
        notionTitle.textAlignment = NSTextAlignment.left
        notionTitle.numberOfLines = 1
        notionTitle.text = "LAST HOUR"
        notionTitle.isUserInteractionEnabled = false
        notionTitle.translatesAutoresizingMaskIntoConstraints = false
        notionContainer.addSubview(notionTitle)
        
        notionIcon = UIImageView()
        notionIcon.image = UIImage(named: Assets.Images.notionIconWhiteLarge)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        notionContainer.addSubview(notionIcon)
        
        notionCountLabel = UILabel()
        notionCountLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 50)
        notionCountLabel.textColor = Settings.Theme.text
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
        filterIcon.image = UIImage(named: Assets.Images.twinkleIconBlue)
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
        progressViewLeft.trackTintColor = .clear //Settings.Theme.colorGrayLight.withAlphaComponent(0.2)
        progressViewLeft.progressTintColor = Settings.Theme.colorGrayDark
        progressViewLeft.progress = 1
        progressViewLeft.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewLeft)
        
        progressViewRight = ProgressViewRoundedRight()
        progressViewRight.progressViewStyle = .bar
        progressViewRight.trackTintColor = Settings.Theme.colorGrayDark
        progressViewRight.progressTintColor = .clear //Settings.Theme.colorGrayLight.withAlphaComponent(0.2)
        progressViewRight.progress = 0
        progressViewRight.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewRight)
        
        tickerContainer = UIView()
        tickerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tickerContainer)
        
        tickerClearButton = UIView()
        tickerClearButton.translatesAutoresizingMaskIntoConstraints = false
        tickerContainer.addSubview(tickerClearButton)
        
        let tickerClearButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tickerClear))
        tickerClearButtonGestureRecognizer.numberOfTapsRequired = 1
        tickerClearButton.addGestureRecognizer(tickerClearButtonGestureRecognizer)
        
        tickerClearIcon = UIImageView()
        tickerClearIcon.image = UIImage(systemName: "clear")
        tickerClearIcon.tintColor = Settings.Theme.backgroundSelected
        tickerClearIcon.contentMode = UIView.ContentMode.scaleAspectFit
        tickerClearIcon.clipsToBounds = true
        tickerClearIcon.translatesAutoresizingMaskIntoConstraints = false
        tickerClearButton.addSubview(tickerClearIcon)
        tickerClearIcon.isHidden = true
        
        tickerTableViewRefreshControl = UIRefreshControl()
        tickerTableViewRefreshControl.tintColor = Settings.Theme.background
        tickerTableViewRefreshControl.addTarget(self, action: #selector(tickerClear), for: .valueChanged)
        
        tickerTableView = UITableView()
        tickerTableView.dataSource = self
        tickerTableView.delegate = self
        tickerTableView.refreshControl = tickerTableViewRefreshControl
        tickerTableView.dragInteractionEnabled = true
        tickerTableView.register(TickerCell.self, forCellReuseIdentifier: tickerTableCellIdentifier)
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
        notionTableViewRefreshControl.tintColor = Settings.Theme.backgroundSelected
        notionTableViewRefreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        notionTableView = UITableView()
        notionTableView.dataSource = self
        notionTableView.delegate = self
        notionTableView.refreshControl = notionTableViewRefreshControl
        notionTableView.dragInteractionEnabled = true
        notionTableView.register(NotionCell.self, forCellReuseIdentifier: notionTableCellIdentifier)
        notionTableView.separatorStyle = .none
        notionTableView.backgroundColor = .clear
//        notionTableView.rowHeight = UITableView.automaticDimension
//        notionTableView.estimatedRowHeight = UITableView.automaticDimension
        notionTableView.estimatedRowHeight = 0
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
        
        notionTableViewEmptyNote = UILabel()
        notionTableViewEmptyNote.font = UIFont(name: Assets.Fonts.Default.light, size: 30)
        notionTableViewEmptyNote.textColor = Settings.Theme.text
        notionTableViewEmptyNote.textAlignment = NSTextAlignment.center
        notionTableViewEmptyNote.numberOfLines = 2
        notionTableViewEmptyNote.text = "Please sign in\nto load data."
        notionTableViewEmptyNote.isUserInteractionEnabled = false
        notionTableViewEmptyNote.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(notionTableViewEmptyNote)
        notionTableViewEmptyNote.isHidden = true
        
        // If a user is not logged in, display the Login screen
        if let firUser = Auth.auth().currentUser {
            print("\(viewName) - currentUser: \(firUser.uid)")
        } else {
            self.presentSheet(with: ProfileView())
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    // TODO: Detect LoginView dismissal to refresh data
//    public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
//        print("DISMISS")
//    }
    
    
    // MARK: -CUSTOM DELEGATE METHODS
    
    func showLogin() {
        self.presentSheet(with: ProfileView())
    }
    func dataUpdate() {
        updateDataLists()
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
    
    @objc func loadProfileView(_ sender: UITapGestureRecognizer) {
        print("\(viewName) - loadProfileView")
        self.presentSheet(with: ProfileView())
    }
    @objc func filterToggle(_ sender: UITapGestureRecognizer) {
        print("\(viewName) - filterToggle")
        if !sortByResponse {
            // Turn on the filter
            sortByResponse = true
            filterIcon.image = UIImage(named: Assets.Images.twinkleIconWhite)
        } else {
            sortByResponse = false
            filterIcon.image = UIImage(named: Assets.Images.twinkleIconBlue)
        }
        sortToggle()
    }
    @objc func scrollTop(_ sender: UITapGestureRecognizer) {
        print("\(viewName) - scrollTop")
        notionTableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }
    @objc func tickerClear(_ sender: UITapGestureRecognizer) {
        print("\(viewName) - tickerClear")
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
                notionTableViewEmptyNote.isHidden = true
                notionTableViewSpinner.stopAnimating()
            } else if Auth.auth().currentUser == nil {
                notionTableViewEmptyNote.isHidden = false
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
                tickerClearIcon.isHidden = false
            } else {
                tickerTableViewSpinner.startAnimating()
                tickerClearIcon.isHidden = true
            }
            return localTickers.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
        if tableView == notionTableView {
            return 250
            
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
                cell.progressViewLeft.trackTintColor = Settings.Theme.colorSecondary
                cell.progressViewRight.progressTintColor = Settings.Theme.colorPrimary
            } else if notion.magnitude > 0.1 {
                cell.progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.colorSecondaryLight, color2: Settings.Theme.colorSecondary, percent: Double(notion.magnitude))
                cell.progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.colorPrimaryLight, color2: Settings.Theme.colorPrimary, percent: Double(notion.magnitude))
            } else {
                cell.progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.colorSecondaryLight, color2: Settings.Theme.colorSecondary, percent: 0.1)
                cell.progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.colorPrimaryLight, color2: Settings.Theme.colorPrimary, percent: 0.1)
            }
            
            return cell
            
        } else if tableView == tickerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: tickerTableCellIdentifier, for: indexPath) as! TickerCell
            cell.selectionStyle = .none
            if indexPath.row == 0 {
                cell.containerBorder.layer.borderColor = UIColor.clear.cgColor
            }
            let cellTicker = localTickers[indexPath.row]
            if let t = cellTicker.ticker {
                cell.title.text = "$" + t
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let formattedSum = numberFormatter.string(from: NSNumber(value: cellTicker.responseCount))
                cell.countText.text = formattedSum
                
                if cellTicker.wAvgSentiment >= 0 {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconBlueLarge)
                } else {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconRedLarge)
                }
            }
            if cellTicker.selected {
                cell.containerView.backgroundColor = Settings.Theme.backgroundSelected
            } else {
                cell.containerView.backgroundColor = Settings.Theme.background
            }
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == notionTableView {
            print("NOTION ROW \(indexPath.row)")
            
        } else if tableView == tickerTableView {
            print("TICKER ROW \(indexPath.row)")
            if localTickers[indexPath.row].selected {
                localTickers[indexPath.row].selected = false
            } else {
                localTickers[indexPath.row].selected = true
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
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let action = UIContextualAction(style: .normal, title: "Not\nRelevant") { [weak self] (action, view, completionHandler) in
////            self?.handleMarkAsFavourite()
//            print("DELETE ROW: \(indexPath.row)")
//            completionHandler(true)
//        }
//        action.backgroundColor = .systemBlue
//        return UISwipeActionsConfiguration(actions: [action])
//    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let hide = UIContextualAction(style: .destructive, title: "Not\nRelevant") { [weak self] (action, view, completionHandler) in
////            self?.handleMarkAsFavourite()
//            print("HIDE ROW: \(indexPath.row)")
//            completionHandler(true)
//        }
//        hide.backgroundColor = Settings.Theme.colorSecondary
//        return UISwipeActionsConfiguration(actions: [hide])
//    }
    

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
        print("refreshTableData")
        if let firUser = Auth.auth().currentUser {
            print("\(viewName) - currentUser: \(firUser.uid)")
        } else {
            self.presentSheet(with: ProfileView())
        }
        
        // Data is refreshed automatically - pause before dismissing the spinner to convey this to the user.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.notionTableViewRefreshControl.endRefreshing()
        }
    }
    
    
    // MARK: -DATA FUNCTIONS
    
    func clearTickerFilter() {
        tickerClearIcon.tintColor = Settings.Theme.backgroundSelected
        
        // Set all tickers to not selected
        for i in localTickers.indices {
            localTickers[i].selected = false
        }
        
        // Now refill the Notions list
        fillLocalNotions()
    }
    
    func fillLocalNotions() {
        localNotions.removeAll()
        // Filter the data based on ticker selection ONLY IF ANY ARE SELECTED
        if localTickers.filter({ $0.selected }).count > 0 {
            localNotions = notionRepository.notions.filter({
                let tickers = $0.tickers
                return localTickers.filter({ tickers.contains($0.ticker) && $0.selected }).count > 0
            })
            tickerClearIcon.tintColor = Settings.Theme.colorPrimaryLight
        } else {
            localNotions = notionRepository.notions
            tickerClearIcon.tintColor = Settings.Theme.backgroundSelected
        }
        tickerTableView.reloadData()
        notionTableView.reloadData()
        
        sortToggle()
        updateDataSummaries()
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
        localTickers.removeAll()
        localTickers = notionRepository.tickers.sorted(by: { $0.responseCount > $1.responseCount })
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
        let dateString = format.string(from: Date(timeIntervalSince1970: Double(localNotions[localNotions.count-1].created)))
        notionTitle.text = "SINCE  " + dateString
        
        // Refresh the header values
        let responseCount = localNotions
            .compactMap { $0.responseCount }
//            .filter { $0.name == "Day" }
//            .map { $0.value }
            .reduce(0, +)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedSum = numberFormatter.string(from: NSNumber(value: responseCount))
        notionCountLabel.text = formattedSum
        
        // Handle the aggregated sentiment values
        let wAvgSentiment = localNotions
            .compactMap { $0.sentiment * Float($0.responseCount) }
            .reduce(0, +) / Float(responseCount)
        let wAvgMagnitude = localNotions
            .compactMap { $0.magnitude * Float($0.responseCount) }
            .reduce(0, +) / Float(responseCount)
        
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
            progressViewLeft.trackTintColor = Settings.Theme.colorSecondary
            progressViewRight.progressTintColor = Settings.Theme.colorPrimary
        } else if wAvgMagnitude > 0.1 {
            progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.colorSecondaryLight, color2: Settings.Theme.colorSecondary, percent: Double(wAvgMagnitude))
            progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.colorPrimaryLight, color2: Settings.Theme.colorPrimary, percent: Double(wAvgMagnitude))
        } else {
            progressViewLeft.trackTintColor = Settings.gradientColor(color1: Settings.Theme.colorSecondaryLight, color2: Settings.Theme.colorSecondary, percent: 0.1)
            progressViewRight.progressTintColor = Settings.gradientColor(color1: Settings.Theme.colorPrimaryLight, color2: Settings.Theme.colorPrimary, percent: 0.1)
        }
    }
}

