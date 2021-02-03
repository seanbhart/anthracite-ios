//
//  MessageCell.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
//import FirebaseAnalytics

class MessageCell: UITableViewCell {
    var containerView: UIView!
    var title: UILabel!
    var timeLabel: UILabel!
    var textView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.Color.background
        
        // Create a container and set the frame (auto layout / constraints don't work in UICollectionViewCell?)
        containerView = UIView()
        containerView.backgroundColor = Settings.Theme.Color.background
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
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 14)
        title.textColor = Settings.Theme.Color.text
        title.textAlignment = NSTextAlignment.left
        title.numberOfLines = 1
        title.text = ""
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 5),
            title.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            title.rightAnchor.constraint(equalTo:containerView.centerXAnchor, constant: -5),
            title.heightAnchor.constraint(equalToConstant:20),
        ])
        
        timeLabel = UILabel()
        timeLabel.backgroundColor = .clear
        timeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 14)
        timeLabel.textColor = Settings.Theme.Color.text
        timeLabel.textAlignment = NSTextAlignment.right
        timeLabel.numberOfLines = 1
        timeLabel.text = ""
        timeLabel.isUserInteractionEnabled = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 5),
            timeLabel.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            timeLabel.leftAnchor.constraint(equalTo:containerView.centerXAnchor, constant: 5),
            timeLabel.heightAnchor.constraint(equalToConstant:20),
        ])
        
        textView = UITextView()
        textView.backgroundColor = Settings.Theme.Color.contentBackground
        textView.font = UIFont(name: Assets.Fonts.Default.regular, size: 16)
        textView.textColor = Settings.Theme.Color.text
        textView.textAlignment = NSTextAlignment.left
        textView.text = ""
        textView.keyboardType = .twitter
        textView.keyboardDismissMode = .none
        textView.returnKeyType = .default
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: -5),
            textView.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            textView.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
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
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
////        print("SELECTED SETTINGS ADV CELL")
//    }
}
