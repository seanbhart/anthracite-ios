//
//  MessageViewDataHandlers.swift
//  Gandalf
//
//  Created by Sean Hart on 2/9/21.
//

import UIKit

extension MessageView: UITextViewDelegate, UIGestureRecognizerDelegate, MessageRepositoryDelegate {
    
    // MARK: -GESTURE RECOGNIZERS

    @objc func viewContainerTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - viewContainerTap")
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MessageInputCell {
            allowEndEditing = true
            cell.textView.endEditing(true)
            allowEndEditing = false
        }
    }
    
    // Ensure a tap to a cell falls through to the cell and not caught by the view
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        var tapPoint = touch.location(in: messageTableView)
        var indexPath = messageTableView.indexPathForRow(at: tapPoint)
        if indexPath != nil {
            return false
        }
        tapPoint = touch.location(in: tickerTableView)
        indexPath = tickerTableView.indexPathForRow(at: tapPoint)
        if indexPath != nil {
            return false
        }
        return true
    }
    
    @objc func textFieldTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - textFieldTap: \(sender.view?.tag)")
        guard let viewTapped = sender.view else { return }
        if viewTapped.tag < 0 || viewTapped.tag > inputTickers.count-1 { return }
        inputTickers[viewTapped.tag].cycleSentiment()
        processInputTickers()
    }
    
    
    // MARK: -TEXTVIEW METHODS
    
    func textViewDidChange(_ textView: UITextView) {
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MessageInputCell {
            if textView == cell.textView {
                if textView.text == "" {
                    cell.placeholder.text = "New Message"
                } else {
                    cell.placeholder.text = ""
                    textView.textColor = Settings.Theme.Color.text
                    // formatInputText returns a tuple with the formatted text and a list of found ticker strings
                    let result = formatInputText(text: String(textView.text.prefix(200)), textColor: Settings.Theme.Color.barText)
                    textView.attributedText = result.0
                    inputTickerStrings.removeAll()
                    inputTickerStrings = result.1
                    processInputTickers()
                }
            }
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
//        print("\(className) - textViewShouldEndEditing")
        if let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MessageInputCell {
            if textView == cell.textView {
                return allowEndEditing
            }
        }
        return true
    }
    
    
    // MARK: -REPO METHODS
    
    func getLocalTickers() -> [Ticker] {
        return localTickers
    }
    func messageCreateError(text: String) {
        guard let cell = inputTableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? MessageInputCell else { return }
        cell.textView.text = text
    }
    func messageDataUpdate() {
        guard let messageRepo = messageRepository else { return }
        if messageRepo.messages.count < 1 {
            noMessagesSetup()
            return
        } else {
            messagesSetup()
        }
        
        // Switch out the local data with newly synced data
        // Handle tickers first to prep for filling notion list
        // Sort tickers first by response then alphabetically
        localTickers.removeAll()
        localTickers = messageRepo.tickers.sorted(by: {
            if $0.responseCount != $1.responseCount {
                return $0.responseCount < $1.responseCount
            } else {
                return $0.ticker > $1.ticker
            }
        })
        
        fillLocalMessages()
        accountNames = messageRepo.accountNames
        
        let bottomDist = messageTableView.contentSize.height - messageTableView.contentOffset.y - messageTableView.frame.height
        if initialLoad || bottomDist < messageCellHeight * 2 {
            if localMessages.count > 0 {
                messageTableView.scrollToRow(at: IndexPath(row: localMessages.count-1, section: 0), at: .top, animated: true)
            }
            if localTickers.count > 0 {
                tickerTableView.scrollToRow(at: IndexPath(row: localTickers.count-1, section: 0), at: .top, animated: true)
            }
            initialLoad = false
        }
    }
    
    
    // MARK: -CUSTOM FUNCTIONS
    
    func clearTickerFilter() {
        // Set all tickers to not selected
        for i in localTickers.indices {
            localTickers[i].selected = false
        }
        if localTickers.count > 0 {
            tickerTableView.scrollToRow(at: IndexPath(row: localTickers.count-1, section: 0), at: .top, animated: true)
        }
        
        // Now refill the Message list
        fillLocalMessages()
    }
    
    func fillLocalMessages() {
        guard let messageRepo = messageRepository else { return }
        localMessages.removeAll()
        // Filter the data based on ticker selection ONLY IF ANY ARE SELECTED
        if localTickers.filter({ $0.selected }).count > 0 {
            localMessages = messageRepo.messages.filter({
                let allTickerStrings = $0.tickers?.compactMap({ $0.ticker })
                return localTickers.filter({ (allTickerStrings?.contains($0.ticker) ?? false) && $0.selected }).count > 0
            })
        } else {
            localMessages = messageRepo.messages
        }
        localMessages = localMessages.sorted(by: { $0.timestamp < $1.timestamp })
        messageTableView.reloadData()
        if localMessages.count > 0 {
            messageTableView.scrollToRow(at: IndexPath(row: localMessages.count-1, section: 0), at: .top, animated: true)
        }
        tickerTableView.reloadData()
    }
    
    func formatInputText(text: String, textColor: UIColor) -> (NSMutableAttributedString, [String]) {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 30
        let string: NSMutableAttributedString = NSMutableAttributedString(string: String(text.prefix(200)), attributes: [ //String(text.prefix(140))
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.regular, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.paragraphStyle : style
        ])
        var words: [String] = text.components(separatedBy: " ")
        var tickers = [String]()
        for i in words.indices {
            words[i] = words[i].trimmingCharacters(in: .punctuationCharacters)
            if words[i].hasPrefix("$") {
                tickers.append(String(words[i].dropFirst().uppercased()))
                let range: NSRange = (string.string as NSString).range(of: words[i])
                string.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: range)
                string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Assets.Fonts.Default.bold, size: 16) ?? UIFont.boldSystemFont(ofSize: 22), range: range)
                string.replaceCharacters(in: range, with: words[i].uppercased())
            }
        }
        return (string, tickers)
    }
    
    func formatMessageText(message: MessageGandalf) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        let string: NSMutableAttributedString = NSMutableAttributedString(string: message.text, attributes: [
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.regular, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.paragraphStyle : style
        ])
        // For each of the tickers in the message, search the text for the ticker plus
        // a "$" prefix and use the found range to format the text based on stored message ticker settings
        guard let mTickers = message.tickers else { return string }
        for t in mTickers {
            let range: NSRange = (string.string as NSString).range(of: "$" + t.ticker)
            string.addAttribute(NSAttributedString.Key.foregroundColor, value: t.getSentimentColor(), range: range)
            string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Assets.Fonts.Default.bold, size: 16) ?? UIFont.boldSystemFont(ofSize: 20), range: range)
//            string.replaceCharacters(in: range, with: words[i].uppercased())
        }
        return string
    }
    
    private func processInputTickers() {
//        print("processInputTickers: \(inputTickerStrings)")
        // For each string ticker, create a TickerInput object with a neutral sentiment
        // (unless it already exists in the array) and create a TextField for the ticker
        
        var tempInputTickers: [MessageTicker] = inputTickerStrings.map({ MessageTicker(ticker: $0) })
        for i in tempInputTickers.indices {
            if inputTickers.filter({ $0.ticker == tempInputTickers[i].ticker }).count > 0 {
                tempInputTickers[i].sentiment = inputTickers.filter({ $0.ticker == tempInputTickers[i].ticker })[0].sentiment
            }
        }
        inputTickers.removeAll()
        inputTickers = tempInputTickers
        
        inputTickers.sort(by: { $0.ticker < $1.ticker })
        inputTickerContainer.subviews.forEach({ $0.removeFromSuperview() })
        var contentWidth = 0
        for (i, iTicker) in inputTickers.enumerated() {
            let fieldWidth = iTicker.ticker.count*20+30
            let textField = UITextField(frame: CGRect(x: contentWidth, y: 5, width: fieldWidth, height: 40))
            textField.tag = i
            textField.text = "$" + iTicker.ticker
            textField.textAlignment = .center
            textField.font = UIFont(name: Assets.Fonts.Default.bold, size: 22)
            textField.textColor = iTicker.getSentimentColor()
            
            let tapGesture = UITapGestureRecognizer(target: self, action:#selector(textFieldTap))
            tapGesture.delegate = self
            tapGesture.numberOfTapsRequired = 1
            textField.addGestureRecognizer(tapGesture)
            
            inputTickerContainer.addSubview(textField)
            contentWidth += fieldWidth
            inputTickerContainer.contentSize = CGSize(width: contentWidth, height: 50)
        }
    }
    
    private func noMessagesSetup() {
        print("noMessagesSetup 1")
        viewContainer.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo:viewContainer.topAnchor),
            headerLabel.leftAnchor.constraint(equalTo:viewContainer.leftAnchor),
            headerLabel.rightAnchor.constraint(equalTo:viewContainer.rightAnchor),
            headerLabel.heightAnchor.constraint(equalToConstant: 100),
        ])
        // Reload the tables in case there was data and then deleted
        localTickers.removeAll()
        localMessages.removeAll()
        messageTableView.reloadData()
        tickerTableView.reloadData()
        tickerTableViewSpinner.stopAnimating()
        messageTableViewSpinner.stopAnimating()
        
//        var messageTicker1 = MessageTicker(ticker: "AAPL")
//        messageTicker1.sentiment = .positive
//        var messageTicker2 = MessageTicker(ticker: "MSFT")
//        messageTicker2.sentiment = .neutral
//        var messageTicker3 = MessageTicker(ticker: "S&P")
//        messageTicker3.sentiment = .negative
//        messageRepository.createMessage(text: "Check out $AAPL and $MSFT on the $S&P. Use the \"$\" sign to track stock tickers and topics.\n\nTap tickers at the bottom to set your price expectations and swipe right to post your message.", tickers: [
//            messageTicker1,
//            messageTicker2,
//            messageTicker3
//        ])
    }
    private func messagesSetup() {
        headerLabel.removeFromSuperview()
    }
}
