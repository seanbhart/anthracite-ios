//
//  StrategyViewDataHandler.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit
import FirebaseAuth

extension StrategyView: StrategyRepositoryDelegate {
    
    func showLogin() {
        print("showLogin")
    }
    
    
    // MARK: -REPOSITORY METHODS
    
    func strategyDataUpdate() {
        guard let strategyRepo = strategyRepository else { return }
        localStrategies.removeAll()
        localStrategies = strategyRepo.strategies
        print("\(className) - localStrategies: \(localStrategies)")
        strategyTableView.reloadData()
        strategyTableViewSpinner.stopAnimating()
    }

//    func requestError(message: String) {
//        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
//        self.present(alert, animated: true)
//    }
//
//
//    // MARK: -GESTURE METHODS
//
//    @objc func addGroup(_ sender: UITapGestureRecognizer) {
//        print("\(className) - addGroup")
//        let alert = UIAlertController(title: "New Group", message: "Please name your new group.", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
//            let textField = alert.textFields![0] as UITextField
////            print("ADD GROUP: \(textField.text)")
//            guard let name = textField.text else { return }
//            if name.count > 0 {
//                self.groupRepository.createGroup(title: name)
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
//            textField.placeholder = "Group Name"
//            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
//            textField.autocorrectionType = UITextAutocorrectionType.yes
//            textField.keyboardType = UIKeyboardType.default
//            textField.returnKeyType = UIReturnKeyType.done
//            textField.clearButtonMode = UITextField.ViewMode.whileEditing
//            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
//            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
//                    if let tf = notification.object as? UITextField {
//                        let maxLength = 20
//                        if let text = tf.text {
//                            if text.count > maxLength {
//                                tf.text = String(text.prefix(maxLength))
//                            }
//                        }
//                    }
//                })
//        })
//        self.present(alert, animated: true)
//    }
}

