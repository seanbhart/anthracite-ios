//
//  SearchSymbolViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit

extension SearchSymbolView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 //localStrategies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: symbolTableCellIdentifier, for: indexPath) as! SymbolCell
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
//        var group: Group!
//        group = localGroups[indexPath.row]
//        self.navigationController?.pushViewController(MessageView(group: group), animated: true)
    }
}

