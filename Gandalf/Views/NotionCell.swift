//
//  NotionCell.swift
//  Alatar
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit
//import FirebaseAnalytics

class NotionCell: UITableViewCell {
    var containerView: UIView!
    var containerBorder: UIView!
    var textView: UITextView!
    var progressViewContainer: UIView!
    var progressViewLeft: ProgressViewRoundedLeft!
    var progressViewRight: ProgressViewRoundedRight!
    var notionCountLabelContainer: UIView!
    var notionCountLabel: UILabel!
    
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
        containerBorder.backgroundColor = Settings.Theme.background
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
        
        textView = UITextView()
        textView.backgroundColor = Settings.Theme.background
//        textView.font = UIFont(name: Settings.Fonts.Regular.Bold, size: 16)
        textView.textColor = Settings.Theme.text
        textView.textAlignment = NSTextAlignment.left
        textView.text = ""
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 10),
            textView.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            textView.heightAnchor.constraint(equalToConstant: 90),
        ])
        
        progressViewContainer = UIView()
//        progressViewContainer.backgroundColor = .red
        progressViewContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressViewContainer)
        NSLayoutConstraint.activate([
            progressViewContainer.topAnchor.constraint(equalTo:textView.bottomAnchor, constant: 10),
            progressViewContainer.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            progressViewContainer.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -50),
            progressViewContainer.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        progressViewLeft = ProgressViewRoundedLeft()
        progressViewLeft.progressViewStyle = .bar
        progressViewLeft.trackTintColor = .clear
        progressViewLeft.progressTintColor = Settings.Theme.background
        progressViewLeft.progress = 0
//        progressViewLeft.clipsToBounds = true
//        progressViewLeft.layer.cornerRadius = 10
//        progressViewLeft.layer.masksToBounds = true
//        progressViewLeft.layer.sublayers![1].cornerRadius = 5
//        progressViewLeft.subviews[1].clipsToBounds = true
        progressViewLeft.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewLeft)
        NSLayoutConstraint.activate([
            progressViewLeft.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 10),
            progressViewLeft.leftAnchor.constraint(equalTo:progressViewContainer.leftAnchor, constant: 0),
            progressViewLeft.rightAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
            progressViewLeft.heightAnchor.constraint(equalToConstant: 20),
        ])
        progressViewRight = ProgressViewRoundedRight()
        progressViewRight.progressViewStyle = .bar
        progressViewRight.trackTintColor = Settings.Theme.background
        progressViewRight.progressTintColor = .clear
        progressViewRight.progress = 0
//        progressViewRight.clipsToBounds = true
//        progressViewRight.layer.cornerRadius = 10
//        progressViewRight.layer.masksToBounds = true
//        progressViewRight.layer.sublayers![1].cornerRadius = 5
//        progressViewRight.subviews[1].clipsToBounds = true
        progressViewRight.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewRight)
        NSLayoutConstraint.activate([
            progressViewRight.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 10),
            progressViewRight.leftAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
            progressViewRight.rightAnchor.constraint(equalTo:progressViewContainer.rightAnchor, constant: 0),
            progressViewRight.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        notionCountLabelContainer = UIView()
        notionCountLabelContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(notionCountLabelContainer)
        NSLayoutConstraint.activate([
            notionCountLabelContainer.topAnchor.constraint(equalTo:textView.bottomAnchor, constant: 0),
            notionCountLabelContainer.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            notionCountLabelContainer.widthAnchor.constraint(equalToConstant: 50),
            notionCountLabelContainer.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        notionCountLabel = UILabel()
//        notionCountLabel.font = UIFont(name: Settings.Fonts.Regular.Bold, size: 16)
        notionCountLabel.textColor = Settings.Theme.text
        notionCountLabel.textAlignment = NSTextAlignment.center
        notionCountLabel.numberOfLines = 1
        notionCountLabel.text = ""
        notionCountLabel.isUserInteractionEnabled = false
        notionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        notionCountLabelContainer.addSubview(notionCountLabel)
        NSLayoutConstraint.activate([
            notionCountLabel.topAnchor.constraint(equalTo:notionCountLabelContainer.topAnchor, constant: 20),
            notionCountLabel.bottomAnchor.constraint(equalTo:notionCountLabelContainer.bottomAnchor, constant: 0),
            notionCountLabel.leftAnchor.constraint(equalTo:notionCountLabelContainer.leftAnchor, constant: 10),
            notionCountLabel.rightAnchor.constraint(equalTo:notionCountLabelContainer.rightAnchor, constant: -10),
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


