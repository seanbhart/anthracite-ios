//
//  MessageTickerCell.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
//import FirebaseAnalytics

class MessageTickerCell: UITableViewCell {
    var containerView: UIView!
    var title: UILabel!
    var notionIcon: UIImageView!
    var countText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.Color.contentBackground
        
        // Create a container and set the frame (auto layout / constraints don't work in UICollectionViewCell?)
        containerView = UIView()
        containerView.backgroundColor = Settings.Theme.Color.contentBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo:contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo:contentView.rightAnchor),
        ])
        
        title = UILabel()
        title.backgroundColor = .clear
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 20)
        title.textColor = Settings.Theme.Color.text
        title.textAlignment = NSTextAlignment.center
        title.numberOfLines = 1
        title.text = ""
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 15),
            title.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            title.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -5),
            title.heightAnchor.constraint(equalToConstant:30),
        ])
        
        notionIcon = UIImageView()
        notionIcon.backgroundColor = .clear
        notionIcon.image = UIImage(named: Assets.Images.notionIconGrayLg)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(notionIcon)
        NSLayoutConstraint.activate([
            notionIcon.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 5),
            notionIcon.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            notionIcon.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            notionIcon.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        countText = UILabel()
        countText.backgroundColor = .clear
        countText.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 20)
        countText.textColor = Settings.Theme.Color.text
        countText.textAlignment = NSTextAlignment.center
        countText.numberOfLines = 1
        countText.text = ""
        countText.isUserInteractionEnabled = false
        countText.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(countText)
        NSLayoutConstraint.activate([
            countText.topAnchor.constraint(equalTo:notionIcon.bottomAnchor, constant: 0),
            countText.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            countText.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -5),
            countText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -10)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Analytics.logEvent("gandalf_error", parameters: [
//            "class": "ShipmentBeanCell" as NSObject,
//            "function": "init" as NSObject,
//            "description": "init(coder:) has not been implemented" as NSObject
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
            contentView.backgroundColor = Settings.Theme.Color.selected
        } else {
            contentView.backgroundColor = Settings.Theme.Color.background
        }
    }
}
