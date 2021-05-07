//
//  AccountEditView.swift
//  Gandalf
//
//  Created by Sean Hart on 4/26/21.
//

//import PassKit
import AuthenticationServices
import CryptoKit
import UIKit
//import FirebaseAnalytics
import FirebaseAuth
import FirebaseStorage

protocol AccountEditViewDelegate {
    func showLogin()
}

class AccountEditView: UIViewController, ImagePickerDelegate {
    let className = "AccountEditView"
    
    var delegate: AccountEditViewDelegate?
    var accountRepository: AccountPrivateRepository!
    var imagePicker: ImagePicker!
    
    var viewContainer: UIView!
    var accountImageContainer: UIView!
    var accountImage: UIImageView!
    var nameLabel: UILabel!
    var nameTextField: UITextField!
    
    init(accountRepo: AccountPrivateRepository) {
        super.init(nibName: nil, bundle: nil)
        self.accountRepository = accountRepo
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Edit Profile"
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
        
        layoutAccountComponents()
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.setNavigationBarHidden(false, animated: animated)
//    }

    override func loadView() {
        super.loadView()
        print("\(self.className) - loadView")
        imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        guard let account = accountRepository.account else { print("\(self.className) - no account repo"); return }
        print("\(self.className) - account: \(account)")
        
        // Make the overall background black to fill any unfilled areas
        view.backgroundColor = Settings.Theme.Color.background
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        accountImageContainer = UIView()
        accountImageContainer.layer.cornerRadius = 120
        accountImageContainer.backgroundColor = Settings.Theme.Color.outline
        accountImageContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(accountImageContainer)
        
        accountImage = UIImageView()
        accountImage.layer.cornerRadius = 118
        accountImage.image = account.image
        accountImage.contentMode = UIView.ContentMode.scaleAspectFit
        accountImage.clipsToBounds = true
        accountImage.isUserInteractionEnabled = true
        accountImage.translatesAutoresizingMaskIntoConstraints = false
        accountImageContainer.addSubview(accountImage)
        
        let accountImageGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(accountImageTap))
        accountImageGestureRecognizer.numberOfTapsRequired = 1
        accountImage.addGestureRecognizer(accountImageGestureRecognizer)
        
        nameLabel = UILabel()
        nameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 10)
        nameLabel.textColor = Settings.Theme.Color.textGrayLight
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.text = "NAME"
        nameLabel.isUserInteractionEnabled = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(nameLabel)
        
        nameTextField = UITextField()
        nameTextField.placeholder = account.name
        nameTextField.font = UIFont(name: Assets.Fonts.Default.light, size: 16)
        nameTextField.autocorrectionType = UITextAutocorrectionType.yes
        nameTextField.keyboardType = UIKeyboardType.default
        nameTextField.returnKeyType = UIReturnKeyType.done
        nameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        nameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        nameTextField.layer.borderWidth = 1
        nameTextField.layer.cornerRadius = 5
        nameTextField.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        viewContainer.addSubview(nameTextField)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    func layoutAccountComponents() {
        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            accountImageContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            accountImageContainer.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            accountImageContainer.heightAnchor.constraint(equalToConstant: 240),
            accountImageContainer.widthAnchor.constraint(equalToConstant: 240),
        ])
        NSLayoutConstraint.activate([
            accountImage.centerYAnchor.constraint(equalTo: accountImageContainer.centerYAnchor),
            accountImage.centerXAnchor.constraint(equalTo: accountImageContainer.centerXAnchor),
            accountImage.heightAnchor.constraint(equalToConstant: 236),
            accountImage.widthAnchor.constraint(equalToConstant: 236),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: accountImageContainer.bottomAnchor, constant: 20),
            nameLabel.leftAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 10),
            nameLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            nameLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10),
            nameTextField.leftAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 10),
            nameTextField.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -10),
            nameTextField.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func signOutTap(_ sender: UITapGestureRecognizer) {
        signOut()
    }
    
    @objc func accountImageTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - accountImageTap")
        imagePicker.present(from: accountImage)
    }
    
    
    // MARK: -IMAGE PICKER METHODS
    
    func didSelect(image: UIImage?) {
        guard let img = image else { self.showUploadImageErrorAlert(); return }
        guard let accountRepo = accountRepository else { self.showUploadImageErrorAlert(); return }
        guard let account = accountRepo.account else { self.showUploadImageErrorAlert(); return }
        guard let accountId = account.id else { self.showUploadImageErrorAlert(); return }
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
            self.dismiss(animated: true, completion: {
                if let parent = self.delegate {
                    parent.showLogin()
                }
            })
            
            // Take background steps for signing out
            if let accountRepo = self.accountRepository {
                accountRepo.signOut()
            }
        }))
        signOutAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        self.present(signOutAlert, animated: true)
    }
    
    
    // MARK: -REPO METHODS
    
    func accountDataUpdate() {
        print("\(className) - accountDataUpdate")
//        guard let accountRepo = accountRepository else { return }
//        if let account = accountRepo.account {
//
//        }
    }
    
    func requestError(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
}
