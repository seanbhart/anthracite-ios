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
    var ageLabel: UILabel!
    var windowLabel: UILabel!
    var windowLabelLabel: UILabel!
    var ordersContainer: UIView!
    var reactionsContainer: UIView!
    var reactionOrderingIcon: UIImageView!
    var reactionOrderingLabel: UILabel!
    var reactionLikeIcon: UIImageView!
    var reactionLikeLabel: UILabel!
    var reactionDislikeIcon: UIImageView!
    var reactionDislikeLabel: UILabel!
    
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
        contentContainer.backgroundColor = Settings.Theme.Color.contentBackground
        contentContainer.layer.cornerRadius = 10
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 3),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -3),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 10),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -10),
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
        
        ageLabel = UILabel()
        ageLabel.backgroundColor = .clear
        ageLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 18)
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
            ageLabel.heightAnchor.constraint(equalToConstant: 22),
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
        windowLabelLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        windowLabelLabel.textColor = Settings.Theme.Color.primary
        windowLabelLabel.textAlignment = NSTextAlignment.right
        windowLabelLabel.numberOfLines = 1
        windowLabelLabel.text = "OPPORTUNITY WINDOW"
        windowLabelLabel.isUserInteractionEnabled = false
        windowLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(windowLabelLabel)
        NSLayoutConstraint.activate([
            windowLabelLabel.topAnchor.constraint(equalTo: windowLabel.bottomAnchor, constant: 0),
            windowLabelLabel.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -10),
            windowLabelLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabelLabel.heightAnchor.constraint(equalToConstant: 14),
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
        reactionOrderingIcon.image = UIImage(systemName: "dollarsign.circle")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
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
        reactionLikeIcon.image = UIImage(systemName: "hand.thumbsup")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
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
        reactionDislikeIcon.image = UIImage(systemName: "hand.thumbsdown")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
        reactionDislikeIcon.contentMode = UIView.ContentMode.scaleAspectFit
        reactionDislikeIcon.clipsToBounds = true
        reactionDislikeIcon.isUserInteractionEnabled = true
        reactionDislikeIcon.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionDislikeIcon)
        NSLayoutConstraint.activate([
            reactionDislikeIcon.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 18),
            reactionDislikeIcon.rightAnchor.constraint(equalTo: reactionsContainer.rightAnchor, constant: -50),
            reactionDislikeIcon.widthAnchor.constraint(equalToConstant: 24),
            reactionDislikeIcon.heightAnchor.constraint(equalToConstant: 24),
        ])
        
        reactionOrderingLabel = UILabel()
        reactionOrderingLabel.backgroundColor = .clear
        reactionOrderingLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionOrderingLabel.textColor = Settings.Theme.Color.primary
        reactionOrderingLabel.textAlignment = NSTextAlignment.left
        reactionOrderingLabel.numberOfLines = 1
        reactionOrderingLabel.text = "0"
        reactionOrderingLabel.isUserInteractionEnabled = false
        reactionOrderingLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionOrderingLabel)
        NSLayoutConstraint.activate([
            reactionOrderingLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionOrderingLabel.leftAnchor.constraint(equalTo: reactionOrderingIcon.rightAnchor, constant: 2),
            reactionOrderingLabel.rightAnchor.constraint(equalTo: reactionLikeIcon.leftAnchor, constant: 0),
            reactionOrderingLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionLikeLabel = UILabel()
        reactionLikeLabel.backgroundColor = .clear
        reactionLikeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionLikeLabel.textColor = Settings.Theme.Color.primary
        reactionLikeLabel.textAlignment = NSTextAlignment.left
        reactionLikeLabel.numberOfLines = 1
        reactionLikeLabel.text = "0"
        reactionLikeLabel.isUserInteractionEnabled = false
        reactionLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        reactionsContainer.addSubview(reactionLikeLabel)
        NSLayoutConstraint.activate([
            reactionLikeLabel.topAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 15),
            reactionLikeLabel.leftAnchor.constraint(equalTo: reactionLikeIcon.rightAnchor, constant: 2),
            reactionLikeLabel.rightAnchor.constraint(equalTo: reactionDislikeIcon.leftAnchor, constant: 0),
            reactionLikeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        reactionDislikeLabel = UILabel()
        reactionDislikeLabel.backgroundColor = .clear
        reactionDislikeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 24)
        reactionDislikeLabel.textColor = Settings.Theme.Color.primary
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
        
        ordersContainer = UIView()
//        ordersContainer.backgroundColor = .red
        ordersContainer.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(ordersContainer)
        NSLayoutConstraint.activate([
            ordersContainer.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0),
            ordersContainer.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 80),
            ordersContainer.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            ordersContainer.bottomAnchor.constraint(equalTo: reactionsContainer.topAnchor, constant: 0),
        ])
        
//        let symbolLabel = UILabel()
//        symbolLabel.backgroundColor = .clear
//        symbolLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 40)
//        symbolLabel.textColor = Settings.Theme.Color.positive
//        symbolLabel.textAlignment = NSTextAlignment.left
//        symbolLabel.numberOfLines = 1
//        symbolLabel.text = "TSLA"
//        symbolLabel.isUserInteractionEnabled = false
//        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
//        ordersContainer.addSubview(symbolLabel)
//        NSLayoutConstraint.activate([
//            symbolLabel.topAnchor.constraint(equalTo: ordersContainer.topAnchor, constant: 5),
//            symbolLabel.leftAnchor.constraint(equalTo: ordersContainer.leftAnchor, constant: 10),
//            symbolLabel.widthAnchor.constraint(equalToConstant: 100),
////            symbolLabel.heightAnchor.constraint(equalToConstant: 40),
//            symbolLabel.bottomAnchor.constraint(equalTo: ordersContainer.bottomAnchor, constant: 0),
//        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Analytics.logEvent(TableCellError, parameters: [
//            AnalyticsParameterMethod: "apple.com"
//        ])
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func layoutSubviews() {
//    }
    
//    override func prepareForReuse() {
////        cellContainer = UIView()
//    }
    
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

