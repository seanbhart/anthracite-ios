//
//  WindowPickerViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/4/21.
//

import UIKit

extension WindowPickerView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: timesTableCellIdentifier, for: indexPath) as! TextCell
        cell.selectionStyle = .none
        cell.cellTextLabel.text = options[indexPath.row]["text"] as? String ?? ""
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let secondsTime = options[indexPath.row]["seconds"] as? TimeInterval ?? 0
        datePicker.setDate(Date(timeIntervalSinceNow: secondsTime), animated: true)
    }
}
