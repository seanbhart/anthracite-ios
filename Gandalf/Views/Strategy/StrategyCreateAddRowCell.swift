//
//  StrategyCreateAddRowCell.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
//import FirebaseAnalytics

protocol StrategyCreateAddRowCellDelegate {
    func addRow()
}

class StrategyCreateAddRowCell: UITableViewCell {
    let className = "StrategyCreateAddRowCell"
    
    var delegate: StrategyCreateAddRowCellDelegate!
    
    var cellContainer: UIView!
    var addContainer: UIView!
    var addImageView: UIImageView!
    var hiddenView: UIView!
    
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
        
        addContainer = UIView()
        addContainer.backgroundColor = Settings.Theme.Color.contentBackground
        addContainer.layer.cornerRadius = 5
        addContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(addContainer)
        NSLayoutConstraint.activate([
            addContainer.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 5),
            addContainer.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 5),
            addContainer.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: -5),
            addContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        let addContainerGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(addTap))
        addContainerGestureRecognizer.numberOfTapsRequired = 1
        addContainer.addGestureRecognizer(addContainerGestureRecognizer)
        
        addImageView = UIImageView()
        addImageView.image = UIImage(systemName: "plus")?.withTintColor(Settings.Theme.Color.grayUltraDark, renderingMode: .alwaysOriginal)
        addImageView.contentMode = UIView.ContentMode.scaleAspectFit
        addImageView.clipsToBounds = true
        addImageView.isUserInteractionEnabled = true
        addImageView.translatesAutoresizingMaskIntoConstraints = false
        addContainer.addSubview(addImageView)
        NSLayoutConstraint.activate([
            addImageView.topAnchor.constraint(equalTo: addContainer.topAnchor, constant: 10),
            addImageView.leftAnchor.constraint(equalTo: addContainer.leftAnchor, constant: 0),
            addImageView.rightAnchor.constraint(equalTo: addContainer.rightAnchor, constant: 0),
            addImageView.bottomAnchor.constraint(equalTo: addContainer.bottomAnchor, constant: -10),
        ])
        
        // A view that is constrained to a height-specific component and the cell needs to be added when using auto cell dimensions
        hiddenView = UIView()
        hiddenView.backgroundColor = .clear
        hiddenView.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.addSubview(hiddenView)
        NSLayoutConstraint.activate([
            hiddenView.topAnchor.constraint(equalTo: addContainer.bottomAnchor, constant: 0),
            hiddenView.leftAnchor.constraint(equalTo: cellContainer.leftAnchor, constant: 0),
            hiddenView.rightAnchor.constraint(equalTo: cellContainer.rightAnchor, constant: 0),
            hiddenView.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: 0),
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
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func addTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.addRow()
        }
    }
}
