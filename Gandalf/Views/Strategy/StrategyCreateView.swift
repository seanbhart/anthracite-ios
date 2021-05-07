//
//  StrategyCreateView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/1/21.
//

import UIKit
import FirebaseAuth

protocol StrategyCreateViewDelegate {
    func createStrategy(strategy: Strategy)
}

class StrategyCreateView: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate, SearchViewDelegate, WindowPickerViewDelegate {
    let className = "StrategyCreateView"
    
    var delegate: StrategyCreateViewDelegate!
    var strategy: Strategy!
    var localStrategyOrders = [StrategyOrder]()
//    var strategyRepository: StrategyRepository!
    var windowTimer: Timer?
    
    var viewContainer: UIView!
    var windowLabel: UILabel!
    var windowButton: UIView!
    var windowButtonLabel: UILabel!
    var createButtonContainer: UIView!
    var createButton: UIView!
    var createButtonLabel: UILabel!
    var createContainerHeightConstraintNormal: NSLayoutConstraint!
    var createContainerHeightConstraintKeyboard: NSLayoutConstraint!
    var captionContainer: UIView!
    var captionTextView: UITextView!
    var captionLabel: UILabel!
    var strategyTableView: UITableView!
    let strategyTableCellIdentifier: String = "StrategyCreateCell"
    let strategyTableAddRowCellIdentifier: String = "StrategyCreateAddRowCell"
    
    private var observer: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Create Strategy"
        self.navigationItem.hidesBackButton = true
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        let barItemLogo = UIButton(type: .custom)
        barItemLogo.setImage(UIImage(named: Assets.Images.hatIconPurpleLg), for: .normal)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant: 30),
            barItemLogo.heightAnchor.constraint(equalToConstant: 30),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
        self.navigationItem.rightBarButtonItem = nil
        // For the children views:
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
//        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
//            print("\(className) - willEnterForegroundNotification")
//            guard let strategyRepo = strategyRepository else { return }
//            strategyRepo.observeQuery()
//        }
//        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
//            print("\(className) - didEnterBackgroundNotification")
//            guard let strategyRepo = strategyRepository else { return }
//            strategyRepo.stopObserving()
//        }
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
        NSLayoutConstraint.activate([
            createButtonContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
            createButtonContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            createButtonContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
//            createButtonContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            createButton.topAnchor.constraint(equalTo: createButtonContainer.topAnchor, constant: 10),
            createButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            createButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            createButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            createButtonLabel.topAnchor.constraint(equalTo: createButton.topAnchor, constant: 0),
            createButtonLabel.leftAnchor.constraint(equalTo: createButton.leftAnchor, constant: 0),
            createButtonLabel.rightAnchor.constraint(equalTo: createButton.rightAnchor, constant: 0),
            createButtonLabel.bottomAnchor.constraint(equalTo: createButton.bottomAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            captionContainer.bottomAnchor.constraint(equalTo: createButtonContainer.topAnchor, constant: 0),
            captionContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            captionContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            captionContainer.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            captionTextView.topAnchor.constraint(equalTo: captionContainer.topAnchor, constant: 10),
            captionTextView.leftAnchor.constraint(equalTo: captionContainer.leftAnchor, constant: 5),
            captionTextView.rightAnchor.constraint(equalTo: captionContainer.rightAnchor, constant: -5),
            captionTextView.bottomAnchor.constraint(equalTo: captionContainer.bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            captionLabel.topAnchor.constraint(equalTo: captionContainer.topAnchor, constant: 19),
            captionLabel.leftAnchor.constraint(equalTo: captionContainer.leftAnchor, constant: 10),
            captionLabel.rightAnchor.constraint(equalTo: captionContainer.rightAnchor, constant: -10),
            captionLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            strategyTableView.topAnchor.constraint(equalTo: windowButton.bottomAnchor, constant: 10),
            strategyTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            strategyTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            strategyTableView.bottomAnchor.constraint(equalTo: captionContainer.topAnchor, constant: 0),
        ])
        
        setConstraintsNormal()
        
//        if strategyRepository == nil {
//            strategyRepository = StrategyRepository()
////            strategyRepository.delegate = self
//        }
//        strategyRepository.observeQuery()
    }
    
    func setConstraintsNormal() {
        createContainerHeightConstraintKeyboard.isActive = false
        createContainerHeightConstraintNormal.isActive = true
        createButtonContainer.layoutIfNeeded()
    }
    func adjustConstraintsForKeyboard(keyboardHeight: CGFloat) {
        createContainerHeightConstraintKeyboard = createButtonContainer.heightAnchor.constraint(equalToConstant: keyboardHeight - view.safeAreaInsets.bottom)
        createContainerHeightConstraintNormal.isActive = false
        createContainerHeightConstraintKeyboard.isActive = true
        createButtonContainer.layoutIfNeeded()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
//        guard let strategyRepo = strategyRepository else { return }
//        strategyRepo.stopObserving()
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
        windowLabel.textColor = Settings.Theme.Color.primary
        windowLabel.textAlignment = NSTextAlignment.center
        windowLabel.numberOfLines = 1
        windowLabel.text = "OPPORTUNITY WINDOW"
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
        
        let windowButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(windowTap))
        windowButtonGestureRecognizer.numberOfTapsRequired = 1
        windowButton.addGestureRecognizer(windowButtonGestureRecognizer)
        
        windowButtonLabel = UILabel()
        windowButtonLabel.backgroundColor = .clear
        windowButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        windowButtonLabel.textColor = Settings.Theme.Color.primary
        windowButtonLabel.textAlignment = NSTextAlignment.center
        windowButtonLabel.numberOfLines = 1
        windowButtonLabel.text = "1 DAY"
        windowButtonLabel.isUserInteractionEnabled = false
        windowButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        windowButton.addSubview(windowButtonLabel)
        
        createButtonContainer = UIView()
        createButtonContainer.backgroundColor = Settings.Theme.Color.background
        createButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(createButtonContainer)
        
        createContainerHeightConstraintNormal = createButtonContainer.heightAnchor.constraint(equalToConstant: 80)
        createContainerHeightConstraintKeyboard = createButtonContainer.heightAnchor.constraint(equalToConstant: 80)
        
        createButton = UIView()
        createButton.backgroundColor = Settings.Theme.Color.primary
        createButton.layer.cornerRadius = 25
//        createButton.layer.borderWidth = 1
//        createButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        createButton.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(createButton)
        
        let createButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(createTap))
        createButtonGestureRecognizer.numberOfTapsRequired = 1
        createButton.addGestureRecognizer(createButtonGestureRecognizer)
        
        createButtonLabel = UILabel()
        createButtonLabel.backgroundColor = .clear
        createButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        createButtonLabel.textColor = Settings.Theme.Color.textGrayTrueDark
        createButtonLabel.textAlignment = NSTextAlignment.center
        createButtonLabel.numberOfLines = 1
        createButtonLabel.text = "CREATE"
        createButtonLabel.isUserInteractionEnabled = false
        createButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        createButton.addSubview(createButtonLabel)
        
        captionContainer = UIView()
        captionContainer.backgroundColor = Settings.Theme.Color.background
        captionContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(captionContainer)
        
        captionTextView = UITextView()
        captionTextView.delegate = self
        captionTextView.layer.cornerRadius = 5
        captionTextView.backgroundColor = Settings.Theme.Color.grayUltraDark
        captionTextView.isEditable = true
        captionTextView.isScrollEnabled = true
        captionTextView.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        captionTextView.textAlignment = .left
        captionTextView.textColor = Settings.Theme.Color.textGrayMedium
        captionTextView.autocorrectionType = UITextAutocorrectionType.yes
        captionTextView.keyboardType = UIKeyboardType.default
        captionTextView.returnKeyType = UIReturnKeyType.done
//        captionTextView.clearButtonMode = UITextField.ViewMode.whileEditing
        captionTextView.isUserInteractionEnabled = true
        captionTextView.translatesAutoresizingMaskIntoConstraints = false
        captionContainer.addSubview(captionTextView)
        
        captionLabel = UILabel()
        captionLabel.backgroundColor = .clear
        captionLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        captionLabel.textColor = Settings.Theme.Color.textGrayDark
        captionLabel.textAlignment = NSTextAlignment.left
        captionLabel.numberOfLines = 1
        captionLabel.text = "CAPTION"
        captionLabel.isUserInteractionEnabled = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        captionContainer.addSubview(captionLabel)
        
        strategyTableView = UITableView()
        strategyTableView.dataSource = self
        strategyTableView.delegate = self
        strategyTableView.dragInteractionEnabled = false
        strategyTableView.register(StrategyCreateCell.self, forCellReuseIdentifier: strategyTableCellIdentifier)
        strategyTableView.register(StrategyCreateAddRowCell.self, forCellReuseIdentifier: strategyTableAddRowCellIdentifier)
        strategyTableView.separatorStyle = .none
        strategyTableView.backgroundColor = .clear
        strategyTableView.isSpringLoaded = true
        strategyTableView.rowHeight = UITableView.automaticDimension
        strategyTableView.estimatedRowHeight = UITableView.automaticDimension
//        strategyTableView.estimatedRowHeight = 0
        strategyTableView.estimatedSectionHeaderHeight = 0
        strategyTableView.estimatedSectionFooterHeight = 0
        strategyTableView.isScrollEnabled = true
        strategyTableView.bounces = true
        strategyTableView.alwaysBounceVertical = true
        strategyTableView.showsVerticalScrollIndicator = false
        strategyTableView.isUserInteractionEnabled = true
        strategyTableView.allowsSelection = true
//        strategyTableView.delaysContentTouches = false
        strategyTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        strategyTableView.insetsContentViewsToSafeArea = true
        strategyTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(strategyTableView)
        
        // Create a default StrategyOrder to start
        let defaultStrategyOrder = StrategyOrder(direction: 1, predictPriceDirection: 1, type: 0)
        localStrategyOrders.append(defaultStrategyOrder)
        
        // Instantiate the Strategy object and start the window timer with the default 1 day period
        guard let firUser = Settings.Firebase.auth().currentUser else { self.navigationController?.popViewController(animated: true); return }
        let defaultExpiration = Date().timeIntervalSince1970 + Double(86400)
        strategy = Strategy(creator: firUser.uid, windowExpiration: defaultExpiration * 1000)
        windowTimer?.invalidate()
        windowTimer = nil
        configureWindowTimer(expiration: defaultExpiration)
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        windowTimer?.invalidate()
//        windowTimer = nil
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let info = notification.userInfo else { return }
        guard let frameInfo = info[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardFrame = frameInfo.cgRectValue
        adjustConstraintsForKeyboard(keyboardHeight: keyboardFrame.height)
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func createTap(_ sender: UITapGestureRecognizer) {
        guard let parent = self.delegate else { return }
        strategy.orders = localStrategyOrders
        parent.createStrategy(strategy: strategy)
    }
    
    
    // MARK: -TEXT FIELD DELEGATE METHODS
//    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        print("\(className) - textViewShouldEndEditing")
//        return true
//    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView == captionTextView && text == "\n" {
            textView.resignFirstResponder()
            setConstraintsNormal()
            return false
        }
        return true
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView == captionTextView {
            strategy.caption = textView.text
            
            if textView.text == "" {
                captionLabel.isHidden = false
            } else {
                captionLabel.isHidden = true
            }
        }
    }
    
    
    // Set a timer to recalculate the opportunity window remaining every second
    // Both time intervals should be in seconds - milliseconds are not displayed
    func configureWindowTimer(expiration: TimeInterval) {
        if self.windowTimer == nil {
            self.windowTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                let timeRemaining = self.calculateTimeRemaining(expiration: expiration)
                if timeRemaining <= 0 {
                    self.windowButtonLabel.text = "EXPIRED"
                } else {
                    self.windowButtonLabel.text = Strategy.secondsRemainToString(seconds: Int(timeRemaining))
                }
            }
        }
    }
    private func calculateTimeRemaining(expiration: TimeInterval) -> Double {
        return Double(expiration - Date().timeIntervalSince1970)
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func windowTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - selectOrderSymbol")
        let windowPickerView = WindowPickerView()
        windowPickerView.delegate = self
        self.navigationController?.pushViewController(windowPickerView, animated: true)
    }
    
    
    // MARK: -SEARCH VIEW DELEGATE METHODS
    
    func searchViewSelected(selection: String) {
        print("\(className) - searchViewSelected: \(selection)")
        windowButtonLabel.text = selection
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK: -WINDOW PICKER VIEW DELEGATE METHODS
    
    func window(expiration: TimeInterval) {
        print("\(className) - windowExpiration: \(expiration)")
        strategy.windowExpiration = expiration * 1000
        windowTimer?.invalidate()
        windowTimer = nil
        configureWindowTimer(expiration: expiration)
        self.navigationController?.popViewController(animated: true)
    }
}
