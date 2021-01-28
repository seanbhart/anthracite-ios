//
//  TickerCell.swift
//  Gandalf
//
//  Created by Sean Hart on 1/26/21.
//

import UIKit
//import FirebaseAnalytics

class TickerCell: UITableViewCell {
    let bgColor = UIColor.white
    
    var containerView: UIView!
    var containerBorder: UIView!
    var title: UILabel!
    var itemImage: UIImageView!
    var progressViewContainer: UIView!
    var progressView: UIProgressView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.background
        
        // Create a container and set the frame (auto layout / constraints don't work in UICollectionViewCell?)
        containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo:contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            containerView.leftAnchor.constraint(equalTo:contentView.leftAnchor),
            containerView.rightAnchor.constraint(equalTo:contentView.rightAnchor),
        ])
        
        containerBorder = UIView()
        containerBorder.backgroundColor = bgColor
        containerBorder.layer.borderColor = Settings.Theme.colorGrayLight.cgColor
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
//        title.font = UIFont(name: Settings.Fonts.Regular.Bold, size: 16)
        title.textColor = Settings.Theme.text
        title.textAlignment = NSTextAlignment.left
        title.numberOfLines = 1
        title.text = ""
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 10),
            title.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            title.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            title.heightAnchor.constraint(equalToConstant:50),
        ])
        
        itemImage = UIImageView()
        itemImage.contentMode = UIView.ContentMode.scaleAspectFit
        itemImage.clipsToBounds = true
        itemImage.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(itemImage)
        NSLayoutConstraint.activate([
            itemImage.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 10),
            itemImage.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            itemImage.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            itemImage.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: -50),
        ])
        
        progressViewContainer = UIView()
        progressViewContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressViewContainer)
        NSLayoutConstraint.activate([
            progressViewContainer.topAnchor.constraint(equalTo:itemImage.bottomAnchor, constant: 10),
            progressViewContainer.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            progressViewContainer.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            progressViewContainer.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: 10),
        ])
        
        progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.trackTintColor = Settings.Theme.colorGrayLight
        progressView.progressTintColor = Settings.Theme.colorPrimary
        progressView.progress = 0.5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressView)
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 10),
            progressView.leftAnchor.constraint(equalTo:progressViewContainer.leftAnchor, constant: 30),
            progressView.rightAnchor.constraint(equalTo:progressViewContainer.rightAnchor, constant: -30),
            progressView.heightAnchor.constraint(equalToConstant: 2),
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
            contentView.backgroundColor = bgColor
        } else {
            contentView.backgroundColor = bgColor
        }
    }
}

