//
//  ContentView.swift
//  Gandalf
//
//  Created by Sean Hart on 1/26/21.
//

import UIKit
import Firebase
//import FirebaseAnalytics
import FirebaseAuth

class TickerView: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    let viewName = "TickerView"
    
    var pageTitle = "Gandalf"
//    var notionReference: DocumentReference?
    var notionCollection: LocalCollection<Notion>!
    
    var viewContainer: UIView!
    var refreshControl: UIRefreshControl!
    let tickerTableCellIdentifier: String = "TickerCell"
    var tickerTableView: UITableView!
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        print("\(viewName) - preferredStatusBarStyle")
//        return .lightContent
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        
        let barItemLogo = UIButton(type: .custom)
//        barItemAdd.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        barItemLogo.setTitle(pageTitle, for: .normal)
        let barItemProfile = UIButton(type: .custom)
        barItemProfile.setImage(UIImage(systemName: "person.crop.circle.fill"), for: .normal)
        barItemProfile.addTarget(self, action: #selector(TickerView.loadProfileView(_:)), for: .touchUpInside)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:50),
            barItemProfile.widthAnchor.constraint(equalToConstant:40),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: barItemProfile)]
        self.navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            tickerTableView.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            tickerTableView.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            tickerTableView.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            tickerTableView.bottomAnchor.constraint(equalTo:viewContainer.bottomAnchor),
        ])
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func loadView() {
        super.loadView()
        print("\(viewName) - loadView")
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.background
        
        viewContainer = UIView()
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableData), for: .valueChanged)
        
        tickerTableView = UITableView()
        tickerTableView.dataSource = self
        tickerTableView.delegate = self
        tickerTableView.refreshControl = refreshControl
        tickerTableView.dragInteractionEnabled = true
        tickerTableView.register(TickerCell.self, forCellReuseIdentifier: tickerTableCellIdentifier)
        tickerTableView.separatorStyle = .none
        tickerTableView.backgroundColor = Settings.Theme.background
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
        viewContainer.addSubview(tickerTableView)
        
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
        
//        fetchData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return 0 //notionCollection.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight: CGFloat = 300
        return cellHeight
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tickerTableCellIdentifier, for: indexPath) as! TickerCell
//        cell.title.text = notionCollection[indexPath.row].text
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("TICKER ROW \(indexPath.row)")
    }

    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
    }
    

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
