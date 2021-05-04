//
//  WindowPicker.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit
import FirebaseAuth

protocol WindowPickerDelegate {
    func windowSelected(seconds: Int)
}

class WindowPicker: UIViewController, UIGestureRecognizerDelegate {
    let className = "WindowPicker"
    
    var delegate: SearchViewDelegate!
    
    var viewContainer: UIView!
    var datePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(className) - viewDidLoad")
        self.navigationItem.title = "Set Opportunity Window"
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
            datePicker.centerXAnchor.constraint(equalTo: viewContainer.centerXAnchor),
            datePicker.centerYAnchor.constraint(equalTo: viewContainer.centerYAnchor),
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
        
        datePicker = UIDatePicker()
        datePicker.layer.borderColor = Settings.Theme.Color.grayUltraLight.cgColor
        datePicker.layer.borderWidth = 1
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .wheels
        viewContainer.addSubview(datePicker)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("\(className) - didReceiveMemoryWarning")
        // Dispose of any resources that can be recreated.
    }
}

