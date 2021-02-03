//
//  GroupCell.swift
//  Gandalf
//
//  Created by Sean Hart on 2/3/21.
//

import UIKit
//import FirebaseAnalytics

class GroupCell: UITableViewCell {
    var containerView: UIView!
    var title: UILabel!
    
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
        title.font = UIFont(name: Assets.Fonts.Default.black, size: 30)
        title.textColor = Settings.Theme.Color.text
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
            title.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: -10),
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
