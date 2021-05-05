//
//  TextCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

class TextCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var cellTextLabel: UILabel!
    
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
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 2),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -2),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 10),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -10),
        ])
        
        cellTextLabel = UILabel()
        cellTextLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 20)
        cellTextLabel.textColor = Settings.Theme.Color.textGrayMedium
        cellTextLabel.textAlignment = NSTextAlignment.left
        cellTextLabel.numberOfLines = 1
//        cellTextLabel.text = ""
        cellTextLabel.isUserInteractionEnabled = false
        cellTextLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(cellTextLabel)
        NSLayoutConstraint.activate([
            cellTextLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 0),
            cellTextLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            cellTextLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            cellTextLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
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




