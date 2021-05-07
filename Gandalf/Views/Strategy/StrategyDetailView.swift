//
//  StrategyDetailView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/5/21.
//

import UIKit
import FirebaseAuth

protocol StrategyDetailViewDelegate {
    func reaction(strategyId: String, type: Int)
}

class StrategyDetailView: UIViewController, UIGestureRecognizerDelegate {
    let className = "StrategyDetailView"
    
    var delegate: StrategyDetailViewDelegate!
    var strategy: Strategy!
    
    var viewContainer: UIView!
    var headerContainer: UIView!
    var avatarContainer: UIView!
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var ageLabel: UILabel!
    var windowLabel: UILabel!
    var windowLabelLabel: UILabel!
    var orderTableView: UITableView!
    let orderTableCellIdentifier: String = "OrderCell"
    
    var footerContainer: UIView!
    var footerBorder: UIView!
    var orderButtonContainer: UIView!
    var orderButton: UIView!
    var orderButtonLabel: UILabel!
    
    var captionLabel: UILabel!
    var reactionsContainer: UIView!
    var reactionsBorder: UIView!
    var reactionOrderingLabel: UILabel!
    var reactionUpLabel: UILabel!
    var reactionDownLabel: UILabel!
    var reactionOrderingIcon: UIImageView!
    var reactionUpIcon: UIImageView!
    var reactionDownIcon: UIImageView!
    var reactionOrderingLabelLabel: UILabel!
    var reactionUpLabelLabel: UILabel!
    var reactionDownLabelLabel: UILabel!
    
    var timer: Timer?
    
    init(strategy: Strategy) {
        self.strategy = strategy
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Strategy Detail"
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
            headerContainer.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 0),
            headerContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            headerContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            headerContainer.heightAnchor.constraint(equalToConstant: 84),
        ])
        NSLayoutConstraint.activate([
            avatarContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            avatarContainer.leftAnchor.constraint(equalTo: headerContainer.leftAnchor, constant: 10),
            avatarContainer.widthAnchor.constraint(equalToConstant: 60),
            avatarContainer.heightAnchor.constraint(equalToConstant: 60),
        ])
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatar.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
        ])
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: avatarContainer.rightAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            usernameLabel.leftAnchor.constraint(equalTo: avatarContainer.rightAnchor, constant: 10),
            usernameLabel.widthAnchor.constraint(equalToConstant: 150),
            usernameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            ageLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            ageLabel.widthAnchor.constraint(equalToConstant: 150),
            ageLabel.heightAnchor.constraint(equalToConstant: 15),
        ])
        NSLayoutConstraint.activate([
            windowLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 0),
            windowLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            windowLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            windowLabelLabel.topAnchor.constraint(equalTo: windowLabel.bottomAnchor, constant: 0),
            windowLabelLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            windowLabelLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabelLabel.heightAnchor.constraint(equalToConstant: 10),
        ])
        NSLayoutConstraint.activate([
            footerContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
            footerContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            footerContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            footerContainer.heightAnchor.constraint(equalToConstant: 300),
        ])
        NSLayoutConstraint.activate([
            footerBorder.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 0),
            footerBorder.leftAnchor.constraint(equalTo: footerContainer.leftAnchor, constant: 10),
            footerBorder.rightAnchor.constraint(equalTo: footerContainer.rightAnchor, constant: -10),
            footerBorder.heightAnchor.constraint(equalToConstant: 1),
        ])
        NSLayoutConstraint.activate([
            orderButtonContainer.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: 0),
            orderButtonContainer.leftAnchor.constraint(equalTo: footerContainer.leftAnchor, constant: 0),
            orderButtonContainer.rightAnchor.constraint(equalTo: footerContainer.rightAnchor, constant: 0),
            orderButtonContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            orderButton.topAnchor.constraint(equalTo: orderButtonContainer.topAnchor, constant: 10),
            orderButton.leftAnchor.constraint(equalTo: footerContainer.leftAnchor, constant: 10),
            orderButton.rightAnchor.constraint(equalTo: footerContainer.rightAnchor, constant: -10),
            orderButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            orderButtonLabel.topAnchor.constraint(equalTo: orderButton.topAnchor, constant: 0),
            orderButtonLabel.leftAnchor.constraint(equalTo: orderButton.leftAnchor, constant: 0),
            orderButtonLabel.rightAnchor.constraint(equalTo: orderButton.rightAnchor, constant: 0),
            orderButtonLabel.bottomAnchor.constraint(equalTo: orderButton.bottomAnchor, constant: 0),
        ])
        
        NSLayoutConstraint.activate([
            reactionsContainer.bottomAnchor.constraint(equalTo: orderButtonContainer.topAnchor, constant: -10),
            reactionsContainer.leftAnchor.constraint(equalTo: footerContainer.leftAnchor, constant: 10),
            reactionsContainer.rightAnchor.constraint(equalTo: footerContainer.rightAnchor, constant: -10),
            reactionsContainer.heightAnchor.constraint(equalToConstant: 110),
        ])
        NSLayoutConstraint.activate([
            reactionsBorder.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 0),
            reactionsBorder.leftAnchor.constraint(equalTo: reactionsContainer.leftAnchor, constant: 0),
            reactionsBorder.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: 0),
            reactionsBorder.heightAnchor.constraint(equalToConstant: 1),
        ])
        
        NSLayoutConstraint.activate([
            reactionUpLabelLabel.bottomAnchor.constraint(equalTo: reactionsContainer.bottomAnchor, constant: -10),
            reactionUpLabelLabel.centerXAnchor.constraint(equalTo: reactionsContainer.centerXAnchor),
            reactionUpLabelLabel.widthAnchor.constraint(equalToConstant: 100),
            reactionUpLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            reactionOrderingLabelLabel.bottomAnchor.constraint(equalTo: reactionsContainer.bottomAnchor, constant: -10),
            reactionOrderingLabelLabel.leftAnchor.constraint(equalTo: reactionsContainer.leftAnchor, constant: 10),
            reactionOrderingLabelLabel.rightAnchor.constraint(equalTo: reactionUpLabelLabel.leftAnchor, constant: -5),
            reactionOrderingLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            reactionDownLabelLabel.bottomAnchor.constraint(equalTo: reactionsContainer.bottomAnchor, constant: -10),
            reactionDownLabelLabel.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: -10),
            reactionDownLabelLabel.leftAnchor.constraint(equalTo: reactionUpLabelLabel.rightAnchor, constant: 5),
            reactionDownLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        NSLayoutConstraint.activate([
            reactionUpIcon.bottomAnchor.constraint(equalTo: reactionUpLabelLabel.topAnchor, constant: -5),
            reactionUpIcon.centerXAnchor.constraint(equalTo: reactionUpLabelLabel.centerXAnchor),
            reactionUpIcon.widthAnchor.constraint(equalToConstant: 30),
            reactionUpIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            reactionOrderingIcon.bottomAnchor.constraint(equalTo: reactionOrderingLabelLabel.topAnchor, constant: -5),
            reactionOrderingIcon.centerXAnchor.constraint(equalTo: reactionOrderingLabelLabel.centerXAnchor),
            reactionOrderingIcon.widthAnchor.constraint(equalToConstant: 30),
            reactionOrderingIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            reactionDownIcon.bottomAnchor.constraint(equalTo: reactionDownLabelLabel.topAnchor, constant: -5),
            reactionDownIcon.centerXAnchor.constraint(equalTo: reactionDownLabelLabel.centerXAnchor),
            reactionDownIcon.widthAnchor.constraint(equalToConstant: 30),
            reactionDownIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            reactionUpLabel.bottomAnchor.constraint(equalTo: reactionUpIcon.topAnchor, constant: -5),
            reactionUpLabel.centerXAnchor.constraint(equalTo: reactionsContainer.centerXAnchor),
            reactionUpLabel.widthAnchor.constraint(equalToConstant: 100),
            reactionUpLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            reactionOrderingLabel.bottomAnchor.constraint(equalTo: reactionOrderingIcon.topAnchor, constant: -5),
            reactionOrderingLabel.leftAnchor.constraint(equalTo: reactionsContainer.leftAnchor, constant: 10),
            reactionOrderingLabel.rightAnchor.constraint(equalTo: reactionUpLabel.leftAnchor, constant: -5),
            reactionOrderingLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        NSLayoutConstraint.activate([
            reactionDownLabel.bottomAnchor.constraint(equalTo: reactionDownIcon.topAnchor, constant: -5),
            reactionDownLabel.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: -10),
            reactionDownLabel.leftAnchor.constraint(equalTo: reactionUpLabel.rightAnchor, constant: 5),
            reactionDownLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        
        NSLayoutConstraint.activate([
            captionLabel.bottomAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: -5),
            captionLabel.leftAnchor.constraint(equalTo: footerContainer.leftAnchor, constant: 10),
            captionLabel.rightAnchor.constraint(equalTo: footerContainer.rightAnchor, constant: -10),
            captionLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
        NSLayoutConstraint.activate([
            orderTableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            orderTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 0),
            orderTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: 0),
            orderTableView.bottomAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 0),
        ])
        
        updateStrategyData(strategy: strategy)
        configureTimer(expiration: strategy.windowExpiration / 1000)
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
        self.timer?.invalidate()
        self.timer = nil
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
        
        headerContainer = UIView()
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(headerContainer)
        
        avatarContainer = UIView()
        avatarContainer.backgroundColor = Settings.Theme.Color.grayUltraDark
        avatarContainer.layer.cornerRadius = 30
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(avatarContainer)
        
        avatar = UIImageView()
        avatar.layer.cornerRadius = 28
        avatar.contentMode = UIView.ContentMode.scaleAspectFit
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatar)
        
        nameLabel = UILabel()
        nameLabel.backgroundColor = Settings.Theme.Color.grayUltraDark
        nameLabel.layer.cornerRadius = 5
        nameLabel.layer.masksToBounds = true
        nameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 18)
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.text = ""
        nameLabel.isUserInteractionEnabled = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(nameLabel)
        
        usernameLabel = UILabel()
        usernameLabel.backgroundColor = Settings.Theme.Color.grayUltraDark
        usernameLabel.layer.cornerRadius = 5
        usernameLabel.layer.masksToBounds = true
        usernameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 16)
        usernameLabel.textAlignment = NSTextAlignment.left
        usernameLabel.numberOfLines = 1
        usernameLabel.text = ""
        usernameLabel.isUserInteractionEnabled = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(usernameLabel)
        
        ageLabel = UILabel()
        ageLabel.backgroundColor = .clear
        ageLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 14)
        ageLabel.textColor = Settings.Theme.Color.textGrayMedium
        ageLabel.textAlignment = NSTextAlignment.right
        ageLabel.numberOfLines = 1
        ageLabel.isUserInteractionEnabled = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(ageLabel)
        
        windowLabel = UILabel()
        windowLabel.backgroundColor = .clear
        windowLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 30)
        windowLabel.textColor = Settings.Theme.Color.primary
        windowLabel.textAlignment = NSTextAlignment.right
        windowLabel.numberOfLines = 1
        windowLabel.text = ""
        windowLabel.isUserInteractionEnabled = false
        windowLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(windowLabel)
        
        windowLabelLabel = UILabel()
        windowLabelLabel.backgroundColor = .clear
        windowLabelLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 9)
        windowLabelLabel.textColor = Settings.Theme.Color.primary
        windowLabelLabel.textAlignment = NSTextAlignment.right
        windowLabelLabel.numberOfLines = 1
        windowLabelLabel.text = "OPPORTUNITY WINDOW REMAINING"
        windowLabelLabel.isUserInteractionEnabled = false
        windowLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(windowLabelLabel)
        
        footerContainer = UIView()
//        footerContainer.backgroundColor = .red
        footerContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(footerContainer)
        
        orderButtonContainer = UIView()
//        orderButtonContainer.backgroundColor = Settings.Theme.Color.background
        orderButtonContainer.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(orderButtonContainer)
        
        orderButton = UIView()
        orderButton.backgroundColor = Settings.Theme.Color.grayUltraDark
        orderButton.layer.cornerRadius = 25
//        orderButton.layer.borderWidth = 1
//        orderButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        orderButton.translatesAutoresizingMaskIntoConstraints = false
        orderButtonContainer.addSubview(orderButton)
        
        orderButtonLabel = UILabel()
        orderButtonLabel.backgroundColor = .clear
        orderButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 20)
        orderButtonLabel.textColor = Settings.Theme.Color.textGrayTrueDark
        orderButtonLabel.textAlignment = NSTextAlignment.center
        orderButtonLabel.numberOfLines = 1
        orderButtonLabel.text = "BROKERAGE ORDER COMING SOON"
        orderButtonLabel.isUserInteractionEnabled = false
        orderButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        orderButton.addSubview(orderButtonLabel)
        
        reactionsContainer = UIView()
//        reactionsContainer.backgroundColor = .blue
        reactionsContainer.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(reactionsContainer)
        
        reactionOrderingIcon = UIImageView()
        reactionOrderingIcon.layer.cornerRadius = 12
        reactionOrderingIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionOrderingIcon.clipsToBounds = true
        reactionOrderingIcon.isUserInteractionEnabled = true
        reactionOrderingIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingIcon)
        
        let reactionOrderingGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionOrderingTap))
        reactionOrderingGestureRecognizer.numberOfTapsRequired = 1
        reactionOrderingIcon.addGestureRecognizer(reactionOrderingGestureRecognizer)
        
        reactionUpIcon = UIImageView()
        reactionUpIcon.layer.cornerRadius = 12
        reactionUpIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionUpIcon.clipsToBounds = true
        reactionUpIcon.isUserInteractionEnabled = true
        reactionUpIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionUpIcon)
        
        let reactionUpGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionUpTap))
        reactionUpGestureRecognizer.numberOfTapsRequired = 1
        reactionUpIcon.addGestureRecognizer(reactionUpGestureRecognizer)
        
        reactionDownIcon = UIImageView()
        reactionDownIcon.layer.cornerRadius = 12
        reactionDownIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionDownIcon.clipsToBounds = true
        reactionDownIcon.isUserInteractionEnabled = true
        reactionDownIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDownIcon)
        
        let reactionDownGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionDownTap))
        reactionDownGestureRecognizer.numberOfTapsRequired = 1
        reactionDownIcon.addGestureRecognizer(reactionDownGestureRecognizer)
        
        reactionOrderingLabel = UILabel()
        reactionOrderingLabel.backgroundColor = .clear
        reactionOrderingLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionOrderingLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionOrderingLabel.textAlignment = NSTextAlignment.center
        reactionOrderingLabel.numberOfLines = 1
        reactionOrderingLabel.isUserInteractionEnabled = false
        reactionOrderingLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingLabel)
        
        reactionUpLabel = UILabel()
        reactionUpLabel.backgroundColor = .clear
        reactionUpLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionUpLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionUpLabel.textAlignment = NSTextAlignment.center
        reactionUpLabel.numberOfLines = 1
        reactionUpLabel.isUserInteractionEnabled = false
        reactionUpLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionUpLabel)
        
        reactionDownLabel = UILabel()
        reactionDownLabel.backgroundColor = .clear
        reactionDownLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionDownLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionDownLabel.textAlignment = NSTextAlignment.center
        reactionDownLabel.numberOfLines = 1
        reactionDownLabel.isUserInteractionEnabled = false
        reactionDownLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDownLabel)
        
        reactionOrderingLabelLabel = UILabel()
        reactionOrderingLabelLabel.backgroundColor = .clear
        reactionOrderingLabelLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        reactionOrderingLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionOrderingLabelLabel.textAlignment = NSTextAlignment.center
        reactionOrderingLabelLabel.numberOfLines = 1
        reactionOrderingLabelLabel.text = "I'M ORDERING"
        reactionOrderingLabelLabel.isUserInteractionEnabled = false
        reactionOrderingLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingLabelLabel)
        
        reactionUpLabelLabel = UILabel()
        reactionUpLabelLabel.backgroundColor = .clear
        reactionUpLabelLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        reactionUpLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionUpLabelLabel.textAlignment = NSTextAlignment.center
        reactionUpLabelLabel.numberOfLines = 1
        reactionUpLabelLabel.text = "GOOD IDEA"
        reactionUpLabelLabel.isUserInteractionEnabled = false
        reactionUpLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionUpLabelLabel)
        
        reactionDownLabelLabel = UILabel()
        reactionDownLabelLabel.backgroundColor = .clear
        reactionDownLabelLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        reactionDownLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionDownLabelLabel.textAlignment = NSTextAlignment.center
        reactionDownLabelLabel.numberOfLines = 1
        reactionDownLabelLabel.text = "I DISAGREE"
        reactionDownLabelLabel.isUserInteractionEnabled = false
        reactionDownLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDownLabelLabel)
        
        reactionsBorder = UIView()
        reactionsBorder.layer.borderWidth = 1
        reactionsBorder.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        reactionsBorder.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(reactionsBorder)
        
        captionLabel = UILabel()
        captionLabel.backgroundColor = .clear
        captionLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 14)
        captionLabel.textColor = Settings.Theme.Color.textGrayLight
        captionLabel.textAlignment = NSTextAlignment.left
        captionLabel.numberOfLines = 2
        captionLabel.lineBreakMode = .byTruncatingTail
        captionLabel.isUserInteractionEnabled = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(captionLabel)
        
        footerBorder = UIView()
        footerBorder.layer.borderWidth = 1
        footerBorder.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        footerBorder.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(footerBorder)
        
        orderTableView = UITableView()
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.dragInteractionEnabled = false
        orderTableView.register(StrategyDetailCell.self, forCellReuseIdentifier: orderTableCellIdentifier)
        orderTableView.separatorStyle = .none
        orderTableView.backgroundColor = .clear
        orderTableView.isSpringLoaded = true
        orderTableView.estimatedRowHeight = 145
        orderTableView.estimatedSectionHeaderHeight = 0
        orderTableView.estimatedSectionFooterHeight = 0
        orderTableView.isScrollEnabled = true
        orderTableView.bounces = true
        orderTableView.alwaysBounceVertical = true
        orderTableView.showsVerticalScrollIndicator = false
        orderTableView.isUserInteractionEnabled = true
        orderTableView.allowsSelection = true
//        orderTableView.delaysContentTouches = false
        orderTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        orderTableView.insetsContentViewsToSafeArea = true
        orderTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(orderTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    // Set a timer to recalculate the opportunity window remaining every second
    // Both time intervals should be in seconds - milliseconds are not displayed
    func configureTimer(expiration: TimeInterval) {
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                let timeRemaining = self.calculateTimeRemaining(expiration: expiration)
                if timeRemaining <= 0 {
                    // Set strategy as expired
                    self.windowLabel.text = "EXPIRED"
                } else {
                    self.windowLabel.text = Strategy.secondsRemainToString(seconds: Int(timeRemaining))
                }
            }
        }
    }
    private func calculateTimeRemaining(expiration: TimeInterval) -> Double {
        return Double(expiration - Date().timeIntervalSince1970)
    }
    
    func updateStrategyData(strategy: Strategy) {
        self.strategy = strategy
        
        nameLabel.textColor = Settings.Theme.Color.textGrayLight
        usernameLabel.textColor = Settings.Theme.Color.textGrayMedium
        ageLabel.text = Strategy.ageString(timestamp: strategy.created)
        captionLabel.text = strategy.caption
        
        if let reactions = strategy.reactions {
            let reactionCounts = StrategyReactionCount(reactions: reactions)
            reactionOrderingLabel.text = "\(reactionCounts.ordering.total)"
            reactionOrderingIcon.image = reactionCounts.ordering.account ? Assets.Icons.iconOrderingFill : Assets.Icons.iconOrdering
            reactionUpLabel.text = "\(reactionCounts.up.total)"
            reactionUpIcon.image = reactionCounts.up.account ? Assets.Icons.iconUpFill : Assets.Icons.iconUp
            reactionDownLabel.text = "\(reactionCounts.down.total)"
            reactionDownIcon.image = reactionCounts.down.account ? Assets.Icons.iconDownFill : Assets.Icons.iconDown
        }
        orderTableView.reloadData()
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func reactionOrderingTap(_ sender: UITapGestureRecognizer) {
        guard let parent = self.delegate else { return }
        guard let sId = strategy.id else { return }
        parent.reaction(strategyId: sId, type: 0)
    }
    @objc func reactionUpTap(_ sender: UITapGestureRecognizer) {
        guard let parent = self.delegate else { return }
        guard let sId = strategy.id else { return }
        parent.reaction(strategyId: sId, type: 1)
    }
    @objc func reactionDownTap(_ sender: UITapGestureRecognizer) {
        guard let parent = self.delegate else { return }
        guard let sId = strategy.id else { return }
        parent.reaction(strategyId: sId, type: 2)
    }
}
