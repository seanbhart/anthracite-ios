//
//  WindowPicker.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
import FirebaseAuth

protocol WindowPickerViewDelegate {
    func window(expiration: TimeInterval)
}

class WindowPickerView: UIViewController, UIGestureRecognizerDelegate {
    let className = "WindowPickerView"
    
    var delegate: WindowPickerViewDelegate!
    var options = [
        ["text": "10 MINS", "seconds": Double(600)],
        ["text": "30 MINS", "seconds": Double(1800)],
        ["text": "1 HR", "seconds": Double(3600)],
        ["text": "2 HRS", "seconds": Double(7200)],
        ["text": "3 HRS", "seconds": Double(10800)],
        ["text": "6 HRS", "seconds": Double(21600)],
        ["text": "12 HRS", "seconds": Double(43200)],
        ["text": "1 DAY", "seconds": Double(86400)],
        ["text": "2 DAYS", "seconds": Double(172800)],
        ["text": "3 DAYS", "seconds": Double(259200)],
    ]
    
    var viewContainer: UIView!
    var descriptionLabel: UILabel!
    var datePicker: UIDatePicker!
    var timesTableView: UITableView!
    let timesTableCellIdentifier: String = "TimeCell"
    var saveContainer: UIView!
    var saveButton: UIView!
    var saveButtonLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Opportunity Window"
        self.navigationItem.hidesBackButton = false
        let attributes = [NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.semiBold, size: 14)]
        self.navigationController?.navigationBar.titleTextAttributes = attributes as [NSAttributedString.Key : Any]
        
        self.navigationItem.leftBarButtonItem = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("\(className) - viewWillAppear")
//        setNeedsStatusBarAppearanceUpdate()
        // Ensure the navigation bar is not hidden
        if let nc = self.navigationController {
            nc.setNavigationBarHidden(false, animated: animated)
//            nc.navigationBar.barStyle = Settings.Theme.barStyle
        }

        NSLayoutConstraint.activate([
            viewContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            viewContainer.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            viewContainer.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            viewContainer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: viewContainer.topAnchor, constant: 10),
            descriptionLabel.leftAnchor.constraint(equalTo: viewContainer.leftAnchor, constant: 20),
            descriptionLabel.rightAnchor.constraint(equalTo: viewContainer.rightAnchor, constant: -20),
            descriptionLabel.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            datePicker.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            datePicker.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
        ])
        NSLayoutConstraint.activate([
            saveContainer.bottomAnchor.constraint(equalTo: viewContainer.bottomAnchor, constant: 0),
            saveContainer.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            saveContainer.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            saveContainer.heightAnchor.constraint(equalToConstant: 80),
        ])
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: saveContainer.topAnchor, constant: 10),
            saveButton.leftAnchor.constraint(equalTo: saveContainer.leftAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: saveContainer.rightAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        NSLayoutConstraint.activate([
            saveButtonLabel.topAnchor.constraint(equalTo: saveButton.topAnchor),
            saveButtonLabel.leftAnchor.constraint(equalTo: saveButton.leftAnchor),
            saveButtonLabel.rightAnchor.constraint(equalTo: saveButton.rightAnchor),
            saveButtonLabel.bottomAnchor.constraint(equalTo: saveButton.bottomAnchor),
        ])
        NSLayoutConstraint.activate([
            timesTableView.topAnchor.constraint(equalTo: datePicker.bottomAnchor),
            timesTableView.leftAnchor.constraint(equalTo: viewContainer.leftAnchor),
            timesTableView.rightAnchor.constraint(equalTo: viewContainer.rightAnchor),
            timesTableView.bottomAnchor.constraint(equalTo: saveContainer.topAnchor),
        ])
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("\(className) - viewWillDisappear")
    }

    override func loadView() {
        super.loadView()
        print("\(className) - loadView")
        
        // Make the background the same as the navigation bar
        view.backgroundColor = Settings.Theme.Color.background
        
        viewContainer = UIView()
        viewContainer.backgroundColor = Settings.Theme.Color.background
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewContainer)
        
        descriptionLabel = UILabel()
        descriptionLabel.backgroundColor = .clear
        descriptionLabel.font = UIFont(name: Assets.Fonts.Default.regular, size: 18)
        descriptionLabel.textColor = Settings.Theme.Color.primary
        descriptionLabel.textAlignment = NSTextAlignment.center
        descriptionLabel.numberOfLines = 0
        descriptionLabel.lineBreakMode = .byWordWrapping
        descriptionLabel.text = "Estimate the last time you would consider executing this strategy."
        descriptionLabel.isUserInteractionEnabled = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(descriptionLabel)
        
        datePicker = UIDatePicker()
//        datePicker.layer.borderColor = Settings.Theme.Color.grayUltraLight.cgColor
//        datePicker.layer.borderWidth = 1
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.minuteInterval = 10
        datePicker.minimumDate = Date(timeIntervalSinceNow: 600)
        datePicker.maximumDate = Date(timeIntervalSinceNow: 604800)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(datePicker)
        
        saveContainer = UIView()
        saveContainer.backgroundColor = Settings.Theme.Color.background
        saveContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(saveContainer)
        
        saveButton = UIView()
        saveButton.layer.cornerRadius = 25
        saveButton.backgroundColor = Settings.Theme.Color.primary
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveContainer.addSubview(saveButton)
        
        let saveButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(saveTap))
        saveButtonGestureRecognizer.numberOfTapsRequired = 1
        saveButton.addGestureRecognizer(saveButtonGestureRecognizer)
        
        saveButtonLabel = UILabel()
        saveButtonLabel.backgroundColor = .clear
        saveButtonLabel.font = UIFont(name: Assets.Fonts.Default.bold, size: 26)
        saveButtonLabel.textColor = Settings.Theme.Color.textGrayTrueDark
        saveButtonLabel.textAlignment = NSTextAlignment.center
        saveButtonLabel.numberOfLines = 1
        saveButtonLabel.text = "SAVE"
        saveButtonLabel.isUserInteractionEnabled = false
        saveButtonLabel.translatesAutoresizingMaskIntoConstraints = false
        saveButton.addSubview(saveButtonLabel)
        
        timesTableView = UITableView()
        timesTableView.dataSource = self
        timesTableView.delegate = self
        timesTableView.dragInteractionEnabled = false
        timesTableView.register(TextCell.self, forCellReuseIdentifier: timesTableCellIdentifier)
        timesTableView.separatorStyle = .none
        timesTableView.backgroundColor = .clear
        timesTableView.isSpringLoaded = true
        timesTableView.rowHeight = 50
        timesTableView.estimatedSectionHeaderHeight = 0
        timesTableView.estimatedSectionFooterHeight = 0
        timesTableView.isScrollEnabled = true
        timesTableView.bounces = true
        timesTableView.alwaysBounceVertical = true
        timesTableView.showsVerticalScrollIndicator = false
        timesTableView.isUserInteractionEnabled = true
        timesTableView.allowsSelection = true
//        timesTableView.delaysContentTouches = false
        timesTableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        timesTableView.insetsContentViewsToSafeArea = true
        timesTableView.translatesAutoresizingMaskIntoConstraints = false
        viewContainer.addSubview(timesTableView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: -GESTURE RECOGNIZERS
    
    @objc func saveTap(_ sender: UITapGestureRecognizer) {
        if let parent = self.delegate {
            parent.window(expiration: datePicker.date.timeIntervalSince1970)
        }
    }
}

