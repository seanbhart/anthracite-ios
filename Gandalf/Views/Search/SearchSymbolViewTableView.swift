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
        return localSymbols.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: symbolTableCellIdentifier, for: indexPath) as! SymbolCell
        cell.selectionStyle = .none
//        print("\(className) - ROW \(localSymbols[indexPath.row])")
        cell.symbolLabel.text = localSymbols[indexPath.row].symbol
        cell.symbolDescLabel.text = localSymbols[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
        updateSymbol(symbol: localSymbols[indexPath.row].symbol)
    }
}
