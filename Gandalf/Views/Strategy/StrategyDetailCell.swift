//
//  StrategyDetailCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/5/21.
//

import UIKit
//import FirebaseAnalytics

class StrategyDetailCell: UITableViewCell {
    
    var cellContainer: UIView!
    var contentContainer: UIView!
    var symbolLabel: UILabel!
    var symbolLabelLabel: UILabel!
    var priceLabel: UILabel!
    var priceLabelLabel: UILabel!
    var directionLabel: UILabel!
    var directionLabelLabel: UILabel!
    var typeLabel: UILabel!
    var typeLabelLabel: UILabel!
    
    
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
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 3),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -3),
            contentContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 5),
            contentContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -5),
        ])
        
        symbolLabel = UILabel()
        symbolLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 40)
        symbolLabel.textColor = Settings.Theme.Color.textGrayLight
        symbolLabel.textAlignment = NSTextAlignment.left
        symbolLabel.numberOfLines = 1
        symbolLabel.text = ""
        symbolLabel.isUserInteractionEnabled = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolLabel)
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            symbolLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            symbolLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -10),
            symbolLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
        
        symbolLabelLabel = UILabel()
        symbolLabelLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        symbolLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        symbolLabelLabel.textAlignment = NSTextAlignment.left
        symbolLabelLabel.numberOfLines = 1
        symbolLabelLabel.text = "INCREASING PRICE PREDICTION"
        symbolLabelLabel.isUserInteractionEnabled = false
        symbolLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolLabelLabel)
        NSLayoutConstraint.activate([
            symbolLabelLabel.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 0),
            symbolLabelLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            symbolLabelLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -10),
            symbolLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        directionLabel = UILabel()
        directionLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        directionLabel.textColor = Settings.Theme.Color.textGrayMedium
        directionLabel.textAlignment = NSTextAlignment.left
        directionLabel.numberOfLines = 1
        directionLabel.text = ""
        directionLabel.isUserInteractionEnabled = false
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(directionLabel)
        NSLayoutConstraint.activate([
            directionLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 10),
            directionLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 10),
            directionLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            directionLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        directionLabelLabel = UILabel()
        directionLabelLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        directionLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        directionLabelLabel.textAlignment = NSTextAlignment.left
        directionLabelLabel.numberOfLines = 1
        directionLabelLabel.text = "DIRECTION"
        directionLabelLabel.isUserInteractionEnabled = false
        directionLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(directionLabelLabel)
        NSLayoutConstraint.activate([
            directionLabelLabel.topAnchor.constraint(equalTo: directionLabel.bottomAnchor, constant: 0),
            directionLabelLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 10),
            directionLabelLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            directionLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        priceLabel = UILabel()
        priceLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        priceLabel.textColor = Settings.Theme.Color.textGrayMedium
        priceLabel.textAlignment = NSTextAlignment.left
        priceLabel.numberOfLines = 1
        priceLabel.text = ""
        priceLabel.isUserInteractionEnabled = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: symbolLabelLabel.bottomAnchor, constant: 10),
            priceLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            priceLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -10),
            priceLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        priceLabelLabel = UILabel()
        priceLabelLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        priceLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        priceLabelLabel.textAlignment = NSTextAlignment.left
        priceLabelLabel.numberOfLines = 1
        priceLabelLabel.text = "PRICE"
        priceLabelLabel.isUserInteractionEnabled = false
        priceLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(priceLabelLabel)
        NSLayoutConstraint.activate([
            priceLabelLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 0),
            priceLabelLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 10),
            priceLabelLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -10),
            priceLabelLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        typeLabel = UILabel()
        typeLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        typeLabel.textColor = Settings.Theme.Color.textGrayMedium
        typeLabel.textAlignment = NSTextAlignment.left
        typeLabel.numberOfLines = 1
        typeLabel.text = ""
        typeLabel.isUserInteractionEnabled = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: directionLabelLabel.bottomAnchor, constant: 20),
            typeLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 10),
            typeLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            typeLabel.heightAnchor.constraint(equalToConstant: 30),
        ])
        
        typeLabelLabel = UILabel()
        typeLabelLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 12)
        typeLabelLabel.textColor = Settings.Theme.Color.textGrayMedium
        typeLabelLabel.textAlignment = NSTextAlignment.left
        typeLabelLabel.numberOfLines = 1
        typeLabelLabel.text = "ORDER TYPE"
        typeLabelLabel.isUserInteractionEnabled = false
        typeLabelLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(typeLabelLabel)
        NSLayoutConstraint.activate([
            typeLabelLabel.topAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 0),
            typeLabelLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 10),
            typeLabelLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -10),
            typeLabelLabel.heightAnchor.constraint(equalToConstant: 14),
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
