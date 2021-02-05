//
//  LoginView.swift
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

class ProfileView: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding, ProfileRepositoryDelegate {
    let className = "ProfileView"
    
    var profileRepository: ProfileRepository!
    // Unhashed nonce - handle locally (not in Account) for security
    fileprivate var currentNonce: String?
    var controller: ASAuthorizationController!
    
    var viewContainer: UIView!
    var usernameContainer: UIView!
    var usernameEditIcon: UIImageView!
    var usernameLabel: UILabel!
    var signInButton: ASAuthorizationAppleIDButton!
    var signOutButton: UILabel!
    var signOutButtonTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = ""
        self.navigationItem.hidesBackButton = true
        
        let barItemLogo = UIButton(type: .custom)
        barItemLogo.setImage(UIImage(named: Assets.Images.logotypeLg), for: .normal)
        NSLayoutConstraint.activate([
            barItemLogo.widthAnchor.constraint(equalToConstant:110),
            barItemLogo.heightAnchor.constraint(equalToConstant:20),
        ])
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: barItemLogo)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Ensure the navigation bar is not hidden
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            usernameContainer.centerYAnchor.constraint(equalTo:view.centerYAnchor, constant: -100),
            usernameContainer.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            usernameContainer.widthAnchor.constraint(equalToConstant: 290),
            usernameContainer.heightAnchor.constraint(equalToConstant:50),
        ])
        NSLayoutConstraint.activate([
            usernameEditIcon.topAnchor.constraint(equalTo:usernameContainer.topAnchor),
            usernameEditIcon.leftAnchor.constraint(equalTo:usernameContainer.leftAnchor),
            usernameEditIcon.bottomAnchor.constraint(equalTo:usernameContainer.bottomAnchor),
            usernameEditIcon.widthAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo:usernameContainer.topAnchor),
            usernameLabel.leftAnchor.constraint(equalTo:usernameEditIcon.rightAnchor, constant: 20),
            usernameLabel.rightAnchor.constraint(equalTo:usernameContainer.rightAnchor),
            usernameLabel.bottomAnchor.constraint(equalTo:usernameContainer.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            signInButton.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            signInButton.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            signInButton.widthAnchor.constraint(equalToConstant:280),
            signInButton.heightAnchor.constraint(equalToConstant:50),
        ])
        NSLayoutConstraint.activate([
            signOutButton.centerYAnchor.constraint(equalTo:view.centerYAnchor),
            signOutButton.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            signOutButton.widthAnchor.constraint(equalToConstant:280),
            signOutButton.heightAnchor.constraint(equalToConstant:50),
        ])
        
        // Show the correct button based on if the user is signed in
        if let firUser = Auth.auth().currentUser {
            print("firUser \(firUser.uid)")
            self.hideSignIn()
            profileRepository = ProfileRepository(id: firUser.uid)
            profileRepository.delegate = self
            profileRepository.getAccount()
        } else {
            self.showSignIn()
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
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
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
        
        signInButton = ASAuthorizationAppleIDButton(type: .default, style: .white)
        signInButton.cornerRadius = 2
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        signInButton.addTarget(self, action: #selector(ProfileView.signInTap(_:)), for: .touchUpInside)
        viewContainer.addSubview(signInButton)
        
        signOutButton = UILabel()
        signOutButton.layer.masksToBounds = true
        signOutButton.layer.cornerRadius = 2
        signOutButton.backgroundColor = .white
        signOutButton.font = UIFont(name: Assets.Fonts.Default.bold, size: 20)
        signOutButton.textColor = .black
        signOutButton.textAlignment = NSTextAlignment.center
        signOutButton.numberOfLines = 1
        signOutButton.text = "Sign Out" //"Start your free trial"
        signOutButton.isUserInteractionEnabled = true
        signOutButton.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(signOutButton)
        
        signOutButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ProfileView.signOutTap(_:)))
        signOutButtonTapGestureRecognizer.numberOfTapsRequired = 1  // add single tap
        signOutButton.addGestureRecognizer(signOutButtonTapGestureRecognizer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
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
        guard let profile = profileRepository.profile else { return }
//        print("profile: \(profile.username)")
        
        let alert = UIAlertController(title: "Edit Username", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("EDIT USERNAME TO: \(textField.text)")
            guard let username = textField.text else { return }
            if username.count > 0 {
                if let profileRepo = self.profileRepository {
                    profileRepo.setUserName(username: username)
                    self.profileRepository.getAccount()
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Username"
            textField.text = profile.username
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
    
    
    // MARK: -REPO DELEGATE
    
    func profileDataUpdate() {
        print("\(className) - profileDataUpdate")
        if let profile = profileRepository.profile {
            // If the username is empty, use the known account name
            if let username = profile.username {
                usernameLabel.text = username
            } else {
                if let name = profile.name {
                    let given = name["given"] ?? "anonymous"
                    let family = name["family"] ?? ""
                    usernameLabel.text = given + " " + family
                } else {
                    usernameLabel.text = "anonymous"
                }
            }
        }
    }
    
    func requestError(message: String) {
        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func signOut() {
        print("\(self.className) - SIGN OUT")
        // First request verification
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        signOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
//                Analytics.logEvent("gandalf_error", parameters: [
//                    "class": "Account" as NSObject,
//                    "function": "signOut" as NSObject,
//                    "description": signOutError.localizedDescription as NSObject
//                ])
                print ("ACCOUNT - Error signing out: %@", signOutError)
            }
            // Load LoginView
            print("\(self.className) - LOGGED OUT - NOW SHOW LOGIN VIEW")
            self.showSignIn()
        }))
        signOutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(signOutAlert, animated: true)
    }
    
    func showSignIn() {
        self.signOutButton.isHidden = true
        self.signInButton.isHidden = false
        
        usernameLabel.text = ""
    }
    func hideSignIn() {
        self.signOutButton.isHidden = false
        self.signInButton.isHidden = true
    }
    
    
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
        Auth.auth().signIn(with: credential) { (authResult, error) in
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
                    if accountStatus == 0 {
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
                    let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
                    changeRequest?.displayName = givenName
                    changeRequest?.commitChanges { (error) in
                        if let err = error {
                            print("\(self.className) - FIREBASE changeRequest ERROR: \(String(describing: err.localizedDescription))")
                        }
                    }

                    // Create the Account entry with needed info
                    let accountCreationTimestamp = NSNumber(value: Date().timeIntervalSince1970)
                    Settings.Firebase.db().collection("accounts").document(result.user.uid).setData([
                        "email": email,
                        "name": ["family": familyName, "given": givenName],
                        "settings": ["filter": NSNumber(value: 1)],
                        "status": NSNumber(value: 1),
                        "timestamp": accountCreationTimestamp
                    ], merge: true) { err in
                        if let err = err {
                            print("\(self.className) - FIREBASE: ERROR creating account: \(err)")
                        } else {
                            print("\(self.className) - FIREBASE: account successfully created")
                        }
                    }
                    
                    completion("Create Account Complete", nil)
                    return
                }
            }
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
