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

class ProfileView: UIViewController, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    let viewName = "ProfileView"
    
    // Unhashed nonce - handle locally (not in Account) for security
    fileprivate var currentNonce: String?
    var controller: ASAuthorizationController!
    
    var viewContainer: UIView!
    var profileName: UILabel!
    var signInButton: ASAuthorizationAppleIDButton!
    var signOutButton: UILabel!
    var signOutButtonTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Sign In"
        
        self.navigationItem.rightBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.hidesBackButton = true
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
            profileName.centerYAnchor.constraint(equalTo:view.centerYAnchor, constant: -50),
            profileName.centerXAnchor.constraint(equalTo:view.centerXAnchor),
            profileName.widthAnchor.constraint(equalTo: viewContainer.widthAnchor),
            profileName.heightAnchor.constraint(equalToConstant:50),
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
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func loadView() {
        super.loadView()
        print("\(self.viewName) - loadView")
        
        // Make the overall background black to fill any unfilled areas
        view.backgroundColor = Settings.Theme.background
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        profileName = UILabel()
        profileName.font = UIFont(name: Assets.Fonts.Default.light, size: 30)
        profileName.textColor = Settings.Theme.text
        profileName.textAlignment = NSTextAlignment.center
        profileName.numberOfLines = 1
        profileName.text = ""
        profileName.isUserInteractionEnabled = false
        profileName.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(profileName)
        
        if let cUser = Auth.auth().currentUser {
            if let name = cUser.displayName {
                profileName.text = "Welcome, \(name)"
            }
        }
        
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
        
        // Show the correct button based on if the user is signed in
        if let firUser = Auth.auth().currentUser {
            print("firUser \(firUser.uid)")
            self.hideSignIn()
        } else {
            self.showSignIn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func signOut() {
        print("\(self.viewName) - SIGN OUT")
        // First request verification
        let signOutAlert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        signOutAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { action in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
//                Analytics.logEvent("vk_error", parameters: [
//                    "class": "Account" as NSObject,
//                    "function": "signOut" as NSObject,
//                    "description": signOutError.localizedDescription as NSObject
//                ])
                print ("ACCOUNT - Error signing out: %@", signOutError)
            }
            // Load LoginView
            print("\(self.viewName) - LOGGED OUT - NOW SHOW LOGIN VIEW")
            self.showSignIn()
        }))
        signOutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(signOutAlert, animated: true)
    }
    
    func showSignIn() {
        self.signOutButton.isHidden = true
        self.signInButton.isHidden = false
    }
    func hideSignIn() {
        self.signOutButton.isHidden = false
        self.signInButton.isHidden = true
    }
    
    
    // MARK: -APPLE AUTH METHODS
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("\(self.viewName) - APPLE AUTH ERROR: \(error.localizedDescription)")
//        Analytics.logEvent("vk_error", parameters: [
//            "class": "ProfileView" as NSObject,
//            "function": "authorizationController" as NSObject,
//            "description": error.localizedDescription as NSObject
//        ])
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            guard let nonce = currentNonce else {
//                Analytics.logEvent("vk_error", parameters: [
//                    "class": "ProfileView" as NSObject,
//                    "function": "authorizationController" as NSObject,
//                    "description": "fatalError: Apple SignIn nonce nil" as NSObject
//                ])
                fatalError("\(self.viewName) - APPLE AUTH ERROR: Invalid state: A login callback was received, but no login request was sent.")
            }
            signInWithApple(appleIdCredential: appleIDCredential, nonce: nonce) { result, error in
                if let e = error {
                    print("\(self.viewName) - SIGN IN WITH APPLE ERROR: \(e.localizedDescription)")
//                    Analytics.logEvent("vk_error", parameters: [
//                        "class": "ProfileView" as NSObject,
//                        "function": "authorizationController" as NSObject,
//                        "description": e.localizedDescription as NSObject
//                    ])
                    return
                }
                print("\(self.viewName) - SIGN IN WITH APPLE: \(String(describing: result))")
                // Continue to the main page
                self.dismiss(animated: true, completion: nil)
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
            print("\(self.viewName) - SIGN IN: APPLE AUTH ERROR: Unable to fetch identity token")
            completion(nil,NSError(domain: "appleIdCredential identityToken nil", code: NSCoderValueNotFoundError, userInfo: nil))
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            print("\(self.viewName) - SIGN IN: APPLE AUTH ERROR: Unable to serialize token string from data: \(appleIDToken.debugDescription)")
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
                print("\(self.viewName) - SIGN IN: FIREBASE AUTH ERROR: \(String(describing: err.localizedDescription))")
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
                            print("\(self.viewName) - FIREBASE changeRequest ERROR: \(String(describing: err.localizedDescription))")
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
                            print("\(self.viewName) - FIREBASE: ERROR creating account: \(err)")
                        } else {
                            print("\(self.viewName) - FIREBASE: account successfully created")
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
