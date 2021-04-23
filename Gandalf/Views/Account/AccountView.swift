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
import FirebaseStorage
import Charts

class AccountView: UIViewController, ImagePickerDelegate, ChartViewDelegate, AccountRepositoryDelegate, ShadowRepositoryDelegate, ShadowPositionRepositoryDelegate {
    let className = "AccountView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var accountRepository: AccountRepository?
    
    var shadows = [Shadow]()
    var shadowRepository: ShadowRepository?
    var shadowPositionRepository: ShadowPositionRepository?
    // Unhashed nonce - handle locally (not in Account) for security
    fileprivate var currentNonce: String?
    var controller: ASAuthorizationController!
    var imagePicker: ImagePicker!
    
    var signInContainer: UIView!
    var signInButton: ASAuthorizationAppleIDButton!
    
    var viewContainer: UIView!
    var accountImage: UIImageView!
    var usernameContainer: UIView!
    var usernameEditIcon: UIImageView!
    var usernameLabel: UILabel!
    var chartView: PieChartView!
    
    var signOutButton: UILabel!
    var signOutButtonTapGestureRecognizer: UITapGestureRecognizer!
    
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
            guard let shadowRepo = shadowRepository else { return }
            guard let shadowPositionRepo = shadowPositionRepository else { return }
            shadowRepo.observeQuery()
            shadowPositionRepo.observeQuery()
        }
        observer = NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            print("\(className) - didEnterBackgroundNotification")
            guard let shadowRepo = shadowRepository else { return }
            guard let shadowPositionRepo = shadowPositionRepository else { return }
            shadowRepo.stopObserving()
            shadowPositionRepo.stopObserving()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the navigation bar is not hidden
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
//        layoutSignInComponents()
//        layoutAccountComponents()
        
        // Get the Account via the AccountRepo
        if accountRepository == nil {
            if let accountRepo = AccountRepository() {
                accountRepository = accountRepo
                accountRepository!.delegate = self
            } else {
                // If getting the account failed, the user
                // is not logged in - show the login view
                showSignIn()
            }
        }
        accountRepository!.observeDoc()
        
        if shadowRepository == nil {
            shadowRepository = ShadowRepository()
            shadowRepository!.delegate = self
        }
        shadowRepository!.observeQuery()
        
        if shadowPositionRepository == nil {
            shadowPositionRepository = ShadowPositionRepository()
            shadowPositionRepository!.delegate = self
        }
        shadowPositionRepository!.observeQuery()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func loadView() {
        super.loadView()
        print("\(self.className) - loadView")
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        // Make the overall background black to fill any unfilled areas
        view.backgroundColor = Settings.Theme.Color.background
        
        signInContainer = UIView()
        signInContainer.backgroundColor = Settings.Theme.Color.background
        signInContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(signInContainer)
        
        signInButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        signInButton.cornerRadius = 2
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(AccountView.signInTap(_:)), for: .touchUpInside)
        signInContainer.addSubview(signInButton)
        
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        accountImage = UIImageView()
        accountImage.layer.cornerRadius = 50
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
        accountImage.contentMode = UIView.ContentMode.scaleAspectFit
        accountImage.clipsToBounds = true
        accountImage.isUserInteractionEnabled = true
        accountImage.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(accountImage)
        
        let accountImageGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(accountImageTap))
        accountImageGestureRecognizer.numberOfTapsRequired = 1
        accountImage.addGestureRecognizer(accountImageGestureRecognizer)
        
        usernameContainer = UIView()
        usernameContainer.backgroundColor = Settings.Theme.Color.background
        usernameContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(usernameContainer)
        
        let usernameContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(usernameContainerTap))
        usernameContainerGestureRecognizer.numberOfTapsRequired = 1
        usernameContainer.addGestureRecognizer(usernameContainerGestureRecognizer)
        
        usernameEditIcon = UIImageView()
        usernameEditIcon.image = UIImage(systemName: "square.and.pencil")
        usernameEditIcon.contentMode = UIView.ContentMode.scaleAspectFit
        usernameEditIcon.clipsToBounds = true
        usernameEditIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.addSubview(usernameEditIcon)
        
        usernameLabel = UILabel()
        usernameLabel.font = UIFont(name: Assets.Fonts.Default.light, size: 30)
        usernameLabel.textColor = Settings.Theme.Color.text
        usernameLabel.textAlignment = NSTextAlignment.left
        usernameLabel.numberOfLines = 1
        usernameLabel.text = ""
        usernameLabel.isUserInteractionEnabled = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        usernameContainer.addSubview(usernameLabel)
        
        signOutButton = UILabel()
        signOutButton.font = UIFont(name: Assets.Fonts.Default.regular, size: 14)
        signOutButton.textColor = Settings.Theme.Color.textGrayMedium
        signOutButton.textAlignment = NSTextAlignment.center
        signOutButton.numberOfLines = 1
        signOutButton.text = "Sign Out"
        signOutButton.isUserInteractionEnabled = true
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(signOutButton)
        
        signOutButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AccountView.signOutTap(_:)))
        signOutButtonTapGestureRecognizer.numberOfTapsRequired = 1  // add single tap
        signOutButton.addGestureRecognizer(signOutButtonTapGestureRecognizer)
        
        chartView = PieChartView()
        chartView.delegate = self
//        chartView.backgroundColor = Settings.Theme.Color.grayLight
        chartView.legend.textColor = Settings.Theme.Color.textGrayUltraDark
        chartView.isUserInteractionEnabled = true
        chartView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(chartView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    func layoutSignInComponents() {
        NSLayoutConstraint.activate([
            signInContainer.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            signInContainer.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            signInContainer.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            signInContainer.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo:signInContainer.centerYAnchor),
            signInButton.centerXAnchor.constraint(equalTo:signInContainer.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant:280),
            signInButton.heightAnchor.constraint(equalToConstant:50),
        ])
    }
    
    func layoutAccountComponents() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            accountImage.topAnchor.constraint(equalTo:viewContainer.topAnchor, constant: 20),
            accountImage.centerXAnchor.constraint(equalTo:viewContainer.centerXAnchor),
            accountImage.heightAnchor.constraint(equalToConstant: 100),
            accountImage.widthAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            usernameContainer.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            usernameContainer.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            usernameContainer.topAnchor.constraint(equalTo:accountImage.bottomAnchor, constant: 20),
            usernameContainer.heightAnchor.constraint(equalToConstant:60),
        ])
        NSLayoutConstraint.activate([
            usernameLabel.centerXAnchor.constraint(equalTo:usernameContainer.centerXAnchor),
            usernameLabel.topAnchor.constraint(equalTo:usernameContainer.topAnchor, constant: 10),
            usernameLabel.bottomAnchor.constraint(equalTo:usernameContainer.bottomAnchor, constant: -10),
        ])
        NSLayoutConstraint.activate([
            usernameEditIcon.topAnchor.constraint(equalTo:usernameContainer.topAnchor, constant: 15),
            usernameEditIcon.bottomAnchor.constraint(equalTo:usernameContainer.bottomAnchor, constant: -15),
            usernameEditIcon.rightAnchor.constraint(equalTo:usernameLabel.leftAnchor, constant: -10),
            usernameEditIcon.widthAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            signOutButton.topAnchor.constraint(equalTo:usernameContainer.bottomAnchor, constant: 10),
            signOutButton.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            signOutButton.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            signOutButton.heightAnchor.constraint(equalToConstant:40),
        ])
        
        let chartSize = viewContainer.frame.width > 400 ? 380 : viewContainer.frame.width > 20 ? viewContainer.frame.width - 20 : 300
        NSLayoutConstraint.activate([
            chartView.topAnchor.constraint(equalTo: signOutButton.bottomAnchor, constant: 30),
            chartView.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            chartView.widthAnchor.constraint(equalToConstant: chartSize),
            chartView.heightAnchor.constraint(equalToConstant: chartSize),
        ])
        
        getAccountImage()
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
    @objc func signOutTap(_ sender: UITapGestureRecognizer) {
        signOut()
    }
    @objc func usernameContainerTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - usernameContainerTap")
        guard let accountRepo = accountRepository else { return }
        guard let account = accountRepo.account else { return }
//        print("account: \(account.username)")
        
        let alert = UIAlertController(title: "Edit Username", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("EDIT USERNAME TO: \(textField.text)")
            guard let username = textField.text else { return }
            if username.count > 0 {
                accountRepo.setUserName(username: username)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Username"
            textField.text = account.username
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
                    if let tf = notification.object as? UITextField {
                        let maxLength = 20
                        if let text = tf.text {
                            if text.count > maxLength {
                                tf.text = String(text.prefix(maxLength))
                            }
                        }
                    }
                })
        })
        self.present(alert, animated: true)
    }
    
    @objc func accountImageTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - accountImageTap")
        imagePicker.present(from: accountImage)
    }
    
    
    // MARK: -CHARTS
    
    func updateChartData(shadow: Shadow) {
        print("\(className) - updateChartData")
        var cumulativePerc = 0.0
        var entries = shadow.positions.map { position -> PieChartDataEntry in
            cumulativePerc += position.perc ?? 0.0
            return PieChartDataEntry(value: (position.perc ?? 0.0) * 100,
                                     label: position.symbol ?? "",
                                     icon: nil)
        }
        if cumulativePerc < 1 {
            let otherEntry = PieChartDataEntry(value: (1 - cumulativePerc) * 100,
                                               label: "other",
                                               icon: nil)
            entries.append(otherEntry)
        }
        
        let set = PieChartDataSet(entries: entries, label: shadow.target)
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        set.colors = ChartColorTemplates.material()
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 11, weight: .light))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.notifyDataSetChanged()
    }
    
    
    // MARK: -IMAGE PICKER METHODS
    
    func didSelect(image: UIImage?) {
        guard let img = image else { self.showUploadImageErrorAlert(); return }
        guard let accountRepo = accountRepository else { self.showUploadImageErrorAlert(); return }
        guard let account = accountRepo.account else {  self.showUploadImageErrorAlert(); return }
        guard let accountId = account.id else {  self.showUploadImageErrorAlert(); return }
        // Add to the local imageview
        accountImage.image = img
        
        // Upload to storage for the large sized image
        guard let imgLarge = img.resizeWithWidth(width: 500) else { self.showUploadImageErrorAlert(); return }
        let storageRef = Storage.storage().reference().child(accountId + ".png")
        if let uploadData = imgLarge.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil { self.showUploadImageErrorAlert(); return }
            }
        }
        
        // Reduce the image size (for messages) and upload to storage
        guard let imgSmall = img.resizeWithWidth(width: 30) else { self.showUploadImageErrorAlert(); return }
        let storageRefSmall = Storage.storage().reference().child(accountId + "-small.png")
        if let uploadData = imgSmall.pngData() {
            storageRefSmall.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil { self.showUploadImageErrorAlert(); return }
            }
        }
        
    }
    
    func showUploadImageErrorAlert() {
        let alert = UIAlertController(title: "We messed up!", message: "Oh no there was a problem uploading your photo! Please try again.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: -REPO METHODS
    
    func accountDataUpdate() {
        print("\(className) - accountDataUpdate")
        guard let accountRepo = accountRepository else { self.showUploadImageErrorAlert(); return }
        guard let account = accountRepo.account else {  self.showUploadImageErrorAlert(); return }
        
        // If the username is empty, use the known account name
        if let username = account.username {
            usernameLabel.text = username
        } else {
            usernameLabel.text = account.name ?? "anonymous"
        }
        usernameLabel.sizeToFit()
        usernameLabel.layoutIfNeeded()
        layoutAccountComponents()
        
        // Show the account info if the user is signed in
        self.hideSignIn()
    }
    
    func requestError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func showLogin() {
        showSignIn()
    }
    
    func shadowsDataUpdate() {
        print("\(className) - shadowsDataUpdate")
        updateShadowPositions()
    }
    
    func shadowPositionsDataUpdate() {
        print("\(className) - shadowPositionsDataUpdate")
        updateShadowPositions()
    }
    
    func updateShadowPositions() {
        if shadowPositionRepository?.shadowPositions.count == 0 { return }
        
        // Fill the shadow position array with shadow positions.
        let newShadows = shadowRepository?.shadows.map { shadow -> Shadow in
            var newShadow = shadow
            newShadow.positions = shadowPositionRepository?.shadowPositions.compactMap { shadowPosition -> ShadowPosition? in
                if shadowPosition.shadow == shadow.id { return shadowPosition }
                return nil
            } ?? []
            return newShadow
        } ?? []
        
        if newShadows.count > 0 {
            shadows.removeAll()
            shadows = newShadows
        }
        
        if shadows.count > 0 {
            updateChartData(shadow: shadows[0])
        }
    }
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func getAccountImage() {
        guard let accountRepo = accountRepository else { return }
        guard let account = accountRepo.account else { return }
        guard let accountId = account.id else { return }
        
        let imageRef = Storage.storage().reference().child(accountId + ".png")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if error != nil { return }
            guard let imgData = data else { return }
            self.accountImage.image = UIImage(data: imgData)
        }
        
//        imageRef.downloadURL { url, error in
//            if error != nil { return }
//
//            guard let imageUrl = url else {
//                self.showUploadImageErrorAlert()
//                return
//            }
//            guard let imageURL = URL(string: imageUrl.absoluteString) else { return
//            DispatchQueue.global().async {
//                guard let imageData = try? Data(contentsOf: imageUrl) else { return }
//
//                let image = UIImage(data: imageData)
//                DispatchQueue.main.async {
//                    self.accountImage.image = image
//                }
//            }
//        }
    }
    
    func signOut() {
        print("\(self.className) - SIGN OUT")
        // First request verification
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        signOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let firebaseAuth = Settings.Firebase.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                self.requestError(title: "We messed up!", message: "There was a problem logging you out! Please try again.")
                
//                Analytics.logEvent("gandalf_error", parameters: [
//                    "class": "Account" as NSObject,
//                    "function": "signOut" as NSObject,
//                    "description": signOutError.localizedDescription as NSObject
//                ])
                print ("ACCOUNT - Error signing out: %@", signOutError)
                return
            }
            // Load LoginView
            print("\(self.className) - LOGGED OUT - NOW SHOW LOGIN VIEW")
            self.showSignIn()
            
            // Take background steps for signing out
            if let accountRepo = self.accountRepository {
                accountRepo.signOut()
            }
        }))
        signOutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(signOutAlert, animated: true)
    }
    
    func showSignIn() {
        // Hide the data components and show the sign in components
        viewContainer.removeFromSuperview()
        view.addSubview(signInContainer)
        layoutSignInComponents()
        
        // Reset any components storing data
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
        usernameLabel.text = "anonymous"
    }
    func hideSignIn() {
        signInContainer.removeFromSuperview()
        view.addSubview(viewContainer)
        layoutAccountComponents()
    }
    
}


extension AccountView: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    
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
            Settings.Firebase.db()
                .collection("accounts")
                .document(result.user.uid)
                .getDocument { (document, error) in
                    if let err = error {
                        completion(nil,err)
                        return
                    }
                
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
                        Settings.Firebase.db()
                            .collection("accounts")
                            .document(result.user.uid)
                            .setData([
                                "status": NSNumber(value: 1),
                                "username": "anonymous",
                                "created": accountCreationTimestamp,
                                "email": email,
                                "name": givenName + " " + familyName,
                                "name_family": familyName,
                                "name_given": givenName,
                            ], merge: true) { err in
                                if let err = err {
                                    print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                                } else {
                                    print("\(self.className) - FIREBASE: account created")
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
