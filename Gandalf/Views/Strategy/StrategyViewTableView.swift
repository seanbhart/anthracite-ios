//
//  StrategyViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 4/30/21.
//

import UIKit

extension StrategyView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localStrategies.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: strategyTableCellIdentifier, for: indexPath) as! StrategyCell
        cell.selectionStyle = .none
        
//        cell.title.font = UIFont(name: Assets.Fonts.Default.regular, size: 20)
//        cell.title.text = "@" + localStrategies[indexPath.row].creator
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
//        var group: Group!
//        group = localGroups[indexPath.row]
//        self.navigationController?.pushViewController(MessageView(group: group), animated: true)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != strategyTableView { return nil }
        let copyCode = UIContextualAction(style: .normal, title: "COPY CODE") { (action, view, completionHandler) in
            print("COPY CODE: \(indexPath.row)")
            var groupId = ""
            if let id = self.localStrategies[indexPath.row].id { groupId = id }
            UIPasteboard.general.string = groupId
            
            let alert = UIAlertController(title: "", message: "Copied to clipboard.", preferredStyle: .alert)
            self.present(alert, animated: true, completion: {
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                    self.dismiss(animated: true, completion: nil)
                }
            })
            
            completionHandler(true)
        }
        copyCode.backgroundColor = Settings.Theme.Color.barText
        let editName = UIContextualAction(style: .normal, title: "EDIT NAME") { (action, view, completionHandler) in
            print("EDIT TITLE: \(indexPath.row)")
//            if let id = self.localOrders[indexPath.row].id {
//                self.editTitle(groupId: id, currentTitle: self.localOrders[indexPath.row].symbol)
//            }
            completionHandler(true)
        }
        editName.backgroundColor = Settings.Theme.Color.selected
        return UISwipeActionsConfiguration(actions: [copyCode, editName])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView != strategyTableView { return nil }
        let remove = UIContextualAction(style: .normal, title: "REMOVE ME") { (action, view, completionHandler) in
            print("REMOVE FROM GROUP: \(indexPath.row)")
//            var order = self.localOrders[indexPath.row]
//
//            // Alert to confirm removal of group
//            let alert = UIAlertController(title: "Confirm Remove Group", message: "Are you sure you want to remove yourself from \(order.symbol)?", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Remove", style: .default, handler: { action in
//                guard let orderId = order.id else { return }
//                self.groupRepository.removeCurrentAccount(groupId: orderId)
//            }))
//            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//            self.present(alert, animated: true)
            
            completionHandler(true)
        }
        remove.backgroundColor = Settings.Theme.Color.negative
        return UISwipeActionsConfiguration(actions: [remove])
    }
}

