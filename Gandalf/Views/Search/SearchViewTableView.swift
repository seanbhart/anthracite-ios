//
//  SearchViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/3/21.
//

import UIKit

extension SearchView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(className) - tableView results count \(results.count)")
        return results.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resultsTableCellIdentifier, for: indexPath) as! SearchResultsCell
        cell.selectionStyle = .none
        cell.resultLabel.text = results[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let parent = self.delegate {
            parent.searchViewSelected(selection: results[indexPath.row])
        }
    }
}
