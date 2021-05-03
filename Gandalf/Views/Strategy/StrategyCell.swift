//
//  StrategyCell.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit
//import FirebaseAnalytics

class StrategyCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var headerContainer: UIView!
    var avatarContainer: UIView!
    var avatar: UIImageView!
    var nameLabel: UILabel!
    var usernameLabel: UILabel!
    var ageLabel: UILabel!
    var windowLabel: UILabel!
    var windowLabelLabel: UILabel!
    var ordersContainer: UIView!
    var captionLabel: UILabel!
    var reactionsContainer: UIView!
    var reactionOrderingIcon: UIImageView!
    var reactionOrderingLabel: UILabel!
    var reactionLikeIcon: UIImageView!
    var reactionLikeLabel: UILabel!
    var reactionDislikeIcon: UIImageView!
    var reactionDislikeLabel: UILabel!
    
    var timer: Timer?
    
    // Set a timer to recalculate the opportunity window remaining every second
    // Both time intervals should be in seconds - milliseconds are not displayed
    func configureCell(withCountdownTimer countdownTimer: (createdAt: TimeInterval, duration: TimeInterval)) {
        
        if self.timer == nil {
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
                let timeRemaining = self.calculateTimeRemaining(countdownTimer: countdownTimer)
                if timeRemaining <= 0 {
                    // Set strategy as expired
                    self.windowLabel.text = "EXPIRED"
                } else {
                    self.windowLabel.text = Strategy.secondsRemainToString(seconds: Int(timeRemaining))
                }
            }
        }
    }
    
    func calculateTimeRemaining(countdownTimer:(createdAt: TimeInterval, duration: TimeInterval)) -> Double {
        return Double((countdownTimer.createdAt + countdownTimer.duration) - Date().timeIntervalSince1970)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.Color.background
        
        cellContainer = UIView()
        cellContainer.backgroundColor = Settings.Theme.Color.background
        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cellContainer)
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cellContainer.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            cellContainer.rightAnchor.constraint(equalTo: contentView.rightAnchor),
        ])
        
        contentContainer = UIView()
//        contentContainer.backgroundColor = Settings.Theme.Color.contentBackground
//        contentContainer.layer.cornerRadius = 10
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 3),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -3),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 0),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: 0),
        ])
        
        headerContainer = UIView()
//        headerContainer.backgroundColor = Settings.Theme.Color.grayLight
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(headerContainer)
        NSLayoutConstraint.activate([
            headerContainer.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 0),
            headerContainer.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 0),
            headerContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: 0),
            headerContainer.heightAnchor.constraint(equalToConstant: 84),
        ])
        
        avatarContainer = UIView()
        avatarContainer.backgroundColor = Settings.Theme.Color.grayUltraDark
        avatarContainer.layer.cornerRadius = 30
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(avatarContainer)
        NSLayoutConstraint.activate([
            avatarContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            avatarContainer.leftAnchor.constraint(equalTo: headerContainer.leftAnchor, constant: 10),
            avatarContainer.widthAnchor.constraint(equalToConstant: 60),
            avatarContainer.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        avatar = UIImageView()
        avatar.layer.cornerRadius = 28
        avatar.contentMode = UIView.ContentMode.scaleAspectFit
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.addSubview(avatar)
        NSLayoutConstraint.activate([
            avatar.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor),
            avatar.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 56),
            avatar.heightAnchor.constraint(equalToConstant: 56),
        ])
        
        nameLabel = UILabel()
        nameLabel.backgroundColor = Settings.Theme.Color.grayUltraDark
        nameLabel.layer.cornerRadius = 5
        nameLabel.layer.masksToBounds = true
        nameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 18)
        nameLabel.textColor = Settings.Theme.Color.textGrayLight
        nameLabel.textAlignment = NSTextAlignment.left
        nameLabel.numberOfLines = 1
        nameLabel.text = ""
        nameLabel.isUserInteractionEnabled = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(nameLabel)
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            nameLabel.leftAnchor.constraint(equalTo: avatarContainer.rightAnchor, constant: 10),
            nameLabel.widthAnchor.constraint(equalToConstant: 150),
            nameLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        usernameLabel = UILabel()
        usernameLabel.backgroundColor = Settings.Theme.Color.grayUltraDark
        usernameLabel.layer.cornerRadius = 5
        usernameLabel.layer.masksToBounds = true
        usernameLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 16)
        usernameLabel.textColor = Settings.Theme.Color.textGrayMedium
        usernameLabel.textAlignment = NSTextAlignment.left
        usernameLabel.numberOfLines = 1
        usernameLabel.text = ""
        usernameLabel.isUserInteractionEnabled = false
        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(usernameLabel)
        NSLayoutConstraint.activate([
            usernameLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 2),
            usernameLabel.leftAnchor.constraint(equalTo: avatarContainer.rightAnchor, constant: 10),
            usernameLabel.widthAnchor.constraint(equalToConstant: 150),
            usernameLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        ageLabel = UILabel()
        ageLabel.backgroundColor = .clear
        ageLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 14)
        ageLabel.textColor = Settings.Theme.Color.textGrayMedium
        ageLabel.textAlignment = NSTextAlignment.right
        ageLabel.numberOfLines = 1
        ageLabel.text = ""
        ageLabel.isUserInteractionEnabled = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 10),
            ageLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            ageLabel.widthAnchor.constraint(equalToConstant: 150),
            ageLabel.heightAnchor.constraint(equalToConstant: 15),
        ])

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
        NSLayoutConstraint.activate([
            windowLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 0),
            windowLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            windowLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabel.heightAnchor.constraint(equalToConstant: 30),
        ])

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
        NSLayoutConstraint.activate([
            windowLabelLabel.topAnchor.constraint(equalTo: windowLabel.bottomAnchor, constant: 0),
            windowLabelLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            windowLabelLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabelLabel.heightAnchor.constraint(equalToConstant: 10),
        ])
        
        reactionsContainer = UIView()
//        reactionsContainer.backgroundColor = .blue
        reactionsContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(reactionsContainer)
        NSLayoutConstraint.activate([
            reactionsContainer.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
            reactionsContainer.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 80),
            reactionsContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            reactionsContainer.heightAnchor.constraint(equalToConstant: 60),
        ])
        
        reactionOrderingIcon = UIImageView()
        reactionOrderingIcon.layer.cornerRadius = 12
        reactionOrderingIcon.image = UIImage(systemName: "dollarsign.circle")?.withTintColor(Settings.Theme.Color.textGrayLight, renderingMode: .alwaysOriginal)
        reactionOrderingIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionOrderingIcon.clipsToBounds = true
        reactionOrderingIcon.isUserInteractionEnabled = true
        reactionOrderingIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingIcon)
        NSLayoutConstraint.activate([
            reactionOrderingIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 18),
            reactionOrderingIcon.leftAnchor.constraint(equalTo: reactionsContainer.leftAnchor, constant: 0),
            reactionOrderingIcon.widthAnchor.constraint(equalToConstant: 24),
            reactionOrderingIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        reactionLikeIcon = UIImageView()
        reactionLikeIcon.layer.cornerRadius = 12
        reactionLikeIcon.image = UIImage(systemName: "hand.thumbsup")?.withTintColor(Settings.Theme.Color.textGrayLight, renderingMode: .alwaysOriginal)
        reactionLikeIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionLikeIcon.clipsToBounds = true
        reactionLikeIcon.isUserInteractionEnabled = true
        reactionLikeIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionLikeIcon)
        NSLayoutConstraint.activate([
            reactionLikeIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 18),
            reactionLikeIcon.centerXAnchor.constraint(equalTo: reactionsContainer.centerXAnchor, constant: -25),
            reactionLikeIcon.widthAnchor.constraint(equalToConstant: 24),
            reactionLikeIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        reactionDislikeIcon = UIImageView()
        reactionDislikeIcon.layer.cornerRadius = 12
        reactionDislikeIcon.image = UIImage(systemName: "hand.thumbsdown")?.withTintColor(Settings.Theme.Color.textGrayLight, renderingMode: .alwaysOriginal)
        reactionDislikeIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionDislikeIcon.clipsToBounds = true
        reactionDislikeIcon.isUserInteractionEnabled = true
        reactionDislikeIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDislikeIcon)
        NSLayoutConstraint.activate([
            reactionDislikeIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 18),
            reactionDislikeIcon.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: -53),
            reactionDislikeIcon.widthAnchor.constraint(equalToConstant: 24),
            reactionDislikeIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        reactionOrderingLabel = UILabel()
        reactionOrderingLabel.backgroundColor = .clear
        reactionOrderingLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionOrderingLabel.textColor = Settings.Theme.Color.textGrayLight
        reactionOrderingLabel.textAlignment = NSTextAlignment.left
        reactionOrderingLabel.numberOfLines = 1
        reactionOrderingLabel.text = "0"
        reactionOrderingLabel.isUserInteractionEnabled = false
        reactionOrderingLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingLabel)
        NSLayoutConstraint.activate([
            reactionOrderingLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionOrderingLabel.leftAnchor.constraint(equalTo: reactionOrderingIcon.rightAnchor, constant: 3),
            reactionOrderingLabel.rightAnchor.constraint(equalTo: reactionLikeIcon.leftAnchor, constant: 0),
            reactionOrderingLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionLikeLabel = UILabel()
        reactionLikeLabel.backgroundColor = .clear
        reactionLikeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionLikeLabel.textColor = Settings.Theme.Color.textGrayLight
        reactionLikeLabel.textAlignment = NSTextAlignment.left
        reactionLikeLabel.numberOfLines = 1
        reactionLikeLabel.text = "0"
        reactionLikeLabel.isUserInteractionEnabled = false
        reactionLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionLikeLabel)
        NSLayoutConstraint.activate([
            reactionLikeLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionLikeLabel.leftAnchor.constraint(equalTo: reactionLikeIcon.rightAnchor, constant: 3),
            reactionLikeLabel.rightAnchor.constraint(equalTo: reactionDislikeIcon.leftAnchor, constant: 0),
            reactionLikeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionDislikeLabel = UILabel()
        reactionDislikeLabel.backgroundColor = .clear
        reactionDislikeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionDislikeLabel.textColor = Settings.Theme.Color.textGrayLight
        reactionDislikeLabel.textAlignment = NSTextAlignment.left
        reactionDislikeLabel.numberOfLines = 1
        reactionDislikeLabel.text = "0"
        reactionDislikeLabel.isUserInteractionEnabled = false
        reactionDislikeLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDislikeLabel)
        NSLayoutConstraint.activate([
            reactionDislikeLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionDislikeLabel.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: 0),
            reactionDislikeLabel.widthAnchor.constraint(equalToConstant: 50),
            reactionDislikeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        captionLabel = UILabel()
        captionLabel.backgroundColor = .clear
        captionLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        captionLabel.textColor = Settings.Theme.Color.textGrayMedium
        captionLabel.textAlignment = NSTextAlignment.left
        captionLabel.numberOfLines = 2
        captionLabel.lineBreakMode = .byTruncatingTail
        captionLabel.text = ""
        captionLabel.isUserInteractionEnabled = false
        captionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(captionLabel)
        NSLayoutConstraint.activate([
            captionLabel.bottomAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 0),
            captionLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 80),
            captionLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            captionLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        ordersContainer = UIView()
        ordersContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(ordersContainer)
        NSLayoutConstraint.activate([
            ordersContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            ordersContainer.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 80),
            ordersContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            ordersContainer.bottomAnchor.constraint(equalTo: captionLabel.topAnchor, constant: 0),
        ])
        
        let borderBottom = UIView()
        borderBottom.layer.borderWidth = 1
        borderBottom.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
        borderBottom.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(borderBottom)
        NSLayoutConstraint.activate([
            borderBottom.topAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
            borderBottom.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            borderBottom.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            borderBottom.heightAnchor.constraint(equalToConstant: 1),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Analytics.logEvent(TableCellError, parameters: [
//            AnalyticsParameterMethod: "apple.com"
//        ])
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//    }
    
    override func prepareForReuse() {
        print("prepareForReuse")
//        cellContainer = UIView()
        self.timer?.invalidate()
        self.timer = nil
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
//        print("SELECTED SETTINGS ADV CELL")
        super.setSelected(selected, animated: animated)
        if selected {
            contentView.backgroundColor = Settings.Theme.Color.background
        } else {
            contentView.backgroundColor = Settings.Theme.Color.background
        }
    }
}

