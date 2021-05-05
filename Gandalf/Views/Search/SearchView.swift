//
//  SearchView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
import FirebaseAuth

protocol SearchViewDelegate {
    func searchViewSelected(selection: String)
}

class SearchView: UIViewController, UIGestureRecognizerDelegate {
    let className = "SearchView"
    
    var delegate: SearchViewDelegate!
    var viewTitle: String!
    var results = [String]()
    
    var viewContainer: UIView!
    var searchBackground: UIView!
    var searchIcon: UIImageView!
    var searchField: UITextField!
    var resultsTableView: UITableView!
    let resultsTableCellIdentifier: String = "ResultsCell"
    
    init(title: String, options: [String]) {
        self.viewTitle = title
        self.results = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = viewTitle
        self.navigationItem.hidesBackButton = false
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.navigationItem.leftBarButtonItem = nil
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
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            searchBackground.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            searchBackground.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            searchBackground.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            searchBackground.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            resultsTableView.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            resultsTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            resultsTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            resultsTableView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
        ])
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
        
        searchBackground = UIView()
        searchBackground.backgroundColor = Settings.Theme.Color.contentBackground
        searchBackground.layer.cornerRadius = 5
//        searchBackground.layer.borderWidth = 1
//        searchBackground.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        searchBackground.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(searchBackground)
        
        
        
        resultsTableView = UITableView()
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        resultsTableView.dragInteractionEnabled = false
        resultsTableView.register(TextCell.self, forCellReuseIdentifier: resultsTableCellIdentifier)
        resultsTableView.separatorStyle = .none
        resultsTableView.backgroundColor = .clear
        resultsTableView.isSpringLoaded = true
        resultsTableView.rowHeight = 50
        resultsTableView.estimatedSectionHeaderHeight = 0
        resultsTableView.estimatedSectionFooterHeight = 0
        resultsTableView.isScrollEnabled = true
        resultsTableView.bounces = true
        resultsTableView.alwaysBounceVertical = true
        resultsTableView.showsVerticalScrollIndicator = false
        resultsTableView.isUserInteractionEnabled = true
        resultsTableView.allowsSelection = true
//        resultsTableView.delaysContentTouches = false
        resultsTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        resultsTableView.insetsContentViewsToSafeArea = true
        resultsTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(resultsTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
}
