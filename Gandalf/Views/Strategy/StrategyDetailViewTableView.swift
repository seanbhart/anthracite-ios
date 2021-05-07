//
//  StrategyDetailViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/5/21.
//

import UIKit

extension StrategyDetailView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return strategy.orders.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: orderTableCellIdentifier, for: indexPath) as! StrategyDetailCell
        cell.selectionStyle = .none
        
        let order = strategy.orders[indexPath.row]
        cell.symbolLabel.text = order.symbol
        if order.predictPriceDirection == 0 {
            cell.symbolLabel.textColor = Settings.Theme.Color.negative
            cell.symbolLabelLabel.textColor = Settings.Theme.Color.negative
            cell.symbolLabelLabel.text = "DECREASING PRICE PREDICTION"
        } else {
            cell.symbolLabel.textColor = Settings.Theme.Color.positive
            cell.symbolLabelLabel.textColor = Settings.Theme.Color.positive
            cell.symbolLabelLabel.text = "INCREASING PRICE PREDICTION"
        }
        
        cell.directionLabel.text = Order.directionToString(direction: order.direction)
        cell.typeLabel.text = Order.typeToString(type: order.type)
        if order.type > 0 {
            cell.priceLabel.text = dollarString(order.price)
            
            if order.type == 1 {
                cell.priceLabelLabel.text = "LIMIT PRICE"
            } else {
                cell.priceLabelLabel.text = "PRICE"
            }
        } else {
            cell.priceLabelLabel.text = ""
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("\(className) - TAPPED ROW \(indexPath.row)")
    }
}
