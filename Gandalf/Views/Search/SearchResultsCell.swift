//
//  SearchResultsCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

class SearchResultsCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var resultLabel: UILabel!
    
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
        
        resultLabel = UILabel()
        resultLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 20)
        resultLabel.textColor = Settings.Theme.Color.textGrayMedium
        resultLabel.textAlignment = NSTextAlignment.left
        resultLabel.numberOfLines = 1
//        resultLabel.text = ""
        resultLabel.isUserInteractionEnabled = false
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(resultLabel)
        NSLayoutConstraint.activate([
            resultLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 0),
            resultLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            resultLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            resultLabel.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: 0),
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




