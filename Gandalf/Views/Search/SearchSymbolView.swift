//
//  SearchSymbolView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
import FirebaseAuth

protocol SearchSymbolViewDelegate {
    func selected(symbol: String, windowSecs: Int)
}

class SearchSymbolView: UIViewController, UIGestureRecognizerDelegate {
    let className = "SearchSymbolView"
    
    var delegate: SearchSymbolViewDelegate!
    var localStrategies = [Ticker]()
//    var strategyRepository: StrategyRepository!
    var selectedSymbol: String?
    var selectedWindowSecs: Int?
    
    var viewContainer: UIView!
    var windowLabel: UILabel!
    var windowButton: UIView!
    var windowButtonLabel: UILabel!
    var symbolTableView: UITableView!
    let symbolTableCellIdentifier: String = "SymbolCell"
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Select Symbol"
        self.navigationItem.hidesBackButton = false
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveTap))
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
            windowLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            windowLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            windowLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            windowLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            windowButton.topAnchor.constraint(equalTo: windowLabel.bottomAnchor, constant: 0),
            windowButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            windowButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            windowButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            windowButtonLabel.topAnchor.constraint(equalTo: windowButton.topAnchor, constant: 0),
            windowButtonLabel.leftAnchor.constraint(equalTo: windowButton.leftAnchor, constant: 0),
            windowButtonLabel.rightAnchor.constraint(equalTo: windowButton.rightAnchor, constant: 0),
            windowButtonLabel.bottomAnchor.constraint(equalTo: windowButton.bottomAnchor, constant: 0),
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
        
        windowLabel = UILabel()
        windowLabel.backgroundColor = .clear
        windowLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 18)
        windowLabel.textColor = Settings.Theme.Color.textGrayMedium
        windowLabel.textAlignment = NSTextAlignment.center
        windowLabel.numberOfLines = 1
        windowLabel.text = "PRICE PREDICTION"
        windowLabel.isUserInteractionEnabled = false
        windowLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(windowLabel)
        
        windowButton = UIView()
        windowButton.backgroundColor = Settings.Theme.Color.background
        windowButton.layer.cornerRadius = 25
        windowButton.layer.borderWidth = 1
        windowButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        windowButton.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(windowButton)
        
        windowButtonLabel = UILabel()
        windowButtonLabel.backgroundColor = .clear
        windowButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        windowButtonLabel.textColor = Settings.Theme.Color.positive
        windowButtonLabel.textAlignment = NSTextAlignment.center
        windowButtonLabel.numberOfLines = 1
        windowButtonLabel.text = "INCREASE"
        windowButtonLabel.isUserInteractionEnabled = false
        windowButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        windowButton.addSubview(windowButtonLabel)
        
        symbolTableView = UITableView()
        symbolTableView.dataSource = self
        symbolTableView.delegate = self
        symbolTableView.dragInteractionEnabled = false
        symbolTableView.register(SymbolCell.self, forCellReuseIdentifier: symbolTableCellIdentifier)
        symbolTableView.separatorStyle = .none
        symbolTableView.backgroundColor = .clear
        symbolTableView.isSpringLoaded = true
        symbolTableView.rowHeight = UITableView.automaticDimension
        symbolTableView.estimatedRowHeight = UITableView.automaticDimension
//        symbolTableView.estimatedRowHeight = 0
        symbolTableView.estimatedSectionHeaderHeight = 0
        symbolTableView.estimatedSectionFooterHeight = 0
        symbolTableView.isScrollEnabled = true
        symbolTableView.bounces = true
        symbolTableView.alwaysBounceVertical = true
        symbolTableView.showsVerticalScrollIndicator = false
        symbolTableView.isUserInteractionEnabled = true
        symbolTableView.allowsSelection = true
//        symbolTableView.delaysContentTouches = false
        symbolTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        symbolTableView.insetsContentViewsToSafeArea = true
        symbolTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(symbolTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func saveTap(_ sender: UIBarButtonItem) {
        print("\(className) - saveTap")
        guard let symbol = selectedSymbol else { return }
        guard let windowSecs = selectedWindowSecs else { return }
        
        if let parent = self.delegate {
            parent.selected(symbol: symbol, windowSecs: windowSecs)
        }
    }
}
