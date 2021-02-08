//
//  NotionCell.swift
//  Gandalf
//
//  Created by Sean Hart on 1/27/21.
//

import UIKit
//import FirebaseAnalytics

class NotionCell: UITableViewCell {
    var id: String?
    
    var tutorialBackgroundView: UIView!
    var containerView: UIView!
    var labelsContainer: UIView!
    var titleLabel: UILabel!
    var notionCountLabel: UILabel!
    var notionIcon: UIImageView!
    var cornerShape = CAShapeLayer()
    var progressViewContainer: UIView!
    var progressViewLeft: ProgressViewRoundedLeft!
    var progressViewRight: ProgressViewRoundedRight!
    var textTitle: UILabel!
    var ageLabel: UILabel!
    var textView: UITextView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        self.backgroundColor = Settings.Theme.Color.contentBackground
        
        // Create a view behind the containerView with the color needed as background for the tutorial animation
        tutorialBackgroundView = UIView()
        tutorialBackgroundView.backgroundColor = Settings.Theme.Color.negative
        tutorialBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tutorialBackgroundView)
        NSLayoutConstraint.activate([
            tutorialBackgroundView.topAnchor.constraint(equalTo:contentView.topAnchor),
            tutorialBackgroundView.bottomAnchor.constraint(equalTo:contentView.bottomAnchor),
            tutorialBackgroundView.leftAnchor.constraint(equalTo:contentView.leftAnchor),
            tutorialBackgroundView.rightAnchor.constraint(equalTo:contentView.rightAnchor),
        ])
        
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
        
        labelsContainer = UIView()
        labelsContainer.backgroundColor = .clear
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(labelsContainer)
        NSLayoutConstraint.activate([
            labelsContainer.topAnchor.constraint(equalTo:containerView.topAnchor, constant: 0),
            labelsContainer.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            labelsContainer.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            labelsContainer.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        notionIcon = UIImageView()
        notionIcon.backgroundColor = .clear
        notionIcon.image = UIImage(named: Assets.Images.notionIconWhiteLg)
        notionIcon.contentMode = UIView.ContentMode.scaleAspectFit
        notionIcon.clipsToBounds = true
        notionIcon.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(notionIcon)
        NSLayoutConstraint.activate([
            notionIcon.topAnchor.constraint(equalTo:labelsContainer.topAnchor, constant: 10),
            notionIcon.bottomAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: 0),
            notionIcon.rightAnchor.constraint(equalTo:labelsContainer.rightAnchor, constant: -15),
            notionIcon.widthAnchor.constraint(equalToConstant: 30),
        ])
        
        notionCountLabel = UILabel()
        notionCountLabel.backgroundColor = .clear
        notionCountLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
        notionCountLabel.textColor = Settings.Theme.Color.text
        notionCountLabel.textAlignment = NSTextAlignment.right
        notionCountLabel.numberOfLines = 1
        notionCountLabel.text = ""
        notionCountLabel.isUserInteractionEnabled = false
        notionCountLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(notionCountLabel)
        NSLayoutConstraint.activate([
            notionCountLabel.topAnchor.constraint(equalTo:labelsContainer.topAnchor, constant: 10),
            notionCountLabel.bottomAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: 0),
            notionCountLabel.rightAnchor.constraint(equalTo:notionIcon.leftAnchor, constant: -10),
            notionCountLabel.widthAnchor.constraint(equalToConstant: 70),
        ])
        
        titleLabel = UILabel()
        titleLabel.backgroundColor = .clear
        titleLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 22)
        titleLabel.textColor = Settings.Theme.Color.text
        titleLabel.textAlignment = NSTextAlignment.left
        titleLabel.numberOfLines = 1
        titleLabel.text = ""
        titleLabel.isUserInteractionEnabled = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        labelsContainer.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo:labelsContainer.topAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: 0),
            titleLabel.leftAnchor.constraint(equalTo:labelsContainer.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo:notionCountLabel.leftAnchor, constant: -5),
        ])
        
        progressViewContainer = UIView()
        progressViewContainer.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(progressViewContainer)
        NSLayoutConstraint.activate([
            progressViewContainer.topAnchor.constraint(equalTo:labelsContainer.bottomAnchor, constant: 0),
            progressViewContainer.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 0),
            progressViewContainer.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: 0),
            progressViewContainer.heightAnchor.constraint(equalToConstant: 5),
        ])
        
        progressViewLeft = ProgressViewRoundedLeft()
        progressViewLeft.progressViewStyle = .bar
        progressViewLeft.trackTintColor = .clear
        progressViewLeft.progressTintColor = Settings.Theme.Color.progressbar
        progressViewLeft.progress = 0
        progressViewLeft.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewLeft)
        NSLayoutConstraint.activate([
            progressViewLeft.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 0),
            progressViewLeft.bottomAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 0),
            progressViewLeft.leftAnchor.constraint(equalTo:progressViewContainer.leftAnchor, constant: 0),
            progressViewLeft.rightAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
        ])
        progressViewRight = ProgressViewRoundedRight()
        progressViewRight.progressViewStyle = .bar
        progressViewRight.trackTintColor = Settings.Theme.Color.progressbar
        progressViewRight.progressTintColor = .clear
        progressViewRight.progress = 0
        progressViewRight.translatesAutoresizingMaskIntoConstraints = false
        progressViewContainer.addSubview(progressViewRight)
        NSLayoutConstraint.activate([
            progressViewRight.topAnchor.constraint(equalTo:progressViewContainer.topAnchor, constant: 0),
            progressViewRight.bottomAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 0),
            progressViewRight.leftAnchor.constraint(equalTo:progressViewContainer.centerXAnchor, constant: 0),
            progressViewRight.rightAnchor.constraint(equalTo:progressViewContainer.rightAnchor, constant: 0),
        ])
        
        ageLabel = UILabel()
        ageLabel.backgroundColor = .clear
        ageLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 12)
        ageLabel.textColor = Settings.Theme.Color.text
        ageLabel.textAlignment = NSTextAlignment.right
        ageLabel.numberOfLines = 1
        ageLabel.text = ""
        ageLabel.isUserInteractionEnabled = false
        ageLabel.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(ageLabel)
        NSLayoutConstraint.activate([
            ageLabel.topAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 10),
            ageLabel.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            ageLabel.widthAnchor.constraint(equalToConstant: 70),
            ageLabel.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        textTitle = UILabel()
        textTitle.backgroundColor = .clear
        textTitle.font = UIFont(name: Assets.Fonts.Default.bold, size: 12)
        textTitle.textColor = Settings.Theme.Color.text
        textTitle.textAlignment = NSTextAlignment.left
        textTitle.numberOfLines = 1
        textTitle.text = ""
        textTitle.isUserInteractionEnabled = false
        textTitle.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textTitle)
        NSLayoutConstraint.activate([
            textTitle.topAnchor.constraint(equalTo:progressViewContainer.bottomAnchor, constant: 10),
            textTitle.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 15),
            textTitle.rightAnchor.constraint(equalTo:ageLabel.rightAnchor, constant: -5),
            textTitle.heightAnchor.constraint(equalToConstant: 20),
        ])
        
        textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = UIFont(name: Assets.Fonts.Default.regular, size: 14)
        textView.textColor = Settings.Theme.Color.text
        textView.textAlignment = NSTextAlignment.left
        textView.text = ""
        textView.isScrollEnabled = false
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo:textTitle.bottomAnchor, constant: 0),
            textView.leftAnchor.constraint(equalTo:containerView.leftAnchor, constant: 10),
            textView.rightAnchor.constraint(equalTo:containerView.rightAnchor, constant: -10),
            textView.bottomAnchor.constraint(equalTo:containerView.bottomAnchor, constant: 0),
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
    
    func clearTrianges() {
        cornerShape.removeFromSuperlayer()
    }
    func insertTrianglePositive() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: labelsContainer.frame.width-20, y: 0))
        path.addLine(to: CGPoint(x: labelsContainer.frame.width, y: 0))
        path.addLine(to: CGPoint(x: labelsContainer.frame.width, y: 20))
        path.addLine(to: CGPoint(x: labelsContainer.frame.width-20, y: 0))

        cornerShape.path = path
        cornerShape.fillColor = Settings.Theme.Color.positive.cgColor
        labelsContainer.layer.insertSublayer(cornerShape, at: 0)
    }
    func insertTriangleNegative() {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 20, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: 20))
        path.addLine(to: CGPoint(x: 20, y: 0))

        cornerShape.path = path
        cornerShape.fillColor = Settings.Theme.Color.negative.cgColor
        labelsContainer.layer.insertSublayer(cornerShape, at: 0)
    }
    
    func tutorialAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0.5, usingSpringWithDamping: 0.9, initialSpringVelocity: 2, options: .curveEaseInOut, animations: {
            self.containerView.transform = CGAffineTransform(translationX: -150, y: 0)
        }) { _ in
            UIView.animate(withDuration: 2.0, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 1, options: .curveEaseInOut, animations: {
                self.containerView.transform = CGAffineTransform(translationX: 0, y: 0)
            }) { _ in
                print("animation done")
            }
        }
    }
}


