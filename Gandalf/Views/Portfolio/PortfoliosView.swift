//
//  TradeView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/15/21.
//

import UIKit
import FirebaseAuth

class PortfoliosView: UIViewController, UIGestureRecognizerDelegate, AccountSummaryRepositoryDelegate {
    let className = "PortfoliosView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var portfolioRepository: PortfolioRepository?
    
    var viewContainer: UIView!
    var tickerLabel: UILabel!
    var positionLabel: UILabel!
    var valueLabel: UILabel!
    
    private var observer: NSObjectProtocol?
    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        
//        let barItemLogo = UIButton(type: .custom)
//        barItemLogo.setImage(UIImage(named: Assets.Images.logotypeLg), for: .normal)
//        NSLayoutConstraint.activate([
//            barItemLogo.widthAnchor.constraint(equalToConstant:110),
//            barItemLogo.heightAnchor.constraint(equalToConstant:20),
//        ])
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let accountsRepo = accountsRepository else { return }
            accountsRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let accountsRepo = accountsRepository else { return }
            accountsRepo.stopObserving()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
            tickerLabel.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            tickerLabel.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            tickerLabel.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            tickerLabel.heightAnchor.constraint(equalTo:viewContainer.heightAnchor, constant: 50),
        ])
        
        if accountsRepository == nil {
            accountsRepository = AccountSummaryRepository()
            accountsRepository!.delegate = self
        }
        accountsRepository!.observeQuery()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Show the tutorial if it has not been viewed by the current user
//        if let accountRepo = AccountRepository() {
//            accountRepo.getAccount()
//            guard let account = accountRepo.account else { self.showTutorial(); return }
//            guard let metadata = account.metadata else { self.showTutorial(); return }
//            guard let tutorials = metadata.tutorials else { self.showTutorial(); return }
//            if (tutorials.firstIndex(of: Settings.currentTutorial + "-" + className) == nil) {
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
        
        tickerLabel = UILabel()
        tickerLabel.backgroundColor = Settings.Theme.Color.contentBackground
        tickerLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        tickerLabel.textColor = Settings.Theme.Color.text
        tickerLabel.textAlignment = NSTextAlignment.center
        tickerLabel.numberOfLines = 1
        tickerLabel.text = ""
        tickerLabel.isUserInteractionEnabled = false
        tickerLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(tickerLabel)
        
        let tickerLabelGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(tickerLabelTap))
        tickerLabelGestureRecognizer.delegate = self
        tickerLabelGestureRecognizer.numberOfTapsRequired = 1
        tickerLabel.addGestureRecognizer(tickerLabelGestureRecognizer)
        
        positionLabel = UILabel()
        positionLabel.backgroundColor = Settings.Theme.Color.contentBackground
        positionLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        positionLabel.textColor = Settings.Theme.Color.text
        positionLabel.textAlignment = NSTextAlignment.center
        positionLabel.numberOfLines = 1
        positionLabel.text = ""
        positionLabel.isUserInteractionEnabled = false
        positionLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(positionLabel)
        
        valueLabel = UILabel()
        valueLabel.backgroundColor = Settings.Theme.Color.contentBackground
        valueLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        valueLabel.textColor = Settings.Theme.Color.text
        valueLabel.textAlignment = NSTextAlignment.center
        valueLabel.numberOfLines = 1
        valueLabel.text = ""
        valueLabel.isUserInteractionEnabled = true
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(valueLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
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
    
    
    // MARK: -GESTURE METHODS
    
    @objc func tickerLabelTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - tickerLabelTap")
    }
    
    
    // MARK: -AccountSummary Delegate
    
    func accountsDataUpdate() {
        print("\(className) - accountsDataUpdate")
    }
    
    func showLogin() {
        print("\(className) - showLogin")
    }
}

