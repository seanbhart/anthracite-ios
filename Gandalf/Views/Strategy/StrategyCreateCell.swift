//
//  StrategyCreateCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

protocol StrategyCreateCellDelegate {
    func cancelOrder(orderIndex: Int)
    func selectOrderSymbol(orderIndex: Int)
    func selectOrderDirection(orderIndex: Int)
    func selectOrderType(orderIndex: Int)
    func updateOrderPrice(orderIndex: Int, price: Double)
}

class StrategyCreateCell: UITableViewCell, UITextFieldDelegate {
    let className = "StrategyCreateCell"
    
    var orderIndex: Int!
    var delegate: StrategyCreateCellDelegate!
    
    var cellContainer: UIView!
    var cancelContainer: UIView!
    var cancelImageView: UIImageView!
    var contentContainer: UIView!
    var directionLabel: UILabel!
    var directionButton: UIView!
    var directionButtonLabel: UILabel!
    var typeLabel: UILabel!
    var typeButton: UIView!
    var typeButtonLabel: UILabel!
    var symbolLabel: UILabel!
    var symbolButton: UIView!
    var symbolButtonLabel: UILabel!
    var priceLabel: UILabel!
    var priceButton: UIView!
    var priceButtonField: UITextField!
    
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
        
        cancelContainer = UIView()
        cancelContainer.backgroundColor = Settings.Theme.Color.contentBackground
        cancelContainer.layer.cornerRadius = 5
        cancelContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(cancelContainer)
        NSLayoutConstraint.activate([
            cancelContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 5),
            cancelContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -5),
            cancelContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 5),
            cancelContainer.widthAnchor.constraint(equalToConstant: 40),
        ])
        
        let cancelContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(cancelTap))
        cancelContainerGestureRecognizer.numberOfTapsRequired = 1
        cancelContainer.addGestureRecognizer(cancelContainerGestureRecognizer)
        
        cancelImageView = UIImageView()
        cancelImageView.image = UIImage(systemName: "xmark")?.withTintColor(Settings.Theme.Color.grayUltraDark, renderingMode: .alwaysOriginal)
        cancelImageView.contentMode = UIView.ContentMode.scaleAspectFit
        cancelImageView.clipsToBounds = true
        cancelImageView.isUserInteractionEnabled = true
        cancelImageView.translatesAutoresizingMaskIntoConstraints = false
        cancelContainer.addSubview(cancelImageView)
        NSLayoutConstraint.activate([
            cancelImageView.topAnchor.constraint(equalTo: cancelContainer.topAnchor, constant: 0),
            cancelImageView.leftAnchor.constraint(equalTo: cancelContainer.leftAnchor, constant: 10),
            cancelImageView.rightAnchor.constraint(equalTo: cancelContainer.rightAnchor, constant: -10),
            cancelImageView.bottomAnchor.constraint(equalTo: cancelContainer.bottomAnchor, constant: 0),
        ])
        
        contentContainer = UIView()
        contentContainer.backgroundColor = Settings.Theme.Color.contentBackground
        contentContainer.layer.cornerRadius = 5
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(contentContainer)
        NSLayoutConstraint.activate([
            contentContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 5),
            contentContainer.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -5),
            contentContainer.leftAnchor.constraint(equalTo: cancelContainer.rightAnchor, constant: 2),
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

        symbolButton = UIView()
        symbolButton.layer.cornerRadius = 25
        symbolButton.layer.borderWidth = 1
        symbolButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        symbolButton.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(symbolButton)
        NSLayoutConstraint.activate([
            symbolButton.topAnchor.constraint(equalTo: symbolLabel.bottomAnchor, constant: 0),
            symbolButton.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 5),
            symbolButton.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -3),
            symbolButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let symbolButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(symbolButtonTap))
        symbolButtonGestureRecognizer.numberOfTapsRequired = 1
        symbolButton.addGestureRecognizer(symbolButtonGestureRecognizer)

        symbolButtonLabel = UILabel()
        symbolButtonLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        symbolButtonLabel.textColor = Settings.Theme.Color.positive
        symbolButtonLabel.textAlignment = NSTextAlignment.center
        symbolButtonLabel.numberOfLines = 1
        symbolButtonLabel.text = "____"
        symbolButtonLabel.isUserInteractionEnabled = false
        symbolButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        symbolButton.addSubview(symbolButtonLabel)
        NSLayoutConstraint.activate([
            symbolButtonLabel.topAnchor.constraint(equalTo: symbolButton.topAnchor, constant: 0),
            symbolButtonLabel.leftAnchor.constraint(equalTo: symbolButton.leftAnchor, constant: 0),
            symbolButtonLabel.rightAnchor.constraint(equalTo: symbolButton.rightAnchor, constant: 0),
            symbolButtonLabel.bottomAnchor.constraint(equalTo: symbolButton.bottomAnchor, constant: 0),
        ])
        
        directionLabel = UILabel()
        directionLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        directionLabel.textColor = Settings.Theme.Color.textGrayMedium
        directionLabel.textAlignment = NSTextAlignment.center
        directionLabel.numberOfLines = 1
        directionLabel.text = "DIRECTION"
        directionLabel.isUserInteractionEnabled = false
        directionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(directionLabel)
        NSLayoutConstraint.activate([
            directionLabel.topAnchor.constraint(equalTo: contentContainer.topAnchor, constant: 2),
            directionLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 3),
            directionLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -5),
            directionLabel.heightAnchor.constraint(equalToConstant: 14),
        ])
        
        directionButton = UIView()
        directionButton.layer.cornerRadius = 25
        directionButton.layer.borderWidth = 1
        directionButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        directionButton.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(directionButton)
        NSLayoutConstraint.activate([
            directionButton.topAnchor.constraint(equalTo: directionLabel.bottomAnchor, constant: 0),
            directionButton.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 3),
            directionButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -5),
            directionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let directionButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(directionButtonTap))
        directionButtonGestureRecognizer.numberOfTapsRequired = 1
        directionButton.addGestureRecognizer(directionButtonGestureRecognizer)
        
        directionButtonLabel = UILabel()
        directionButtonLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        directionButtonLabel.textColor = Settings.Theme.Color.textGrayLight
        directionButtonLabel.textAlignment = NSTextAlignment.center
        directionButtonLabel.numberOfLines = 1
        directionButtonLabel.text = "BUY"
        directionButtonLabel.isUserInteractionEnabled = false
        directionButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        directionButton.addSubview(directionButtonLabel)
        NSLayoutConstraint.activate([
            directionButtonLabel.topAnchor.constraint(equalTo: directionButton.topAnchor, constant: 0),
            directionButtonLabel.leftAnchor.constraint(equalTo: directionButton.leftAnchor, constant: 0),
            directionButtonLabel.rightAnchor.constraint(equalTo: directionButton.rightAnchor, constant: 0),
            directionButtonLabel.bottomAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 0),
        ])
        
        typeButton = UIView()
        typeButton.layer.cornerRadius = 25
        typeButton.layer.borderWidth = 1
        typeButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        typeButton.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(typeButton)
        NSLayoutConstraint.activate([
            typeButton.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 3),
            typeButton.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -5),
            typeButton.bottomAnchor.constraint(equalTo: contentContainer.bottomAnchor, constant: -10),
            typeButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let typeButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(typeButtonTap))
        typeButtonGestureRecognizer.numberOfTapsRequired = 1
        typeButton.addGestureRecognizer(typeButtonGestureRecognizer)
        
        typeButtonLabel = UILabel()
        typeButtonLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        typeButtonLabel.textColor = Settings.Theme.Color.textGrayLight
        typeButtonLabel.textAlignment = NSTextAlignment.center
        typeButtonLabel.numberOfLines = 1
        typeButtonLabel.text = "MARKET"
        typeButtonLabel.isUserInteractionEnabled = false
        typeButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        typeButton.addSubview(typeButtonLabel)
        NSLayoutConstraint.activate([
            typeButtonLabel.topAnchor.constraint(equalTo: typeButton.topAnchor, constant: 0),
            typeButtonLabel.leftAnchor.constraint(equalTo: typeButton.leftAnchor, constant: 0),
            typeButtonLabel.rightAnchor.constraint(equalTo: typeButton.rightAnchor, constant: 0),
            typeButtonLabel.bottomAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 0),
        ])
        
        typeLabel = UILabel()
        typeLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        typeLabel.textColor = Settings.Theme.Color.textGrayMedium
        typeLabel.textAlignment = NSTextAlignment.center
        typeLabel.numberOfLines = 1
        typeLabel.text = "ORDER TYPE"
        typeLabel.isUserInteractionEnabled = false
        typeLabel.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.addSubview(typeLabel)
        NSLayoutConstraint.activate([
            typeLabel.topAnchor.constraint(equalTo: directionButton.bottomAnchor, constant: 2),
            typeLabel.leftAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: 3),
            typeLabel.rightAnchor.constraint(equalTo: contentContainer.rightAnchor, constant: -5),
            typeLabel.bottomAnchor.constraint(equalTo: typeButton.topAnchor, constant: 0),
        ])
        
        priceLabel = UILabel()
        priceLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 12)
        priceLabel.textColor = Settings.Theme.Color.textGrayMedium
        priceLabel.textAlignment = NSTextAlignment.center
        priceLabel.numberOfLines = 1
        priceLabel.text = "LIMIT PRICE"
        priceLabel.isUserInteractionEnabled = false
        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        priceButton = UIView()
        priceButton.layer.cornerRadius = 25
        priceButton.layer.borderWidth = 1
        priceButton.layer.borderColor = Settings.Theme.Color.grayMedium.cgColor
        priceButton.translatesAutoresizingMaskIntoConstraints = false

        priceButtonField = UITextField()
        priceButtonField.delegate = self
        priceButtonField.placeholder = "$0.00"
        priceButtonField.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        priceButtonField.textColor = Settings.Theme.Color.textGrayLight
        priceButtonField.textAlignment = NSTextAlignment.center
//        priceButtonField.text = ""
        priceButtonField.autocorrectionType = UITextAutocorrectionType.no
        priceButtonField.keyboardType = UIKeyboardType.decimalPad
        priceButtonField.returnKeyType = UIReturnKeyType.done
        priceButtonField.clearButtonMode = UITextField.ViewMode.whileEditing
        priceButtonField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        priceButtonField.isUserInteractionEnabled = true
        priceButtonField.translatesAutoresizingMaskIntoConstraints = false
//        priceButtonField.inputAccessoryView = priceButtonAccessoryView
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
    
    
    func showLimitPrice() {
        contentContainer.addSubview(priceLabel)
        NSLayoutConstraint.activate([
            priceLabel.topAnchor.constraint(equalTo: typeLabel.topAnchor, constant: 0),
            priceLabel.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 5),
            priceLabel.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -3),
            priceLabel.bottomAnchor.constraint(equalTo: typeLabel.bottomAnchor, constant: 0),
        ])
        
        contentContainer.addSubview(priceButton)
        NSLayoutConstraint.activate([
            priceButton.topAnchor.constraint(equalTo: typeButton.topAnchor, constant: 0),
            priceButton.leftAnchor.constraint(equalTo: contentContainer.leftAnchor, constant: 5),
            priceButton.rightAnchor.constraint(equalTo: contentContainer.centerXAnchor, constant: -3),
            priceButton.bottomAnchor.constraint(equalTo: typeButton.bottomAnchor, constant: 0),
        ])
        
        priceButton.addSubview(priceButtonField)
        NSLayoutConstraint.activate([
            priceButtonField.topAnchor.constraint(equalTo: priceButton.topAnchor, constant: 0),
            priceButtonField.leftAnchor.constraint(equalTo: priceButton.leftAnchor, constant: 0),
            priceButtonField.rightAnchor.constraint(equalTo: priceButton.rightAnchor, constant: 0),
            priceButtonField.bottomAnchor.constraint(equalTo: priceButton.bottomAnchor, constant: 0),
        ])
    }
    func hideLimitPrice() {
        priceLabel.removeFromSuperview()
        priceButton.removeFromSuperview()
        priceButtonField.removeFromSuperview()
    }
    
    func setLimitPrice(price: Double) {
        priceButtonField.text = dollarString(price)
    }
    
    
    // MARK: -TEXT FIELD DELEGATE METHODS
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == priceButtonField {
            if let parent = self.delegate {
                parent.updateOrderPrice(orderIndex: orderIndex, price: Double(textField.text ?? "0") ?? 0)
            }
        }
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func cancelTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.cancelOrder(orderIndex: orderIndex)
        }
    }
    @objc func symbolButtonTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.selectOrderSymbol(orderIndex: orderIndex)
        }
    }
    @objc func directionButtonTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.selectOrderDirection(orderIndex: orderIndex)
        }
    }
    @objc func typeButtonTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.selectOrderType(orderIndex: orderIndex)
        }
    }
}


