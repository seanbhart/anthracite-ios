//
//  SymbolCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

class SymbolCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var symbolLabel: UILabel!
    var symbolDescLabel: UILabel!
    
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
        contentContainer.backgroundColor = Settings.Theme.Color.contentBackground
        contentContainer.layer.cornerRadius = 10
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 10),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -3),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 5),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -5),
        ])
        
        symbolLabel = UILabel()
        symbolLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        symbolLabel.textColor = Settings.Theme.Color.textGrayMedium
        symbolLabel.textAlignment = NSTextAlignment.center
        symbolLabel.numberOfLines = 1
        symbolLabel.text = "SYMBOL"
        symbolLabel.isUserInteractionEnabled = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolLabel)
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 2),
            symbolLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 5),
            symbolLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -3),
            symbolLabel.heightAnchor.constraint(equalToConstant: 14),
        ])

        symbolDescLabel = UILabel()
        symbolDescLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        symbolDescLabel.textColor = Settings.Theme.Color.positive
        symbolDescLabel.textAlignment = NSTextAlignment.center
        symbolDescLabel.numberOfLines = 1
        symbolDescLabel.text = "TSLA"
        symbolDescLabel.isUserInteractionEnabled = false
        symbolDescLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolDescLabel)
        NSLayoutConstraint.activate([
            symbolDescLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 0),
            symbolDescLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 0),
            symbolDescLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: 0),
            symbolDescLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
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



