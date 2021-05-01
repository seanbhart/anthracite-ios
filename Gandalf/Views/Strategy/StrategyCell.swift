//
//  StrategyCell.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit
//import FirebaseAnalytics

class StrategyCell: UITableViewCell {
    var containerView: UIView!
    var ageLabel: UILabel!
    var windowLabel: UILabel!
    var windowLabelLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = .green //Settings.Theme.Color.background
        contentView.backgroundColor = .red
        
        containerView = UIView()
        containerView.backgroundColor = .blue //Settings.Theme.Color.contentBackground
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            containerView.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10),
            containerView.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
        ])
        
        ageLabel = UILabel()
        ageLabel.backgroundColor = .clear
        ageLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 18)
        ageLabel.textColor = Settings.Theme.Color.textGrayMedium
        ageLabel.textAlignment = NSTextAlignment.right
        ageLabel.numberOfLines = 1
        ageLabel.text = "5 mins ago"
        ageLabel.isUserInteractionEnabled = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 10),
            ageLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            ageLabel.widthAnchor.constraint(equalToConstant: 150),
            ageLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        windowLabel = UILabel()
        windowLabel.backgroundColor = .clear
        windowLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 30)
        windowLabel.textColor = Settings.Theme.Color.primary
        windowLabel.textAlignment = NSTextAlignment.right
        windowLabel.numberOfLines = 1
        windowLabel.text = "3 DAYS"
        windowLabel.isUserInteractionEnabled = false
        windowLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(windowLabel)
        NSLayoutConstraint.activate([
            windowLabel.topAnchor.constraint(equalTo: ageLabel.bottomAnchor, constant: 0),
            windowLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
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
        containerView.addSubview(windowLabelLabel)
        NSLayoutConstraint.activate([
            windowLabelLabel.topAnchor.constraint(equalTo: windowLabel.bottomAnchor, constant: 0),
            windowLabelLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -10),
            windowLabelLabel.widthAnchor.constraint(equalToConstant: 150),
            windowLabelLabel.heightAnchor.constraint(equalToConstant: 14),
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

