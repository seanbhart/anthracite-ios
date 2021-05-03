//
//  StrategyCreateCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

class StrategyCreateCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var symbolButton: UIView!
    var symbolButtonLabel: UILabel!
    
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
        contentContainer.backgroundColor = .red //Settings.Theme.Color.contentBackground
        contentContainer.layer.cornerRadius = 10
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 3),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -3),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 5),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -5),
        ])
        
        symbolButton = UIView()
//        symbolButton.backgroundColor = Settings.Theme.Color.grayLight
        symbolButton.layer.cornerRadius = 25
        symbolButton.layer.borderWidth = 1
        symbolButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        symbolButton.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolButton)
        NSLayoutConstraint.activate([
            symbolButton.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            symbolButton.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 5),
            symbolButton.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -5),
            symbolButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        symbolButtonLabel = UILabel()
//        symbolButtonLabel.backgroundColor = Settings.Theme.Color.grayUltraDark
        symbolButtonLabel.layer.cornerRadius = 5
        symbolButtonLabel.layer.masksToBounds = true
        symbolButtonLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        symbolButtonLabel.textColor = Settings.Theme.Color.positive
        symbolButtonLabel.textAlignment = NSTextAlignment.center
        symbolButtonLabel.numberOfLines = 1
        symbolButtonLabel.text = "TSLA"
        symbolButtonLabel.isUserInteractionEnabled = false
        symbolButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolButton.addSubview(symbolButtonLabel)
        NSLayoutConstraint.activate([
            symbolButtonLabel.topAnchor.constraint(equalTo: symbolButton.topAnchor, constant: 0),
            symbolButtonLabel.leftAnchor.constraint(equalTo: symbolButton.leftAnchor, constant: 0),
            symbolButtonLabel.rightAnchor.constraint(equalTo: symbolButton.rightAnchor, constant: 0),
            symbolButtonLabel.bottomAnchor.constraint(equalTo: symbolButton.bottomAnchor, constant: 0),
        ])
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
//        print("prepareForReuse")
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


