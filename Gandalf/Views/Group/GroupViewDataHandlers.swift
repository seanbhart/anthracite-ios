//
//  GroupViewRepoDelegate.swift
//  Gandalf
//
//  Created by Sean Hart on 2/8/21.
//

import UIKit
import FirebaseAuth

extension GroupView: GroupRepositoryDelegate {
    
    // MARK: -REPOSITORY METHODS
    
    func groupDataUpdate(loadGroupId: String?) {
        guard let groupRepo = groupRepository else { return }
        localUnreadGroups.removeAll()
        localGroups.removeAll()
        // Find all groups where the current user's last activity was
        // earlier than the group's last activity. Assume unread if null values.
        if let firUser = Settings.Firebase.auth().currentUser {
            localUnreadGroups = groupRepo.groups.filter({
                $0.lastViewed?[firUser.uid] ?? 0.0 <= $0.lastActive?.values.max() ?? 0.0
            })
        }
        // Get all groups not caught by the unread filter.
        localGroups = groupRepo.groups.filter({
            let findGroupId = $0.id
            return !localUnreadGroups.compactMap({ $0.id }).contains(findGroupId)
        })
        groupTableView.reloadData()
        groupTableViewSpinner.stopAnimating()
        
        // If a groupId was passed with the updated data protocol,
        // then the group needs to be opened upon data update.
        if let groupId = loadGroupId {
            let foundGroups = localGroups.filter({ $0.id == groupId })
            if foundGroups.count > 0 {
                self.navigationController?.pushViewController(MessageView(group: foundGroups[0]), animated: true)
            }
        }
    }
    
    func requestError(message: String) {
        let alert = UIAlertController(title: "Something went wrong!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    // MARK: -GESTURE METHODS
    
    @objc func addGroup(_ sender: UITapGestureRecognizer) {
        print("\(className) - addGroup")
        let alert = UIAlertController(title: "New Group", message: "Please name your new group.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("ADD GROUP: \(textField.text)")
            guard let name = textField.text else { return }
            if name.count > 0 {
                self.groupRepository.createGroup(title: name)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Name"
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.yes
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
                    if let tf = notification.object as? UITextField {
                        let maxLength = 20
                        if let text = tf.text {
                            if text.count > maxLength {
                                tf.text = String(text.prefix(maxLength))
                            }
                        }
                    }
                })
        })
        self.present(alert, animated: true)
    }
    @objc func joinGroup(_ sender: UITapGestureRecognizer) {
        print("\(className) - joinGroup")
        let alert = UIAlertController(title: "Join Group", message: "Please enter a group code provided by a current group member.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Join", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("JOIN GROUP: \(textField.text)")
            guard let code = textField.text else { return }
            if code.count > 0 {
                self.groupRepository.joinGroup(code: code)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Code"
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        })
        self.present(alert, animated: true)
    }
    
    func editTitle(groupId: String, currentTitle: String) {
        print("\(className) - editName")
        let alert = UIAlertController(title: "Edit Name", message: "Rename the group. All group members will see the new name.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Rename", style: .default, handler: { action in
            let textField = alert.textFields![0] as UITextField
//            print("EDIT GROUP: \(textField.text)")
            guard let title = textField.text else { return }
            if title.count > 0 {
                self.groupRepository.editGroupTitle(groupId: groupId, title: title)
            }
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField(configurationHandler: { (textField: UITextField!) -> Void in
            textField.placeholder = "Group Name"
            textField.text = currentTitle
            textField.font = UIFont(name: Assets.Fonts.Default.light, size: 14)
            textField.autocorrectionType = UITextAutocorrectionType.no
            textField.keyboardType = UIKeyboardType.default
            textField.returnKeyType = UIReturnKeyType.done
            textField.clearButtonMode = UITextField.ViewMode.whileEditing
            textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
            NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: { (notification) in
                    if let tf = notification.object as? UITextField {
                        let maxLength = 20
                        if let text = tf.text {
                            if text.count > maxLength {
                                tf.text = String(text.prefix(maxLength))
                            }
                        }
                    }
                })
        })
        self.present(alert, animated: true)
    }
}
