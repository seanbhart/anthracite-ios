//
//  AccountView.swift
//  Gandalf
//
//  Created by Sean Hart on 1/28/21.
//

//import PassKit
import AuthenticationServices
import CryptoKit
import UIKit
//import FirebaseAnalytics
import FirebaseAuth

protocol AccountPrivateViewDelegate {
    func strategyReaction(strategyId: String, type: Int)
}

class AccountPrivateView: UIViewController, AccountPrivateRepositoryDelegate, AccountEditViewDelegate {
    let className = "AccountPrivateView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var delegate: AccountPrivateViewDelegate!
    var accountPrivateRepository: AccountPrivateRepository?
//    var accountStrategyRepository: AccountStrategyRepository?
    var localStrategies = [Strategy]()
    var detailView: StrategyDetailView?
    
    // Unhashed nonce - handle locally (not in Account) for security
    fileprivate var currentNonce: String?
    var controller: ASAuthorizationController!
    
    var signInContainer: UIView!
    var signInButton: ASAuthorizationAppleIDButton!
    
    var viewContainer: UIView!
    var buttonContainer: UIView!
    var buttonContainerGestureRecognizer: UITapGestureRecognizer!
    var buttonLabel: UILabel!
    var accountImageContainer: UIView!
    var accountImageBackground: UIView!
    var accountImage: UIImageView!
    var nameLabel: UILabel!
    var connectionsIcon: UIImageView!
    var connectionsLabel: UILabel!
    var bioField: UITextView!
    var locationIcon: UIImageView!
    var locationLabel: UILabel!
    var joinedIcon: UIImageView!
    var joinedLabel: UILabel!
    var strategyTableView: UITableView!
    let strategyTableCellIdentifier: String = "StrategyCell"
    
    private var observer: NSObjectProtocol?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    func setupRepo() {
//        guard let accountRepo = accountRepository else { return }
//        accountRepo.delegate = self
//        accountRepo.observeDoc()
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
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
        
        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - willEnterForegroundNotification")
            guard let accountRepo = accountPrivateRepository else { return }
            accountRepo.observeDoc()
//            guard let accountStrategyRepo = accountStrategyRepository else { return }
//            accountStrategyRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let accountRepo = accountPrivateRepository else { return }
            accountRepo.stopObserving()
//            guard let accountStrategyRepo = accountStrategyRepository else { return }
//            accountStrategyRepo.stopObserving()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the navigation bar is not hidden
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
//        layoutSignInComponents()
//        layoutAccountComponents()
        
        if accountPrivateRepository == nil {
            accountPrivateRepository = AccountPrivateRepository()
            accountPrivateRepository!.delegate = self
        }
        accountPrivateRepository!.observeDoc()
        
//        if accountStrategyRepository == nil {
//            accountStrategyRepository = AccountStrategyRepository(accountId: accountId)
//            accountStrategyRepository!.delegate = self
//        }
//        accountStrategyRepository!.observeQuery()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        guard let accountRepo = accountPrivateRepository else { return }
        accountRepo.stopObserving()
//        guard let accountStrategyRepo = accountStrategyRepository else { return }
//        accountStrategyRepo.stopObserving()
    }

    override func loadView() {
        super.loadView()
        print("\(self.className) - loadView")
        
        // Make the overall background black to fill any unfilled areas
        view.backgroundColor = Settings.Theme.Color.background
        
        signInContainer = UIView()
        signInContainer.backgroundColor = Settings.Theme.Color.background
        signInContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInContainer)
        
        signInButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        signInButton.cornerRadius = 2
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(AccountPrivateView.signInTap(_:)), for: .touchUpInside)
        signInContainer.addSubview(signInButton)
        
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        accountImageContainer = UIView()
        accountImageContainer.layer.cornerRadius = 60
        accountImageContainer.backgroundColor = Settings.Theme.Color.outline
        accountImageContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(accountImageContainer)
        
        accountImageBackground = UIView()
        accountImageBackground.layer.cornerRadius = 58
        accountImageBackground.backgroundColor = Settings.Theme.Color.grayTrueDark
        accountImageBackground.translatesAutoresizingMaskIntoConstraints = false
        accountImageContainer.addSubview(accountImageBackground)
        
        accountImage = UIImageView()
        accountImage.layer.cornerRadius = 58
//        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.background, renderingMode: .alwaysOriginal)
        accountImage.contentMode = UIView.ContentMode.scaleAspectFit
        accountImage.clipsToBounds = true
        accountImage.isUserInteractionEnabled = true
        accountImage.translatesAutoresizingMaskIntoConstraints = false
        accountImageContainer.addSubview(accountImage)
        
        nameLabel = UILabel()
//        nameLabel.backgroundColor = .blue
        nameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 21)
        nameLabel.textColor = Settings.Theme.Color.textGrayLight
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.text = ""
        nameLabel.isUserInteractionEnabled = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(nameLabel)
        
        connectionsIcon = UIImageView()
        connectionsIcon.image = UIImage(systemName: "figure.stand.line.dotted.figure.stand")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        connectionsIcon.contentMode = UIView.ContentMode.scaleAspectFit
        connectionsIcon.clipsToBounds = true
        connectionsIcon.isUserInteractionEnabled = true
        connectionsIcon.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(connectionsIcon)
        
        connectionsLabel = UILabel()
        connectionsLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 16)
        connectionsLabel.textColor = Settings.Theme.Color.textGrayMedium
        connectionsLabel.textAlignment = NSTextAlignment.left
        connectionsLabel.numberOfLines = 1
        connectionsLabel.text = "5,294"
        connectionsLabel.isUserInteractionEnabled = false
        connectionsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(connectionsLabel)
        
        bioField = UITextView()
        bioField.backgroundColor = .clear
        bioField.isEditable = false
        bioField.isScrollEnabled = false
        bioField.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        bioField.textAlignment = .left
        bioField.textColor = Settings.Theme.Color.textGrayMedium
        bioField.text = "A imperdiet metus, malesuada sem quis ut. Cum scelerisque ac tortor, cras odio porttitor nisl commodo pharetra."
        bioField.sizeToFit()
        bioField.isUserInteractionEnabled = false
        bioField.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(bioField)
        
        locationIcon = UIImageView()
        locationIcon.image = UIImage(systemName: "map")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        locationIcon.contentMode = UIView.ContentMode.scaleAspectFit
        locationIcon.clipsToBounds = true
        locationIcon.isUserInteractionEnabled = true
        locationIcon.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(locationIcon)
        
        locationLabel = UILabel()
        locationLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 10)
        locationLabel.textColor = Settings.Theme.Color.textGrayMedium
        locationLabel.textAlignment = NSTextAlignment.left
        locationLabel.numberOfLines = 1
        locationLabel.text = "San Fransisco, CA"
        locationLabel.isUserInteractionEnabled = false
        locationLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(locationLabel)
        
        joinedIcon = UIImageView()
        joinedIcon.image = UIImage(systemName: "calendar")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        joinedIcon.contentMode = UIView.ContentMode.scaleAspectFit
        joinedIcon.clipsToBounds = true
        joinedIcon.isUserInteractionEnabled = true
        joinedIcon.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(joinedIcon)
        
        joinedLabel = UILabel()
        joinedLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 10)
        joinedLabel.textColor = Settings.Theme.Color.textGrayMedium
        joinedLabel.textAlignment = NSTextAlignment.left
        joinedLabel.numberOfLines = 1
        joinedLabel.text = "Jan 2021"
        joinedLabel.isUserInteractionEnabled = false
        joinedLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(joinedLabel)
        
        buttonContainer = UIView()
        buttonContainer.layer.borderWidth = 1
        buttonContainer.layer.cornerRadius = 5
        buttonContainer.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(buttonContainer)
        
        let settingsIconContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(buttonTap))
        settingsIconContainerGestureRecognizer.numberOfTapsRequired = 1
        buttonContainer.addGestureRecognizer(settingsIconContainerGestureRecognizer)
        
        buttonLabel = UILabel()
        buttonLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        buttonLabel.textColor = Settings.Theme.Color.secondary
        buttonLabel.textAlignment = NSTextAlignment.center
        buttonLabel.numberOfLines = 1
        buttonLabel.text = "EDIT PROFILE"
        buttonLabel.isUserInteractionEnabled = false
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(buttonLabel)
        
        strategyTableView = UITableView()
        strategyTableView.dataSource = self
        strategyTableView.delegate = self
        strategyTableView.dragInteractionEnabled = false
        strategyTableView.register(StrategyCell.self, forCellReuseIdentifier: strategyTableCellIdentifier)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    func layoutSignInComponents() {
        NSLayoutConstraint.activate([
            signInContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            signInContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            signInContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            signInContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo: signInContainer.centerYAnchor),
            signInButton.centerXAnchor.constraint(equalTo: signInContainer.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant: 280),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    func layoutAccountComponents() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            accountImageContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20),
            accountImageContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            accountImageContainer.heightAnchor.constraint(equalToConstant: 120),
            accountImageContainer.widthAnchor.constraint(equalToConstant: 120),
        ])
        NSLayoutConstraint.activate([
            accountImageBackground.centerYAnchor.constraint(equalTo: accountImageContainer.centerYAnchor),
            accountImageBackground.centerXAnchor.constraint(equalTo: accountImageContainer.centerXAnchor),
            accountImageBackground.heightAnchor.constraint(equalToConstant: 116),
            accountImageBackground.widthAnchor.constraint(equalToConstant: 116),
        ])
        NSLayoutConstraint.activate([
            accountImage.centerYAnchor.constraint(equalTo: accountImageContainer.centerYAnchor),
            accountImage.centerXAnchor.constraint(equalTo: accountImageContainer.centerXAnchor),
            accountImage.heightAnchor.constraint(equalToConstant: 116),
            accountImage.widthAnchor.constraint(equalToConstant: 116),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: accountImageContainer.rightAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            connectionsIcon.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            connectionsIcon.leftAnchor.constraint(equalTo: accountImageContainer.rightAnchor, constant: 20),
            connectionsIcon.widthAnchor.constraint(equalToConstant: 24),
            connectionsIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            connectionsLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            connectionsLabel.leftAnchor.constraint(equalTo: connectionsIcon.rightAnchor, constant: 5),
            connectionsLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            connectionsLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            bioField.topAnchor.constraint(equalTo: connectionsIcon.bottomAnchor, constant: 5),
            bioField.leftAnchor.constraint(equalTo: accountImageContainer.rightAnchor, constant: 15),
            bioField.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
//            bioField.heightAnchor.constraint(equalToConstant: 60),
        ])
        NSLayoutConstraint.activate([
            locationIcon.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 5),
            locationIcon.leftAnchor.constraint(equalTo: bioField.leftAnchor, constant: 0),
            locationIcon.widthAnchor.constraint(equalToConstant: 24),
            locationIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            locationLabel.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 5),
            locationLabel.leftAnchor.constraint(equalTo: locationIcon.rightAnchor, constant: 5),
            locationLabel.widthAnchor.constraint(equalToConstant: 100),
            locationLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            joinedIcon.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 5),
            joinedIcon.leftAnchor.constraint(equalTo: locationLabel.rightAnchor, constant: 10),
            joinedIcon.widthAnchor.constraint(equalToConstant: 24),
            joinedIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        NSLayoutConstraint.activate([
            joinedLabel.topAnchor.constraint(equalTo: bioField.bottomAnchor, constant: 5),
            joinedLabel.leftAnchor.constraint(equalTo: joinedIcon.rightAnchor, constant: 5),
            joinedLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            joinedLabel.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        NSLayoutConstraint.activate([
            buttonContainer.topAnchor.constraint(equalTo: locationIcon.bottomAnchor, constant: 20),
            buttonContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            buttonContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            buttonContainer.heightAnchor.constraint(equalToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            buttonLabel.topAnchor.constraint(equalTo: buttonContainer.topAnchor),
            buttonLabel.leftAnchor.constraint(equalTo: buttonContainer.leftAnchor),
            buttonLabel.rightAnchor.constraint(equalTo: buttonContainer.rightAnchor),
            buttonLabel.bottomAnchor.constraint(equalTo: buttonContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            strategyTableView.topAnchor.constraint(equalTo: buttonContainer.bottomAnchor, constant: 10),
            strategyTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            strategyTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            strategyTableView.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor),
        ])
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func signInTap(_ sender: UITapGestureRecognizer) {
        let nonce = randomNonceString()
        currentNonce = nonce
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    @objc func buttonTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - buttonTap")
        guard let accountRepo = accountPrivateRepository else { return }
        // Present the account edit sheet via a modal view
        let accountEditView: AccountEditView = AccountEditView(accountRepo: accountRepo)
        accountEditView.delegate = self
        self.presentSheet(with: accountEditView)
    }
    
    
    // MARK: -REPO METHODS
    
    func accountPrivateDataUpdate() {
        print("\(className) - accountDataUpdate")
        guard let accountRepo = accountPrivateRepository else { return }
        if let account = accountRepo.account {
            // If the username is empty, use the known account name
            if let username = account.username {
                self.navigationItem.title = "@" + username
            }
            
            if let name = account.name {
                nameLabel.text = name
            } else if let username = account.username {
                nameLabel.text = username
            } else {
                nameLabel.text = "anonymous"
            }
//            nameLabel.sizeToFit()
            nameLabel.layoutIfNeeded()
            accountImage.image = account.image
            
            layoutAccountComponents()

            // Show the account info if the user is signed in
            self.hideSignIn()
        }
    }
    
    func requestError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    // MARK: -DATA METHODS
    
    func updateStrategies(strategies: [Strategy]) {
        // The passed strategies have all users from the main feed. Filter for the passed account.
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        let filteredStrategies = strategies.filter { $0.creator == firUser.uid }
        localStrategies.removeAll()
        localStrategies = filteredStrategies
        if strategyTableView != nil {
            strategyTableView.reloadData()
            updateDetailViewStrategy()
        }
    }
    
    func updateStrategyReactions(reactions: [StrategyReaction]) {
        // The passed strategies have all users from the main feed. Filter for the passed account
        // to reduce the time needed for matching reactions to stratgies.
        guard let firUser = Settings.Firebase.auth().currentUser else { return }
        let filteredReactions = reactions.filter { $0.creator == firUser.uid }
        
        for (i, s) in localStrategies.enumerated() {
            localStrategies[i].reactions = filteredReactions.filter { return $0.strategy == s.id }
        }
        if strategyTableView != nil {
            strategyTableView.reloadData()
            updateDetailViewStrategy()
        }
    }
    
    func updateDetailViewStrategy() {
        // If a detail view has been created, update the data
        guard let dView = detailView else { return }
        if dView.strategy == nil { return }
        for s in localStrategies {
            if s.id == dView.strategy.id {
                detailView!.updateStrategyData(strategy: s)
                break
            }
        }
    }
    
    func showLogin() {
        // Hide the data components and show the sign in components
        viewContainer.removeFromSuperview()
        view.addSubview(signInContainer)
        layoutSignInComponents()
        
        // Reset any components storing data
//        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.background, renderingMode: .alwaysOriginal)
        nameLabel.text = "Anonymous"
    }
    func hideSignIn() {
        signInContainer.removeFromSuperview()
        view.addSubview(viewContainer)
        layoutAccountComponents()
    }
    
}


extension AccountPrivateView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
    // MARK: -APPLE AUTH METHODS
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(self.className) - APPLE AUTH ERROR: \(error.localizedDescription)")
//        Analytics.logEvent("gandalf_error", parameters: [
//            "class": self.className as NSObject,
//            "function": "authorizationController" as NSObject,
//            "description": error.localizedDescription as NSObject
//        ])
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
//                Analytics.logEvent("gandalf_error", parameters: [
//                    "class": self.className as NSObject,
//                    "function": "authorizationController" as NSObject,
//                    "description": "fatalError: Apple SignIn nonce nil." as NSObject
//                ])
                fatalError("\(self.className) - APPLE AUTH ERROR: Invalid state: A login callback was received, but no login request was sent.")
            }
            signInWithApple(appleIdCredential: appleIDCredential, nonce: nonce) { result, error in
                if let error = error {
                    print("\(self.className) - SIGN IN WITH APPLE ERROR: \(error.localizedDescription)")
//                    Analytics.logEvent("gandalf_error", parameters: [
//                        "class": self.className as NSObject,
//                        "function": "authorizationController" as NSObject,
//                        "description": error.localizedDescription as NSObject
//                    ])
                    return
                }
                print("\(self.className) - SIGNED IN WITH APPLE: \(String(describing: result))")
                self.hideSignIn()
                
                
//                self.dismiss(animated: true, completion: nil)
//                guard let nc = self.navigationController else {
////                    Analytics.logEvent("gandalf_error", parameters: [
////                        "class": self.className as NSObject,
////                        "function": "authorizationController" as NSObject,
////                        "description": "fatalError: Navigation Controller not found." as NSObject
////                    ])
//                    fatalError("\(self.className) - Navigation Controller not found.")
//                }
//                nc.pushViewController(NotionView(), animated: true)
            }
        }
    }
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window ?? UIWindow()
    }
    
    
    // MARK: -APPLE SIGN IN
    func signInWithApple(appleIdCredential: ASAuthorizationAppleIDCredential, nonce: String,
                         completion: @escaping((String?, Error?) -> Void)) {
        
        // TODO: Verify returned nonce is identical to sent?
        guard let appleIDToken = appleIdCredential.identityToken else {
            print("\(self.className) - SIGN IN: APPLE AUTH ERROR: Unable to fetch identity token")
            completion(nil,NSError(domain: "appleIdCredential identityToken nil", code: NSCoderValueNotFoundError, userInfo: nil))
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("\(self.className) - SIGN IN: APPLE AUTH ERROR: Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            completion(nil,NSError(domain: "appleIDToken nil", code: NSCoderValueNotFoundError, userInfo: nil))
            return
        }
        // TODO: MOVE SIGN IN PROCESS TO BACKEND
        // TODO: Filter appleIDCredential.realUserStatus to prevent fake users
        // https://developer.apple.com/documentation/authenticationservices/asauthorizationappleidcredential/3175418-realuserstatus?language=swift
        
        // 1: Capture the Apple SignIn name and email data. THE INITIAL SIGN IN IS THE ONLY TIME THE APPLE
        // ACCOUNT WILL PASS THE NAME - BE SURE TO SAVE. Firebase will automatically store the Apple email
        // into the Firebase user account, but we should save this to our db Account for ease of use.
        var givenName = ""
        var familyName = ""
        if let fullName = appleIdCredential.fullName {
            givenName = fullName.givenName ?? ""
            familyName = fullName.familyName ?? ""
        }
        let email = appleIdCredential.email ?? ""
        
        // 2: Sign in with Firebase.
        // Initialize a Firebase credential.
        let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                idToken: idTokenString,
                                                rawNonce: nonce)
        Settings.Firebase.auth().signIn(with: credential) { (authResult, error) in
            if let err = error {
                // Error. If error.code == .MissingOrInvalidNonce, make sure
                // you're sending the SHA256-hashed nonce as a hex string with
                // your request to Apple.
                print("\(self.className) - SIGN IN: FIREBASE AUTH ERROR: \(String(describing: err.localizedDescription))")
                completion(authResult.debugDescription,err)
                return
            }
            // User is signed in to Firebase with Apple.
            // NOTE: Firebase automatically verifies the returned nonce (https://firebase.google.com/docs/auth/ios/apple)
            guard let result = authResult else {
                completion(nil,NSError(domain: "Firebase Auth Result nil", code: NSCoderValueNotFoundError, userInfo: nil))
                return
            }
            
//            // 3: IMPORTANT: Assign the uid to the Account ID
//            self.id = result.user.uid
            
            // 4: Check whether the Account already exists
            Settings.Firebase.db().collection("accounts").document(result.user.uid).getDocument { (document, error) in
//                guard error != nil else {
//                    completion(nil,error)
//                    return
//                }
                
                if let document = document, document.exists {
                    guard let data = document.data() as NSDictionary? else {
                        completion(nil,NSError(domain: "Firestore Result nil", code: NSCoderValueNotFoundError, userInfo: nil))
                        return
                    }
                    // 5a: If the Account status is 0, it is blocked, otherwise, allow access
                    guard let accountStatus = data["status"] as? Int else {
                        completion(nil,NSError(domain: "Firestore Account Status nil", code: NSCoderValueNotFoundError, userInfo: nil))
                        return
                    }
                    print("\(self.className) - ACCOUNT STATUS: \(accountStatus)")
                    if accountStatus == 0 {
                        // Account is blocked - do not sign in or create a new account
                        completion(nil,NSError(domain: "Firestore Account Status = 0", code: NSCoderValueNotFoundError, userInfo: nil))
                        return
                        
                    }
//                    Analytics.logEvent(AnalyticsEventLogin, parameters: [
//                        AnalyticsParameterMethod: "apple.com"
//                    ])
                    // The Account already exists, so no need to add data
                    completion("Sign In Complete", nil)
                    return
                    
                } else {
                    // 5b: The Account does not exist, so add data for the new Account
                    // Update the Firebase User to store the desired displayName for the Account (given name only)
                    let changeRequest = Settings.Firebase.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = givenName
                    changeRequest?.commitChanges { (error) in
                        if let err = error {
                            print("\(self.className) - FIREBASE changeRequest ERROR: \(String(describing: err.localizedDescription))")
                        }
                    }

                    // Create the Account entry with needed info
                    let accountCreationTimestamp = NSNumber(value: Date().timeIntervalSince1970)
                    Settings.Firebase.db().collection("accounts").document(result.user.uid).setData([
                        "status": NSNumber(value: 1),
                        "username": "anonymous"
                    ], merge: true) { err in
                        if let err = err {
                            print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                        } else {
                            print("\(self.className) - FIREBASE: account created")
                            
                            Settings.Firebase.db().collection("accounts").document(result.user.uid).collection("private").document("metadata").setData([
                                "created": accountCreationTimestamp
                            ], merge: true) { err in
                                if let err = err {
                                    print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                                } else {
                                    print("\(self.className) - FIREBASE: metadata added")
                                    
                                    Settings.Firebase.db().collection("accounts").document(result.user.uid).collection("private").document("pii").setData([
                                        "email": email,
                                        "name_family": familyName,
                                        "name_given": givenName,
                                    ], merge: true) { err in
                                        if let err = err {
                                            print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                                        } else {
                                            print("\(self.className) - FIREBASE: pii added")
                                            
                                            Settings.Firebase.db().collection("accounts").document(result.user.uid).collection("private").document("settings").setData([
                                                "anonymous": false,
                                                "filter": true,
                                            ], merge: true) { err in
                                                if let err = err {
                                                    print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                                                } else {
                                                    print("\(self.className) - FIREBASE: settings added")
                                                    
                                                    completion("Create Account Complete", nil)
                                                    return
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    // END creating account
                }
                // END doc exists check
            }
            // END request account to check for current account
        }
    }
    
    
    // MARK: -FIREBASE
    // https://firebase.google.com/docs/auth/ios/apple?authuser=2

    //    @available(iOS 13, *)
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()

        return hashString
    }

    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length

        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }

            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }

                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }

        return result
    }
}
