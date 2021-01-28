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
//    var notionReference: DocumentReference?
//    var notionCollection: LocalCollection<Notion>!
    var notionRepository: NotionRepository!
    
    var viewContainer: UIView!
    var headerContainer: UIView!
    var titleLabel: UILabel!
    var titleLabel2: UILabel!
    var labelsContainer: UIView!
    var notionCountLabel: UILabel!
    var notionIcon: UIImageView!
    var progressViewContainer: UIView!
    var progressViewLeft: ProgressViewRoundedLeft!
    var progressViewRight: ProgressViewRoundedRight!
    var refreshControl: UIRefreshControl!
    let tableCellIdentifier: String = "NotionCell"
    var tableView: UITableView!
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        print("\(viewName) - preferredStatusBarStyle")
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(viewName) - viewDidLoad")
        self.navigationItem.title = ""
        
        let barItemLogo = UIButton(type: .custom)
//        barItemAdd.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        barItemLogo.setTitle(pageTitle, for: .normal)
        barItemLogo.titleLabel?.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        barItemLogo.titleLabel?.textAlignment = .left
        barItemLogo.setTitleColor(Settings.Theme.colorPrimaryLight, for: .normal)
        let barItemProfile = UIButton(type: .custom)
        barItemProfile.setImage(UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.colorPrimaryLight, renderingMode: .alwaysOriginal), for: .normal)
        barItemProfile.addTarget(self, action: #selector(loadProfileView), for: .touchUpInside)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:120),
            barItemProfile.widthAnchor.constraint(equalToConstant:50),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barItemProfile)]
        self.navigationItem.hidesBackButton = true
//        self.navigationItem.title = pageTitle
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
            headerContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            labelsContainer.bottomAnchor.constraint(equalTo:headerContainer.bottomAnchor, constant: -10),
            labelsContainer.rightAnchor.constraint(equalTo:headerContainer.rightAnchor, constant: -10),
            labelsContainer.widthAnchor.constraint(equalToConstant: 200),
            labelsContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            notionIcon.topAnchor.constraint(equalTo:labelsContainer.topAnchor, constant: 10),
            notionIcon.bottomAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: -5),
            notionIcon.rightAnchor.constraint(equalTo:labelsContainer.rightAnchor, constant: -5),
            notionIcon.widthAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            notionCountLabel.topAnchor.constraint(equalTo:labelsContainer.topAnchor, constant: 10),
            notionCountLabel.bottomAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: 0),
            notionCountLabel.rightAnchor.constraint(equalTo:notionIcon.leftAnchor, constant: -10),
            notionCountLabel.leftAnchor.constraint(equalTo:labelsContainer.leftAnchor, constant: 10),
        ])
        NSLayoutConstraint.activate([
            titleLabel2.bottomAnchor.constraint(equalTo:headerContainer.bottomAnchor, constant: -10),
            titleLabel2.leftAnchor.constraint(equalTo:headerContainer.leftAnchor, constant: 10),
            titleLabel2.rightAnchor.constraint(equalTo:labelsContainer.leftAnchor, constant: -10),
            titleLabel2.heightAnchor.constraint(equalToConstant: 40),
        ])
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:headerContainer.topAnchor, constant: 5),
            titleLabel.leftAnchor.constraint(equalTo:headerContainer.leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo:headerContainer.rightAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo:titleLabel2.topAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            progressViewContainer.bottomAnchor.constraint(equalTo:headerContainer.bottomAnchor, constant: 0),
            progressViewContainer.leftAnchor.constraint(equalTo:headerContainer.leftAnchor, constant: 0),
            progressViewContainer.rightAnchor.constraint(equalTo:headerContainer.rightAnchor, constant: 0),
            progressViewContainer.heightAnchor.constraint(equalToConstant: 10),
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
            tableView.topAnchor.constraint(equalTo:headerContainer.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            tableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
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
        notionRepository = NotionRepository(ticker: "GME", recency: 3600)
        notionRepository.repoDelegate = self
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.background
        
        viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        headerContainer = UIView()
        headerContainer.backgroundColor = Settings.Theme.colorPrimaryLight
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(headerContainer)
        
        titleLabel = UILabel()
        titleLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 20)
        titleLabel.textColor = Settings.Theme.text
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 1
        titleLabel.text = "Apple, Inc."
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(titleLabel)
        
        titleLabel2 = UILabel()
        titleLabel2.font = UIFont(name: Assets.Fonts.Default.bold, size: 30)
        titleLabel2.textColor = Settings.Theme.text
        titleLabel2.textAlignment = NSTextAlignment.left
        titleLabel2.numberOfLines = 1
        titleLabel2.text = "$AAPL"
        titleLabel2.isUserInteractionEnabled = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(titleLabel2)
        
        labelsContainer = UIView()
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(labelsContainer)
        
        notionIcon = UIImageView()
        notionIcon.image = UIImage(named: Assets.Images.notionIconWhiteSmall)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(notionIcon)
        
        notionCountLabel = UILabel()
        notionCountLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 30)
        notionCountLabel.textColor = Settings.Theme.text
        notionCountLabel.textAlignment = NSTextAlignment.right
        notionCountLabel.numberOfLines = 1
        notionCountLabel.text = ""
        notionCountLabel.isUserInteractionEnabled = false
        notionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(notionCountLabel)
        
        progressViewContainer = UIView()
//        progressViewContainer.backgroundColor = .red //Settings.Theme.colorPrimary //.withAlphaComponent(0.5)
        progressViewContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(progressViewContainer)
        
        progressViewLeft = ProgressViewRoundedLeft()
        progressViewLeft.progressViewStyle = .bar
        progressViewLeft.trackTintColor = Settings.Theme.colorGrayLight.withAlphaComponent(0.2)
        progressViewLeft.progressTintColor = Settings.Theme.colorPrimary
        progressViewLeft.progress = 0.5
        progressViewLeft.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewLeft)
        
        progressViewRight = ProgressViewRoundedRight()
        progressViewRight.progressViewStyle = .bar
        progressViewRight.trackTintColor = Settings.Theme.colorPrimary
        progressViewRight.progressTintColor = Settings.Theme.colorGrayLight.withAlphaComponent(0.2)
        progressViewRight.progress = 0.5
        progressViewRight.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewRight)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        tableView = UITableView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.refreshControl = refreshControl
        tableView.dragInteractionEnabled = true
        tableView.register(NotionCell.self, forCellReuseIdentifier: tableCellIdentifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = Settings.Theme.background
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.bounces = true
        tableView.alwaysBounceVertical = true
        tableView.showsVerticalScrollIndicator = false
        tableView.isUserInteractionEnabled = true
        tableView.allowsSelection = true
//        tableView.delaysContentTouches = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        tableView.insetsContentViewsToSafeArea = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tableView)
        
//        // If a user is not logged in, display the Login screen
//        if let firUser = Auth.auth().currentUser {
//            print("\(viewName) - currentUser: \(firUser.uid)")
//            loadLists()
//        } else {
//            self.presentSheet(with: ProfileView())
//            loadLists()
//        }
        
//        notionCollection = LocalCollection(query: Settings.Firebase.db().collection("notion")) { [unowned self] (changes) in
//            print("NOTION CHANGES: \(changes)")
//        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -CUSTOM DELEGATE METHODS
    
    func dataUpdate() {
        tableView.reloadData()
        
        // Refresh the header values
        let sum = self.notionRepository.notions
            .compactMap { $0.responseCount }
//            .filter { $0.name == "Day" }
//            .map { $0.value }
            .reduce(0, +)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        let formattedSum = numberFormatter.string(from: NSNumber(value:sum))
        notionCountLabel.text = formattedSum
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func loadProfileView(_ sender: UITapGestureRecognizer) {
        print("\(viewName) - loadProfileView")
//        self.presentSheet(with: ProfileView())
    }
    
    
    // MARK: -TABLE VIEW DATA SOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("row count: \(notionRepository.notions.count)")
        return notionRepository.notions.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
//        return UITableView.automaticDimension
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableCellIdentifier, for: indexPath) as! NotionCell
        let notion = notionRepository.notions[indexPath.row]
        cell.textView.text = notion.text //String(notion.sentiment) + ", " + String(notion.magnitude)
        cell.notionCountLabel.text = String(notion.responseCount)
        if notion.tickers.count > 0 {
            var titleText = "$" + notion.tickers[0]
            for i in 1..<notion.tickers.count {
                titleText += ", $" + notion.tickers[i]
            }
            cell.titleLabel.text = titleText
        }
        if notion.categories.count > 0 {
            var textTitle = notion.categories[0]
            for i in 1..<notion.categories.count {
                textTitle += ", " + notion.categories[i]
            }
            cell.textTitle.text = textTitle
        } else {
            cell.textTitle.text = notion.host
        }
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
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("NOTION ROW \(indexPath.row)")
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
    }
    
    
    // MARK: -REFRESH CONTROL
    
    @objc private func refreshTableData(_ sender: Any) {
        print("refreshTableData")
        // Data is refreshed automatically - pause before dismissing the spinner to convey this to the user.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
            self.refreshControl.endRefreshing()
        }
    }
}

