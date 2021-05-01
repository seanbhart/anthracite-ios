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

class AccountView: UIViewController, AccountRepositoryDelegate, AccountEditViewDelegate {
    let className = "AccountView"
    
    var tabBarViewDelegate: TabBarViewDelegate!
    var accountRepository: AccountRepository?
    // Unhashed nonce - handle locally (not in Account) for security
    fileprivate var currentNonce: String?
    var controller: ASAuthorizationController!
    
    var signInContainer: UIView!
    var signInButton: ASAuthorizationAppleIDButton!
    
    var viewContainer: UIView!
    var settingsButtonContainer: UIView!
    var settingsButtonContainerGestureRecognizer: UITapGestureRecognizer!
    var settingsButtonLabel: UILabel!
    var accountImageContainer: UIView!
    var accountImage: UIImageView!
    var nameLabel: UILabel!
    
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
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the navigation bar is not hidden
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
//        layoutSignInComponents()
//        layoutAccountComponents()
        
        // Get the Account via the AccountRepo
        if let accountRepo = accountRepository {
            accountRepo.getAccount()
        } else {
            // If the AccountRepo is null, create a new one
            // be sure to assign the delegate to receive callbacks
            if let accountRepo = AccountRepository() {
                accountRepository = accountRepo
                accountRepository!.delegate = self
                accountRepository!.getAccount()
            } else {
                // If getting the account failed, the user
                // is not logged in - show the login view
                showSignIn()
            }
        }
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

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
        signInButton.addTarget(self, action: #selector(AccountView.signInTap(_:)), for: .touchUpInside)
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
        
        accountImage = UIImageView()
        accountImage.layer.cornerRadius = 58
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.background, renderingMode: .alwaysOriginal)
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
        
        settingsButtonContainer = UIView()
        settingsButtonContainer.layer.borderWidth = 1
        settingsButtonContainer.layer.cornerRadius = 5
        settingsButtonContainer.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        settingsButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(settingsButtonContainer)
        
        let settingsIconContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(settingsIconContainerTap))
        settingsIconContainerGestureRecognizer.numberOfTapsRequired = 1
        settingsButtonContainer.addGestureRecognizer(settingsIconContainerGestureRecognizer)
        
        settingsButtonLabel = UILabel()
        settingsButtonLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        settingsButtonLabel.textColor = Settings.Theme.Color.primaryLight
        settingsButtonLabel.textAlignment = NSTextAlignment.center
        settingsButtonLabel.numberOfLines = 1
        settingsButtonLabel.text = "EDIT PROFILE"
        settingsButtonLabel.isUserInteractionEnabled = false
        settingsButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(settingsButtonLabel)
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
            accountImage.centerYAnchor.constraint(equalTo: accountImageContainer.centerYAnchor),
            accountImage.centerXAnchor.constraint(equalTo: accountImageContainer.centerXAnchor),
            accountImage.heightAnchor.constraint(equalToConstant: 116),
            accountImage.widthAnchor.constraint(equalToConstant: 116),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: accountImageContainer.rightAnchor, constant: 20),
            nameLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            settingsButtonContainer.topAnchor.constraint(equalTo: accountImageContainer.bottomAnchor, constant: 20),
            settingsButtonContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            settingsButtonContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            settingsButtonContainer.heightAnchor.constraint(equalToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            settingsButtonLabel.topAnchor.constraint(equalTo: settingsButtonContainer.topAnchor),
            settingsButtonLabel.leftAnchor.constraint(equalTo: settingsButtonContainer.leftAnchor),
            settingsButtonLabel.rightAnchor.constraint(equalTo: settingsButtonContainer.rightAnchor),
            settingsButtonLabel.bottomAnchor.constraint(equalTo: settingsButtonContainer.bottomAnchor),
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
    @objc func settingsIconContainerTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - settingsIconContainerTap")
        guard let accountRepo = accountRepository else { return }
        
        // Present the account edit sheet via a modal view
        let accountEditView: AccountEditView = AccountEditView(accountRepo: accountRepo)
        accountEditView.delegate = self
        self.presentSheet(with: accountEditView)
    }
    
    
    // MARK: -IMAGE PICKER METHODS
    
    func didSelect(image: UIImage?) {
        guard let img = image else { self.showUploadImageErrorAlert(); return }
        guard let accountRepo = accountRepository else { self.showUploadImageErrorAlert(); return }
        // Add to the local imageview
        accountImage.image = img
        
        // Upload to storage for the large sized image
        guard let imgLarge = img.resizeWithWidth(width: 500) else { self.showUploadImageErrorAlert(); return }
        let storageRef = Storage.storage().reference().child(accountRepo.accountId + ".png")
        if let uploadData = imgLarge.pngData() {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil { self.showUploadImageErrorAlert(); return }
            }
        }
        
        // Reduce the image size (for messages) and upload to storage
        guard let imgSmall = img.resizeWithWidth(width: 30) else { self.showUploadImageErrorAlert(); return }
        let storageRefSmall = Storage.storage().reference().child(accountRepo.accountId + "-small.png")
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
        guard let accountRepo = accountRepository else { return }
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
    
    func notSignedIn() {
        showSignIn()
    }
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func getAccountImage() {
        guard let accountRepo = accountRepository else { return }
        let imageRef = Storage.storage().reference().child(accountRepo.accountId + ".png")
        imageRef.getData(maxSize: 1 * 1024 * 1024) { (data, error) -> Void in
            if error != nil { return }
            guard let imgData = data else { return }
            self.accountImage.image = UIImage(data: imgData)
            
            if accountRepo.account == nil { return }
            accountRepo.account!.image = UIImage(data: imgData)
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
    
    func showSignIn() {
        // Hide the data components and show the sign in components
        viewContainer.removeFromSuperview()
        view.addSubview(signInContainer)
        layoutSignInComponents()
        
        // Reset any components storing data
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.background, renderingMode: .alwaysOriginal)
        nameLabel.text = "Anonymous"
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
