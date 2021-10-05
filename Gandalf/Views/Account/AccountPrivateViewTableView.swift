//
//  AccountViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 5/7/21.
//

import UIKit

extension AccountPrivateView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, StrategyCellDelegate, StrategyDetailViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 25
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return localStrategies.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: strategyTableCellIdentifier, for: indexPath) as! StrategyCell
        cell.selectionStyle = .none
        cell.ordersContainer.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        cell.menuContainer.isHidden = false
//        cell.headerContainer.addSubview(cell.menuContainer)
//        cell.menuIcon.image = UIImage(systemName: "ellipsis")?.withTintColor(Settings.Theme.Color.textGrayMedium, renderingMode: .alwaysOriginal)
        
        cell.delegate = self
        cell.strategy = localStrategies[indexPath.row]
        cell.configureCellTimer(expiration: localStrategies[indexPath.row].windowExpiration / 1000)
        
        cell.ageLabel.text = Strategy.ageString(timestamp: localStrategies[indexPath.row].created)
//        cell.windowLabel.text = Strategy.secondsRemainToString(seconds: Int(localStrategies[indexPath.row].windowSecs))
        cell.captionLabel.text = localStrategies[indexPath.row].caption
        if let reactions = localStrategies[indexPath.row].reactions {
            let reactionCounts = StrategyReactionCount(reactions: reactions)
            cell.reactionOrderingLabel.text = "\(reactionCounts.ordering.total)"
            cell.reactionOrderingIcon.image = reactionCounts.ordering.account ? Assets.Icons.iconOrderingFill : Assets.Icons.iconOrdering
            cell.reactionUpLabel.text = "\(reactionCounts.up.total)"
            cell.reactionUpIcon.image = reactionCounts.up.account ? Assets.Icons.iconUpFill : Assets.Icons.iconUp
            cell.reactionDownLabel.text = "\(reactionCounts.down.total)"
            cell.reactionDownIcon.image = reactionCounts.down.account ? Assets.Icons.iconDownFill : Assets.Icons.iconDown
        }
        
        // Remove all existing orderContainer subviews
        cell.ordersContainer.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        
        var orderIndex = 0
        let orderCount = localStrategies[indexPath.row].orders.count
        localStrategies[indexPath.row].orders.forEach { order in
            let order = createCellOrderElement(order: order)
            cell.ordersContainer.addSubview(order)
            NSLayoutConstraint.activate([
                order.topAnchor.constraint(equalTo: cell.ordersContainer.topAnchor, constant: CGFloat(5 + (65 * orderIndex))),
                order.leftAnchor.constraint(equalTo: cell.ordersContainer.leftAnchor, constant: 0),
                order.rightAnchor.constraint(equalTo: cell.ordersContainer.rightAnchor, constant: 0),
                order.bottomAnchor.constraint(equalTo: cell.ordersContainer.bottomAnchor, constant: CGFloat(-5 + (-65 * (orderCount - 1 - orderIndex)))),
//                order.heightAnchor.constraint(equalToConstant: 60),
            ])
            
            orderIndex += 1
        }
        
        // Add the bottom border if not the last cell
        if indexPath.row < localStrategies.count - 1 {
            cell.showBorder()
        } else {
            cell.hideBorder()
        }
        return cell
    }
    
    func createCellOrderElement(order: StrategyOrder) -> UIView {
        let orderContainer = UIView()
        orderContainer.backgroundColor = Settings.Theme.Color.contentBackground
        orderContainer.layer.cornerRadius = 10
        orderContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let symbolLabel = UILabel()
        symbolLabel.backgroundColor = .clear
        symbolLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 30)
        symbolLabel.textColor = order.predictPriceDirection > 0 ? Settings.Theme.Color.positive : Settings.Theme.Color.negative
        symbolLabel.textAlignment = NSTextAlignment.left
        symbolLabel.numberOfLines = 1
        symbolLabel.text = order.symbol
        symbolLabel.isUserInteractionEnabled = false
        symbolLabel.translatesAutoresizingMaskIntoConstraints = false
        orderContainer.addSubview(symbolLabel)
        NSLayoutConstraint.activate([
            symbolLabel.topAnchor.constraint(equalTo: orderContainer.topAnchor, constant: 5),
            symbolLabel.leftAnchor.constraint(equalTo: orderContainer.leftAnchor, constant: 10),
            symbolLabel.widthAnchor.constraint(equalToConstant: 100),
            symbolLabel.heightAnchor.constraint(equalToConstant: 50),
//            symbolLabel.bottomAnchor.constraint(equalTo: orderContainer.bottomAnchor, constant: -5),
        ])
        
        let priceText = dollarString(order.price)
        let orderDirectionText = Order.directionToString(direction: order.direction)
        let orderTypeText = Order.typeToString(type: order.type)
        let summaryText = (order.type > 0) ? "\(orderTypeText) \(orderDirectionText) @ \(priceText)" : "\(orderTypeText) \(orderDirectionText)"
        
        let summaryLabel = UILabel()
        summaryLabel.backgroundColor = .clear
        summaryLabel.font = UIFont(name: Assets.Fonts.Default.semiBold, size: 18)
        summaryLabel.textColor = Settings.Theme.Color.textGrayMedium
        summaryLabel.textAlignment = NSTextAlignment.left
        summaryLabel.numberOfLines = (order.expiration != nil) ? 2 : 1
        summaryLabel.text = (order.expiration != nil) ? "\(summaryText)\n\(timestampToDateEST(timestamp: order.expiration!))" : summaryText
        summaryLabel.isUserInteractionEnabled = false
        summaryLabel.translatesAutoresizingMaskIntoConstraints = false
        orderContainer.addSubview(summaryLabel)
        NSLayoutConstraint.activate([
            summaryLabel.topAnchor.constraint(equalTo: orderContainer.topAnchor, constant: 5),
            summaryLabel.leftAnchor.constraint(equalTo: symbolLabel.rightAnchor, constant: 2),
            summaryLabel.rightAnchor.constraint(equalTo: orderContainer.rightAnchor, constant: -2),
            summaryLabel.heightAnchor.constraint(equalToConstant: 50),
//            summaryLabel.bottomAnchor.constraint(equalTo: orderContainer.bottomAnchor, constant: -5),
        ])
        
        let orderSpacer = UIView()
        orderSpacer.translatesAutoresizingMaskIntoConstraints = false
        orderContainer.addSubview(orderSpacer)
        NSLayoutConstraint.activate([
            orderSpacer.topAnchor.constraint(equalTo: summaryLabel.bottomAnchor, constant: 0),
            orderSpacer.leftAnchor.constraint(equalTo: orderContainer.leftAnchor, constant: 0),
            orderSpacer.rightAnchor.constraint(equalTo: orderContainer.rightAnchor, constant: 0),
            orderSpacer.bottomAnchor.constraint(equalTo: orderContainer.bottomAnchor, constant: -5),
        ])
        
        return orderContainer
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("\(className) - TAPPED ROW \(indexPath.row)")
//        detailView = StrategyDetailView(strategy: localStrategies[indexPath.row])
//        detailView!.delegate = self
//        self.navigationController?.presentSheet(with: detailView!)
//    }
    
    
    // MARK: -STRATEGY CELL DELEGATE METHODS
    // MARK: -STRATEGY DETAIL VIEW DELEGATE METHODS
    
    func reaction(strategyId: String, type: Int) {
        print("\(className) - \(strategyId) reaction \(type)")
        guard let parent = self.delegate else { return }
        parent.strategyReaction(strategyId: strategyId, type: type)
    }
}