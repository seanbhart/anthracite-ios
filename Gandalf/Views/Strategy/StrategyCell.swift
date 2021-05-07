//
//  StrategyCell.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit
//import FirebaseAnalytics

protocol StrategyCellDelegate {
    func reaction(strategyId: String, type: Int)
}

class StrategyCell: UITableViewCell {
    
    var delegate: StrategyCellDelegate!
    var strategy: Strategy!
    
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
    var reactionUpIcon: UIImageView!
    var reactionUpLabel: UILabel!
    var reactionDownIcon: UIImageView!
    var reactionDownLabel: UILabel!
    var borderBottom: UIView!
    
    var timer: Timer?
    
    // Set a timer to recalculate the opportunity window remaining every second
    // Both time intervals should be in seconds - milliseconds are not displayed
    func configureCellTimer(expiration: TimeInterval) {
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
        reactionOrderingIcon.image = UIImage(systemName: "dollarsign.circle")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        reactionOrderingIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionOrderingIcon.clipsToBounds = true
        reactionOrderingIcon.isUserInteractionEnabled = true
        reactionOrderingIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingIcon)
        NSLayoutConstraint.activate([
            reactionOrderingIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 20),
            reactionOrderingIcon.leftAnchor.constraint(equalTo: reactionsContainer.leftAnchor, constant: 0),
            reactionOrderingIcon.widthAnchor.constraint(equalToConstant: 20),
            reactionOrderingIcon.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        let reactionOrderingGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionOrderingTap))
        reactionOrderingGestureRecognizer.numberOfTapsRequired = 1
        reactionOrderingIcon.addGestureRecognizer(reactionOrderingGestureRecognizer)
        
        reactionUpIcon = UIImageView()
        reactionUpIcon.image = UIImage(systemName: "arrowtriangle.up")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        reactionUpIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionUpIcon.clipsToBounds = true
        reactionUpIcon.isUserInteractionEnabled = true
        reactionUpIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionUpIcon)
        NSLayoutConstraint.activate([
            reactionUpIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 20),
            reactionUpIcon.centerXAnchor.constraint(equalTo: reactionsContainer.centerXAnchor, constant: -25),
            reactionUpIcon.widthAnchor.constraint(equalToConstant: 20),
            reactionUpIcon.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        let reactionUpGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionUpTap))
        reactionUpGestureRecognizer.numberOfTapsRequired = 1
        reactionUpIcon.addGestureRecognizer(reactionUpGestureRecognizer)
        
        reactionDownIcon = UIImageView()
        reactionDownIcon.image = UIImage(systemName: "arrowtriangle.down")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        reactionDownIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionDownIcon.clipsToBounds = true
        reactionDownIcon.isUserInteractionEnabled = true
        reactionDownIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDownIcon)
        NSLayoutConstraint.activate([
            reactionDownIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 20),
            reactionDownIcon.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: -53),
            reactionDownIcon.widthAnchor.constraint(equalToConstant: 20),
            reactionDownIcon.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        let reactionDownGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(reactionDownTap))
        reactionDownGestureRecognizer.numberOfTapsRequired = 1
        reactionDownIcon.addGestureRecognizer(reactionDownGestureRecognizer)
        
        reactionOrderingLabel = UILabel()
        reactionOrderingLabel.backgroundColor = .clear
        reactionOrderingLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionOrderingLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionOrderingLabel.textAlignment = NSTextAlignment.left
        reactionOrderingLabel.numberOfLines = 1
        reactionOrderingLabel.text = "0"
        reactionOrderingLabel.isUserInteractionEnabled = false
        reactionOrderingLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingLabel)
        NSLayoutConstraint.activate([
            reactionOrderingLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionOrderingLabel.leftAnchor.constraint(equalTo: reactionOrderingIcon.rightAnchor, constant: 3),
            reactionOrderingLabel.rightAnchor.constraint(equalTo: reactionUpIcon.leftAnchor, constant: 0),
            reactionOrderingLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionUpLabel = UILabel()
        reactionUpLabel.backgroundColor = .clear
        reactionUpLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionUpLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionUpLabel.textAlignment = NSTextAlignment.left
        reactionUpLabel.numberOfLines = 1
        reactionUpLabel.text = "0"
        reactionUpLabel.isUserInteractionEnabled = false
        reactionUpLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionUpLabel)
        NSLayoutConstraint.activate([
            reactionUpLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionUpLabel.leftAnchor.constraint(equalTo: reactionUpIcon.rightAnchor, constant: 3),
            reactionUpLabel.rightAnchor.constraint(equalTo: reactionDownIcon.leftAnchor, constant: 0),
            reactionUpLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionDownLabel = UILabel()
        reactionDownLabel.backgroundColor = .clear
        reactionDownLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionDownLabel.textColor = Settings.Theme.Color.textGrayMedium
        reactionDownLabel.textAlignment = NSTextAlignment.left
        reactionDownLabel.numberOfLines = 1
        reactionDownLabel.text = "0"
        reactionDownLabel.isUserInteractionEnabled = false
        reactionDownLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDownLabel)
        NSLayoutConstraint.activate([
            reactionDownLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionDownLabel.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: 0),
            reactionDownLabel.widthAnchor.constraint(equalToConstant: 50),
            reactionDownLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        captionLabel = UILabel()
        captionLabel.backgroundColor = .clear
        captionLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        captionLabel.textColor = Settings.Theme.Color.textGrayLight
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
        
        borderBottom = UIView()
        borderBottom.layer.borderWidth = 1
        borderBottom.layer.borderColor = Settings.Theme.Color.background.cgColor
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
    
    func showBorder() {
        borderBottom.layer.borderColor = Settings.Theme.Color.grayUltraDark.cgColor
    }
    func hideBorder() {
        borderBottom.layer.borderColor = Settings.Theme.Color.background.cgColor
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
