//
//  MessageCell.swift
//  Gandalf
//
//  Created by Sean Hart on 2/2/21.
//

import UIKit
//import FirebaseAnalytics

class MessageCellGandalf: UITableViewCell {
    var leftContainer: UIView!
    var accountImage: UIImageView!
    var rightContainer: UIView!
    var title: UILabel!
    var timeLabel: UILabel!
    var textView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.Color.contentBackground
        
        leftContainer = UIView()
        leftContainer.backgroundColor = Settings.Theme.Color.contentBackground
        leftContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(leftContainer)
        NSLayoutConstraint.activate([
            leftContainer.topAnchor.constraint(equalTo:contentView.topAnchor),
            leftContainer.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            leftContainer.leftAnchor.constraint(equalTo:contentView.leftAnchor),
            leftContainer.widthAnchor.constraint(equalToConstant: 34),
        ])
        
        accountImage = UIImageView()
        accountImage.backgroundColor = .clear
        accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
        accountImage.contentMode = UIView.ContentMode.scaleAspectFit
        accountImage.clipsToBounds = true
        accountImage.translatesAutoresizingMaskIntoConstraints = false
        leftContainer.addSubview(accountImage)
        NSLayoutConstraint.activate([
            accountImage.topAnchor.constraint(equalTo:leftContainer.topAnchor, constant: 2),
            accountImage.leftAnchor.constraint(equalTo:leftContainer.leftAnchor, constant: 2),
            accountImage.rightAnchor.constraint(equalTo: leftContainer.rightAnchor, constant: -2),
            accountImage.heightAnchor.constraint(equalToConstant:30),
        ])
        
        rightContainer = UIView()
        rightContainer.backgroundColor = Settings.Theme.Color.contentBackground
        rightContainer.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(rightContainer)
        NSLayoutConstraint.activate([
            rightContainer.topAnchor.constraint(equalTo:contentView.topAnchor),
            rightContainer.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            rightContainer.leftAnchor.constraint(equalTo:leftContainer.rightAnchor),
            rightContainer.rightAnchor.constraint(equalTo:contentView.rightAnchor),
        ])
        
        title = UILabel()
        title.backgroundColor = .clear
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 16)
        title.textColor = Settings.Theme.Color.grayLight
        title.textAlignment = NSTextAlignment.left
        title.numberOfLines = 1
        title.text = ""
        title.isUserInteractionEnabled = false
        title.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.addSubview(title)
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo:rightContainer.topAnchor, constant: 0),
            title.leftAnchor.constraint(equalTo:rightContainer.leftAnchor, constant: 5),
            title.rightAnchor.constraint(equalTo:rightContainer.centerXAnchor, constant: -5),
            title.heightAnchor.constraint(equalToConstant:20),
        ])
        
        timeLabel = UILabel()
        timeLabel.backgroundColor = .clear
        timeLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 10)
        timeLabel.textColor = Settings.Theme.Color.grayLight
        timeLabel.textAlignment = NSTextAlignment.right
        timeLabel.numberOfLines = 1
        timeLabel.text = ""
        timeLabel.isUserInteractionEnabled = false
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        rightContainer.addSubview(timeLabel)
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo:rightContainer.topAnchor, constant: 0),
            timeLabel.rightAnchor.constraint(equalTo:rightContainer.rightAnchor, constant: -5),
            timeLabel.leftAnchor.constraint(equalTo:rightContainer.centerXAnchor, constant: 5),
            timeLabel.heightAnchor.constraint(equalToConstant:20),
        ])
        
        textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont(name: Assets.Fonts.Default.regular, size: 16)
        textView.textColor = Settings.Theme.Color.text
        textView.textAlignment = NSTextAlignment.left
        textView.text = ""
        textView.keyboardType = .twitter
        textView.keyboardDismissMode = .none
        textView.returnKeyType = .default
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textContainerInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        rightContainer.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo:title.bottomAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo:rightContainer.bottomAnchor, constant: -5),
            textView.leftAnchor.constraint(equalTo:rightContainer.leftAnchor, constant: 0),
            textView.rightAnchor.constraint(equalTo:rightContainer.rightAnchor, constant: 0),
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
