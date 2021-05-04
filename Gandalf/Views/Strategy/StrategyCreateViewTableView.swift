//
//  StrategyCreateViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/2/21.
//

import UIKit

extension StrategyCreateView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, StrategyCreateCellDelegate, StrategyCreateAddRowCellDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Add an extra row for the "add new row" cell
        return localStrategyOrders.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // If the cell is the last cell, add a custom cell with an "add new row" button
        if indexPath.row == localStrategyOrders.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: strategyTableAddRowCellIdentifier, for: indexPath) as! StrategyCreateAddRowCell
            cell.selectionStyle = .none
            cell.delegate = self
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: strategyTableCellIdentifier, for: indexPath) as! StrategyCreateCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.orderIndex = indexPath.row
        
        let strategyOrder = localStrategyOrders[indexPath.row]
        if let symbol = strategyOrder.symbol {
            cell.symbolButtonLabel.text = symbol
        }
        cell.directionButtonLabel.text = Order.directionToString(direction: strategyOrder.direction)
        cell.typeButtonLabel.text = Order.typeToString(type: strategyOrder.type)
        
        if Order.typeFrom(int: strategyOrder.type) == Order.OrderType.LIMIT {
            cell.showLimitPrice()
            
            let priceButtonAccessoryView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
            priceButtonAccessoryView.backgroundColor = Settings.Theme.Color.contentBackground
            priceButtonAccessoryView.translatesAutoresizingMaskIntoConstraints = false
            let priceButtonLabel = UILabel()
            priceButtonLabel.backgroundColor = Settings.Theme.Color.grayDark
            priceButtonLabel.layer.cornerRadius = 5
            priceButtonLabel.layer.masksToBounds = true
            priceButtonLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 26)
            priceButtonLabel.textColor = Settings.Theme.Color.textGrayLight
            priceButtonLabel.textAlignment = NSTextAlignment.center
            priceButtonLabel.numberOfLines = 1
            priceButtonLabel.text = "DONE"
            priceButtonLabel.isUserInteractionEnabled = true
            priceButtonLabel.translatesAutoresizingMaskIntoConstraints = false
            priceButtonAccessoryView.addSubview(priceButtonLabel)
            NSLayoutConstraint.activate([
                priceButtonLabel.topAnchor.constraint(equalTo: priceButtonAccessoryView.topAnchor, constant: 5),
                priceButtonLabel.leftAnchor.constraint(equalTo: priceButtonAccessoryView.leftAnchor, constant: 6),
                priceButtonLabel.rightAnchor.constraint(equalTo: priceButtonAccessoryView.rightAnchor, constant: -6),
                priceButtonLabel.bottomAnchor.constraint(equalTo: priceButtonAccessoryView.bottomAnchor, constant: -5),
            ])
            
            let priceButtonGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(priceFieldDoneTap))
            priceButtonGestureRecognizer.numberOfTapsRequired = 1
            priceButtonLabel.addGestureRecognizer(priceButtonGestureRecognizer)
            cell.priceButtonField.inputAccessoryView = priceButtonAccessoryView
            
//            let toolBar = UIToolbar()
//            toolBar.sizeToFit()
//            toolBar.backgroundColor = Settings.Theme.Color.contentBackground
//            let flexiableSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
//            let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(priceFieldDoneTap))
//            toolBar.setItems([flexiableSpace, doneButton], animated: false)
//            cell.priceButtonField.inputAccessoryView = toolBar
            
            if let price = strategyOrder.price {
                cell.setLimitPrice(price: price)
            } else {
                cell.priceButtonField.text = ""
            }
        } else {
            cell.hideLimitPrice()
            cell.priceButtonField.text = ""
        }
        
        return cell
    }
    
    @objc func priceFieldDoneTap() {
        self.view.endEditing(true)
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(className) - TAPPED ROW \(indexPath.row)")
////        var group: Group!
////        group = localGroups[indexPath.row]
////        self.navigationController?.pushViewController(MessageView(group: group), animated: true)
//    }
    
    
    // MARK: -STRATEGY CELL DELEGATE METHODS
    
    func cancelOrder(orderIndex: Int) {
        localStrategyOrders.remove(at: orderIndex)
        strategyTableView.reloadData()
        if localStrategyOrders.count > 0 {
            strategyTableView.scrollToRow(at: IndexPath(row: localStrategyOrders.count, section: 0), at: .bottom, animated: true)
        }
    }
    
    func selectOrderSymbol(orderIndex: Int) {
        print("\(className) - selectOrderSymbol")
        self.navigationController?.pushViewController(SearchSymbolView(), animated: true)
    }
    
    func selectOrderDirection(orderIndex: Int) {
        if localStrategyOrders.count > orderIndex {
            switch localStrategyOrders[orderIndex].direction {
            case 0:
                localStrategyOrders[orderIndex].direction = 1
            case 1:
                localStrategyOrders[orderIndex].direction = 0
            default:
                localStrategyOrders[orderIndex].direction = 1
            }
            strategyTableView.reloadData()
        }
    }
    
    func selectOrderType(orderIndex: Int) {
        if localStrategyOrders.count > orderIndex {
            switch localStrategyOrders[orderIndex].type {
            case 0:
                localStrategyOrders[orderIndex].type = 1
            case 1:
                localStrategyOrders[orderIndex].type = 0
            default:
                localStrategyOrders[orderIndex].type = 1
            }
            strategyTableView.reloadData()
        }
    }
    
    func updateOrderPrice(orderIndex: Int, price: Double) {
        if localStrategyOrders.count > orderIndex {
            localStrategyOrders[orderIndex].price = price
            strategyTableView.reloadData()
        }
    }
    
    
    // MARK: -STRATEGY ADD ROW CELL DELEGATE METHODS
    
    func addRow() {
        // Add a default StrategyOrder
        localStrategyOrders.append(StrategyOrder(direction: 1, predictPriceDirection: 1, type: 0))
        strategyTableView.reloadData()
        strategyTableView.scrollToRow(at: IndexPath(row: localStrategyOrders.count, section: 0), at: .bottom, animated: true)
    }
}
