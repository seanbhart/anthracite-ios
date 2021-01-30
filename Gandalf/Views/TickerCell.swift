//
//  TickerCell.swift
//  Gandalf
//
//  Created by Sean Hart on 1/26/21.
//

import UIKit
//import FirebaseAnalytics

class TickerCell: UITableViewCell {
    var containerView: UIView!
    var containerBorder: UIView!
    var title: UILabel!
    var notionIcon: UIImageView!
    var countText: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.background
        
        // Create a container and set the frame (auto layout / constraints don't work in UICollectionViewCell?)
        containerView = UIView()
        containerView.backgroundColor = Settings.Theme.background
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo:contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo:contentView.rightAnchor),
        ])
        
        containerBorder = UIView()
        containerBorder.layer.borderColor = Settings.Theme.colorGrayDark.cgColor
        containerBorder.layer.borderWidth = 1
        containerBorder.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(containerBorder)
        NSLayoutConstraint.activate([
            containerBorder.topAnchor.constraint(equalTo:containerView.topAnchor),
            containerBorder.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            containerBorder.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            containerBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        title = UILabel()
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 20)
        title.textColor = Settings.Theme.text
        title.textAlignment = NSTextAlignment.center
        title.numberOfLines = 1
        title.text = ""
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            title.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -5),
            title.heightAnchor.constraint(equalToConstant:30),
        ])
        
        notionIcon = UIImageView()
        notionIcon.image = UIImage(named: Assets.Images.notionIconBlueLarge)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(notionIcon)
        NSLayoutConstraint.activate([
            notionIcon.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 0),
            notionIcon.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            notionIcon.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            notionIcon.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        countText = UILabel()
        countText.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 20)
        countText.textColor = Settings.Theme.text
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
            countText.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -5)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
//        Analytics.logEvent("vk_error", parameters: [
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
            contentView.backgroundColor = Settings.Theme.background
        } else {
            contentView.backgroundColor = Settings.Theme.background
        }
    }
}

