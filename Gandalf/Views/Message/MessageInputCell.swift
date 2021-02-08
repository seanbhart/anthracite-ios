//
//  MessageInputCell.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
//import FirebaseAnalytics

class MessageInputCell: UITableViewCell {
    var containerView: UIView!
    var containerBorder: UIView!
    var placeholder: UILabel!
    var textView: UITextView!
    
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
        
        containerBorder = UIView()
        containerBorder.layer.borderColor = Settings.Theme.Color.grayLight.cgColor
        containerBorder.layer.borderWidth = 1
        containerBorder.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(containerBorder)
        NSLayoutConstraint.activate([
            containerBorder.topAnchor.constraint(equalTo:containerView.topAnchor),
            containerBorder.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            containerBorder.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            containerBorder.heightAnchor.constraint(equalToConstant: 1)
        ])
        
        placeholder = UILabel()
        placeholder.backgroundColor = .clear
        placeholder.font = UIFont(name: Assets.Fonts.Default.medium, size: 16)
        placeholder.textColor = Settings.Theme.Color.grayLight
        placeholder.textAlignment = NSTextAlignment.left
        placeholder.numberOfLines = 1
        placeholder.text = "New Message"
        placeholder.isUserInteractionEnabled = false
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(placeholder)
        NSLayoutConstraint.activate([
            placeholder.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 10),
            placeholder.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            placeholder.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            placeholder.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        textView = UITextView()
//        textView.delegate = self
        textView.backgroundColor = .clear
        textView.font = UIFont(name: Assets.Fonts.Default.medium, size: 30)
        textView.textColor = Settings.Theme.Color.text
        textView.textAlignment = NSTextAlignment.left
        textView.text = ""
        textView.keyboardDismissMode = .none
        textView.keyboardAppearance = .dark
        textView.keyboardType = .twitter
        textView.returnKeyType = .default
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = true
        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 5),
            textView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: -5),
            textView.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 5),
            textView.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -5),
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
