//
//  SearchSymbolView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
import FirebaseAuth

protocol SearchSymbolViewDelegate {
    func selected(orderIndex: Int, symbol: String, predictDirection: Int)
}

class SearchSymbolView: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate, SymbolRepositoryDelegate {
    let className = "SearchSymbolView"
    
    var delegate: SearchSymbolViewDelegate!
    var localSymbols = [Symbol]()
    var symbolRepository: SymbolRepository!
    var orderIndex: Int!
    var selectedSymbol: String = ""
    var selectedDirection: Int = 1
    
    var viewContainer: UIView!
    var directionLabel: UILabel!
    var directionButton: UIView!
    var directionButtonLabel: UILabel!
    var searchContainer: UIView!
    var searchIcon: UIImageView!
    var searchField: UITextField!
    var symbolTableView: UITableView!
    let symbolTableCellIdentifier: String = "SymbolCell"
    var saveContainer: UIView!
    var saveContainerHeightConstraintNormal: NSLayoutConstraint!
    var saveContainerHeightConstraintKeyboard: NSLayoutConstraint!
    var saveButton: UIView!
    var saveButtonLabel: UILabel!
    
    private var observer: NSObjectProtocol?
    
    init(symbol: String?, direction: Int?) {
        self.selectedSymbol = symbol != nil ? symbol! :  ""
        self.selectedDirection = direction != nil ? direction! :  1
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Select Symbol"
        self.navigationItem.hidesBackButton = false
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.rightBarButtonItem = nil
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let symbolRepo = symbolRepository else { return }
            symbolRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let symbolRepo = symbolRepository else { return }
            symbolRepo.stopObserving()
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
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            directionLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            directionLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            directionLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            directionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            directionButton.topAnchor.constraint(equalTo: directionLabel.bottomAnchor, constant: 0),
            directionButton.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            directionButton.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            directionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            directionButtonLabel.topAnchor.constraint(equalTo: directionButton.topAnchor, constant: 0),
            directionButtonLabel.leftAnchor.constraint(equalTo: directionButton.leftAnchor, constant: 0),
            directionButtonLabel.rightAnchor.constraint(equalTo: directionButton.rightAnchor, constant: 0),
            directionButtonLabel.bottomAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 0),
        ])
        NSLayoutConstraint.activate([
            searchContainer.topAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 10),
            searchContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 10),
            searchContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            searchContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            searchIcon.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 0),
            searchIcon.leftAnchor.constraint(equalTo: searchContainer.leftAnchor, constant: 10),
            searchIcon.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 0),
            searchIcon.widthAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 0),
            searchField.leftAnchor.constraint(equalTo: searchIcon.rightAnchor, constant: 10),
            searchField.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 0),
            searchField.rightAnchor.constraint(equalTo: searchContainer.rightAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            saveContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
            saveContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            saveContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
        ])
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: saveContainer.topAnchor, constant: 10),
            saveButton.leftAnchor.constraint(equalTo: saveContainer.leftAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: saveContainer.rightAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            saveButtonLabel.topAnchor.constraint(equalTo: saveButton.topAnchor),
            saveButtonLabel.leftAnchor.constraint(equalTo: saveButton.leftAnchor),
            saveButtonLabel.rightAnchor.constraint(equalTo: saveButton.rightAnchor),
            saveButtonLabel.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            symbolTableView.topAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: 10),
            symbolTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            symbolTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            symbolTableView.bottomAnchor.constraint(equalTo: saveContainer.topAnchor),
        ])
        
        setConstraintsNormal()
        
        if symbolRepository == nil {
            symbolRepository = SymbolRepository()
            symbolRepository.delegate = self
        }
        symbolRepository.observeQuery()
    }
    
    func setConstraintsNormal() {
        saveContainerHeightConstraintKeyboard.isActive = false
        saveContainerHeightConstraintNormal.isActive = true
        saveContainer.layoutIfNeeded()
    }
    func adjustConstraintsForKeyboard(keyboardHeight: CGFloat) {
        saveContainerHeightConstraintKeyboard = saveContainer.heightAnchor.constraint(equalToConstant: keyboardHeight - view.safeAreaInsets.bottom)
        saveContainerHeightConstraintNormal.isActive = false
        saveContainerHeightConstraintKeyboard.isActive = true
        saveContainer.layoutIfNeeded()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        guard let symbolRepo = symbolRepository else { return }
        symbolRepo.stopObserving()
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
        
        directionLabel = UILabel()
        directionLabel.backgroundColor = .clear
        directionLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 18)
        directionLabel.textColor = Settings.Theme.Color.textGrayMedium
        directionLabel.textAlignment = NSTextAlignment.center
        directionLabel.numberOfLines = 1
        directionLabel.text = "PREDICTION"
        directionLabel.isUserInteractionEnabled = false
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(directionLabel)
        
        directionButton = UIView()
        directionButton.backgroundColor = Settings.Theme.Color.background
        directionButton.layer.cornerRadius = 25
        directionButton.layer.borderWidth = 1
        directionButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(directionButton)
        
        let directionButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(directionTap))
        directionButtonGestureRecognizer.numberOfTapsRequired = 1
        directionButton.addGestureRecognizer(directionButtonGestureRecognizer)
        
        directionButtonLabel = UILabel()
        directionButtonLabel.backgroundColor = .clear
        directionButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        directionButtonLabel.textAlignment = NSTextAlignment.center
        directionButtonLabel.numberOfLines = 1
        directionButtonLabel.isUserInteractionEnabled = false
        directionButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        directionButton.addSubview(directionButtonLabel)
        
        searchContainer = UIView()
        searchContainer.backgroundColor = Settings.Theme.Color.contentBackground
        searchContainer.layer.cornerRadius = 5
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(searchContainer)
        
        searchIcon = UIImageView()
        searchIcon.image = UIImage(systemName: "magnifyingglass")?.withTintColor(Settings.Theme.Color.textGrayDark, renderingMode: .alwaysOriginal)
        searchIcon.contentMode = UIView.ContentMode.scaleAspectFit
        searchIcon.clipsToBounds = true
        searchIcon.isUserInteractionEnabled = true
        searchIcon.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchIcon)
        
        searchField = UITextField()
        searchField.delegate = self
        searchField.placeholder = "SYMBOL"
        searchField.text = selectedSymbol
        searchField.font = UIFont(name: Assets.Fonts.Default.bold, size: 24)
        searchField.textColor = Settings.Theme.Color.textGrayDark
        searchField.autocorrectionType = UITextAutocorrectionType.no
        searchField.keyboardType = UIKeyboardType.default
        searchField.returnKeyType = UIReturnKeyType.done
        searchField.clearButtonMode = UITextField.ViewMode.whileEditing
        searchField.autocapitalizationType = .allCharacters
        searchField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        searchField.isUserInteractionEnabled = true
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchContainer.addSubview(searchField)
        
        saveContainer = UIView()
        saveContainer.backgroundColor = Settings.Theme.Color.background
        saveContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(saveContainer)
        
        saveContainerHeightConstraintNormal = saveContainer.heightAnchor.constraint(equalToConstant: 80)
        saveContainerHeightConstraintKeyboard = saveContainer.heightAnchor.constraint(equalToConstant: 80)
        
        saveButton = UIView()
        saveButton.layer.cornerRadius = 25
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveContainer.addSubview(saveButton)
        
        let saveButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(saveTap))
        saveButtonGestureRecognizer.numberOfTapsRequired = 1
        saveButton.addGestureRecognizer(saveButtonGestureRecognizer)
        
        saveButtonLabel = UILabel()
        saveButtonLabel.backgroundColor = .clear
        saveButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        saveButtonLabel.textColor = Settings.Theme.Color.textGrayTrueDark
        saveButtonLabel.textAlignment = NSTextAlignment.center
        saveButtonLabel.numberOfLines = 1
        saveButtonLabel.text = "SAVE"
        saveButtonLabel.isUserInteractionEnabled = false
        saveButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addSubview(saveButtonLabel)
        
        symbolTableView = UITableView()
        symbolTableView.dataSource = self
        symbolTableView.delegate = self
        symbolTableView.dragInteractionEnabled = false
        symbolTableView.register(SymbolCell.self, forCellReuseIdentifier: symbolTableCellIdentifier)
        symbolTableView.separatorStyle = .none
        symbolTableView.backgroundColor = .clear
        symbolTableView.isSpringLoaded = true
        symbolTableView.rowHeight = 50
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
        
        if (selectedDirection == 0) {
            setDirectionDecrease(symbol: selectedSymbol)
        } else {
            setDirectionIncrease(symbol: selectedSymbol)
        }
    }
    
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
    
    
    func setDirectionIncrease(symbol: String) {
        selectedDirection = 1
        directionButtonLabel.textColor = Settings.Theme.Color.positive
        directionButtonLabel.text = "\(symbol) PRICE INCREASE"
        saveButton.backgroundColor = Settings.Theme.Color.positive
    }
    func setDirectionDecrease(symbol: String) {
        selectedDirection = 0
        directionButtonLabel.textColor = Settings.Theme.Color.negative
        directionButtonLabel.text = "\(symbol) PRICE DECREASE"
        saveButton.backgroundColor = Settings.Theme.Color.negative
    }
    func updateSymbol(symbol: String) {
        selectedSymbol = symbol
        if selectedDirection == 0 {
            setDirectionDecrease(symbol: symbol)
        } else {
            setDirectionIncrease(symbol: symbol)
        }
    }
    
    
    // MARK: -TEXT FIELD DELEGATE METHODS
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("\(className) - textFieldShouldReturn")
        if textField == searchField {
            textField.resignFirstResponder()
            setConstraintsNormal()
            return false
        }
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        print("\(className) - textFieldDidChangeSelection")
        if textField == searchField {
            guard let searchText = textField.text else { return }
            print("\(className) - textFieldDidEndEditing searchText: \(searchText)")
            localSymbols.removeAll()
            if searchText == "" {
                localSymbols = symbolRepository.symbols
            } else {
                localSymbols = symbolRepository.symbols.filter { symbol in
                    return symbol.symbol.contains(searchText)
                }
            }
            symbolTableView.reloadData()
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("\(className) - textFieldDidBeginEditing")
        
        // Adjust the view to ensure the tableview is above the keyboard
        
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func directionTap(_ sender: UIBarButtonItem) {
        print("\(className) - directionTap")
        if selectedDirection == 1 {
            setDirectionDecrease(symbol: selectedSymbol)
        } else {
            setDirectionIncrease(symbol: selectedSymbol)
        }
    }
    @objc func saveTap(_ sender: UIBarButtonItem) {
        if selectedSymbol == "" { return }
        if let parent = self.delegate {
            parent.selected(orderIndex: orderIndex, symbol: selectedSymbol, predictDirection: selectedDirection)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    // MARK: -SYMBOL REPO METHODS
    
    func symbolDataUpdate() {
        print("\(className) - symbolDataUpdate: symbolRepository.symbols count: \(symbolRepository.symbols.count)")
        localSymbols.removeAll()
        localSymbols = symbolRepository.symbols
        print("\(className) - symbolDataUpdate: localSymbols count: \(localSymbols.count)")
        symbolTableView.reloadData()
    }
    
    func showLogin() {
        print("\(className) - showLogin")
    }
}
