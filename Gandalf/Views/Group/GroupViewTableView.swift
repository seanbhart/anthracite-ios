//
//  GroupViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/8/21.
//

import UIKit

extension GroupListView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 35))
        let label = UILabel(frame: CGRect(x: 15, y: 10, width: headerView.frame.width-30, height: headerView.frame.height-20))
        label.backgroundColor = .clear
        label.font = UIFont(name: Assets.Fonts.Default.medium, size: 15)
        label.textColor = Settings.Theme.Color.textGrayLight
        label.textAlignment = NSTextAlignment.left
        label.numberOfLines = 1
        label.isUserInteractionEnabled = false
        label.translatesAutoresizingMaskIntoConstraints = false
        if section == 0 {
            label.text = "UNREAD"
        } else {
            label.text = "SUBSCRIBED"
        }
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localGroups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: groupTableCellIdentifier, for: indexPath) as! GroupCell
        cell.selectionStyle = .none
        cell.title.font = UIFont(name: Assets.Fonts.Default.light, size: 20)
        cell.title.text = "#   " + localGroups[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
        self.navigationController?.pushViewController(MessageView(group: localGroups[indexPath.row]), animated: true)
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        if tableView != groupTableView { return nil }
//        let copyCode = UIContextualAction(style: .normal, title: "COPY CODE") { (action, view, completionHandler) in
//            print("COPY CODE: \(indexPath.row)")
//            var groupId = ""
//            if let id = self.localGroups[indexPath.row].id { groupId = id }
//            UIPasteboard.general.string = groupId
//
//            let alert = UIAlertController(title: "", message: "Copied to clipboard.", preferredStyle: .alert)
//            self.present(alert, animated: true, completion: {
//                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
//                    self.dismiss(animated: true, completion: nil)
//                }
//            })
//
//            completionHandler(true)
//        }
//        copyCode.backgroundColor = Settings.Theme.Color.barText
//        let editName = UIContextualAction(style: .normal, title: "EDIT NAME") { (action, view, completionHandler) in
//            print("EDIT TITLE: \(indexPath.row)")
//            if let id = self.localGroups[indexPath.row].id {
//                self.editTitle(groupId: id, currentTitle: self.localGroups[indexPath.row].title)
//            }
//            completionHandler(true)
//        }
//        editName.backgroundColor = Settings.Theme.Color.contentBackgroundLight
//        return UISwipeActionsConfiguration(actions: [copyCode, editName])
//    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != groupTableView { return nil }
        let remove = UIContextualAction(style: .normal, title: "REMOVE ME") { (action, view, completionHandler) in
            print("REMOVE FROM GROUP: \(indexPath.row)")
            var group: Group!
            group = self.localGroups[indexPath.row]
            
            // Alert to confirm removal of group
            let alert = UIAlertController(title: "Confirm Remove Group", message: "Are you sure you want to remove yourself from \(group.name)?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
                guard let groupId = group.id else { return }
                self.groupRepository.removeCurrentAccount(groupId: groupId)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        remove.backgroundColor = Settings.Theme.Color.negative
        return UISwipeActionsConfiguration(actions: [remove])
    }
}
