//
//  MessageViewTableView.swift
//  Gandalf
//
//  Created by Sean Hart on 2/9/21.
//

import UIKit
import FirebaseAuth
import FirebaseStorage

extension MessageView: UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {
    
    // MARK: -TABLEVIEW DATA SOURCE

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if tableView == inputTableView {
//            return 1
//
//        } else
        if tableView == messageTableView {
            if localMessages.count > 0 {
                messageTableViewSpinner.stopAnimating()
            } else if !initialLoad {
                messageTableViewSpinner.startAnimating()
            }
            return localMessages.count
            
        } else if tableView == tickerTableView {
            if localTickers.count > 0 {
                tickerTableViewSpinner.stopAnimating()
            } else if !initialLoad {
                tickerTableViewSpinner.startAnimating()
            }
            return localTickers.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableView.automaticDimension
//        if tableView == inputTableView {
//            return 50
//
//        } else
        if tableView == messageTableView {
            return UITableView.automaticDimension //messageCellHeight
            
        } else if tableView == tickerTableView {
            return 50
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == messageTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageTableCellIdentifier, for: indexPath) as! MessageCellGandalf
            cell.selectionStyle = .none

            let message = localMessages[indexPath.row]
            cell.textView.attributedText = formatMessageText(message: message)
            
            cell.title.text = "loading..."
            for a in accountNames {
                if a.key == localMessages[indexPath.row].account {
                    cell.title.text = a.value
                    break
                }
            }
            cell.title.sizeToFit()
            cell.title.layoutIfNeeded()
            
            cell.timeLabel.text = Settings.formatDateString(timestamp: localMessages[indexPath.row].timestamp)
            
            cell.accountImage.image = UIImage(systemName: "person.crop.circle.fill")?.withTintColor(Settings.Theme.Color.primary, renderingMode: .alwaysOriginal)
            for a in accountImages {
                if a.key == localMessages[indexPath.row].account {
                    cell.accountImage.image = a.value
                    break
                }
            }
            
            return cell
            
        } else if tableView == tickerTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: tickerTableCellIdentifier, for: indexPath) as! MessageTickerCell
            cell.selectionStyle = .none
            let cellTicker = localTickers[indexPath.row]
            if let t = cellTicker.ticker {
                cell.title.text = "$" + t
                
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                let formattedSum = numberFormatter.string(from: NSNumber(value: cellTicker.responseCount))
                cell.countText.text = formattedSum
                
                if cellTicker.wAvgSentiment > 0 {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconPosLg)
                    cell.title.textColor = Settings.Theme.Color.positiveLight
                    cell.countText.textColor = Settings.Theme.Color.positiveLight
                } else if cellTicker.wAvgSentiment < 0 {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconNegLg)
                    cell.title.textColor = Settings.Theme.Color.negativeLight
                    cell.countText.textColor = Settings.Theme.Color.negativeLight
                } else {
                    cell.notionIcon.image = UIImage(named: Assets.Images.notionIconGrayLg)
                    cell.title.textColor = Settings.Theme.Color.primary
                    cell.countText.textColor = Settings.Theme.Color.primary
                }
            }
            if cellTicker.selected {
                cell.containerView.backgroundColor = Settings.Theme.Color.selected
            } else {
                cell.containerView.backgroundColor = Settings.Theme.Color.contentBackground
            }
            
            return cell
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        allowEndEditing = true
        inputTextView.endEditing(true)
        allowEndEditing = false
        
        if tableView == messageTableView {
            print("MESSAGE ROW \(indexPath.row)")
            
        } else if tableView == tickerTableView {
            print("TICKER ROW \(indexPath.row)")
            if localTickers[indexPath.row].selected {
                localTickers[indexPath.row].selected = false
            } else {
                localTickers[indexPath.row].selected = true
            }
            fillLocalMessages()
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        if tableView == messageTableView {
            guard let firUser = Auth.auth().currentUser else { return nil }
            if localMessages[indexPath.row].account != firUser.uid { return nil }
            let negative = UIContextualAction(style: .normal, title: "DELETE") { (action, view, completionHandler) in
                print("DELETE MESSAGE: \(indexPath.row)")
                self.messageRepository.deleteMessage(id: self.localMessages[indexPath.row].id)
                completionHandler(true)
            }
            negative.backgroundColor = Settings.Theme.Color.negative
            return UISwipeActionsConfiguration(actions: [negative])
        }
        return nil
    }
    
    
    // MARK: -SCROLL VIEW DELEGATE METHODS

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == tickerTableView {
//            print("tickerTableView OFFSET: \(tickerTableView.contentOffset), SIZE: \(tickerTableView.contentSize), FRAME: \(tickerTableView.frame.size)")
//            print(tickerTableView.contentOffset.y - (tickerTableView.contentSize.height - tickerTableView.frame.size.height))
            if tickerTableView.contentOffset.y - (tickerTableView.contentSize.height - tickerTableView.frame.size.height) > 70 {
                clearTickerFilter()
            }
        }
    }
}
