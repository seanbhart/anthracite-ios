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
        // If the tap was inside the send button, send the message and reset
        // the input view, otherwise register a tap to close the keyboard
        let inputSendPoint = sender.location(in: inputSend)
        if inputSendPoint.x > 0 && inputSendPoint.y > 0 {
            sendMessage()
        } else {
            allowEndEditing = true
            inputTextView.endEditing(true)
            allowEndEditing = false
        }
    }
    
    @objc func dollarSignTap(_ sender: UITapGestureRecognizer) {
        print("\(className) - dollarSignTap")
        inputTextView.insertText("$")
        inputText(text: inputTextView.text, newText: true)
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

        // Cast the tapped view as a textfield and recolor
        // the text to match the new sentiment. Don't re-process
        // the entire ticker list or the scrollview will be
        // reset to the left on the screen.
        if let v = viewTapped as? UITextField {
            v.textColor = inputTickers[viewTapped.tag].getSentimentColor()
        }
        
        // Reprocess the text to show the sentiment colors.
        inputText(text: inputTextView.text, newText: false)
    }
    
    
    // MARK: -TEXTVIEW METHODS
    
    func textViewDidChange(_ textView: UITextView) {
//        print("\(className) - textViewDidChange")
        if textView == inputTextView {
            if textView.text == "" {
                inputPlaceholder.text = "New Message"
            } else {
                inputText(text: textView.text, newText: true)
            }
        }
    }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        print("\(className) - textViewShouldEndEditing")
        if textView == inputTextView {
            return allowEndEditing
        }
        return true
    }
    
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//
//    }
    
    
    // MARK: -REPO METHODS
    
    func getLocalTickers() -> [Ticker] {
        return localTickers
    }
    func messageCreateError(text: String) {
        inputTextView.text = text
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
        accountImages = messageRepo.accountImages
        
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
    
    private func sendMessage() {
        print("\(className) - sendMessage")
        guard let messageRepo = messageRepository else { return }
        messageRepo.createMessage(text: inputTextView.text, tickers: inputTickers)
        inputTextView.endEditing(true)
        inputTextView.text = ""
        inputText(text: "", newText: true)
        inputPlaceholder.text = "New Message"
        inputTickers.removeAll()
        inputTickerContainer.subviews.forEach({ $0.removeFromSuperview() })
    }
    
    func inputText(text: String, newText: Bool) {
        inputTextView.becomeFirstResponder()
        inputPlaceholder.text = ""
        inputTextView.textColor = Settings.Theme.Color.text
        
        // Increase the height of the textview to 100 if the text spans multiple lines
        let oldHeight = inputTextView.frame.height
        let maxHeight: CGFloat = 100.0 //beyond this value the textView will scroll
        var newHeight = min(inputTextView.sizeThatFits(CGSize(width: inputTextView.frame.width, height: CGFloat.greatestFiniteMagnitude)).height, maxHeight)
        newHeight = ceil(newHeight)
//                print("\(className) - newHeight: \(newHeight)")
        if newHeight != oldHeight && newHeight > 50 {
            inputContainerHeightConstraint?.constant = 100
            inputContainer.layoutIfNeeded()
            inputTextView.isScrollEnabled = true
        } else if inputContainerHeightConstraint != nil && inputContainerHeightConstraint!.constant > 50 {
            inputContainerHeightConstraint?.constant = 50
            inputContainer.layoutIfNeeded()
            inputTextView.isScrollEnabled = false
        }
        
        // formatInputText returns a tuple with the formatted text and a list of found ticker strings
        let result = formatInputText(text: String(text.prefix(200)), textColor: Settings.Theme.Color.barText)
        
        // Before replacing the textview text, capture the location of the cursor
        // and insert it back in the same place after converting the text. If the
        // cursor location cannot be determined, put the cursor at the end of the text.
        if let selectedRange = inputTextView.selectedTextRange {
            if let cursorPosition = inputTextView.position(from: selectedRange.start, offset: 0) {
                inputTextView.attributedText = result.0
                inputTextView.selectedTextRange = inputTextView.textRange(from: cursorPosition, to: cursorPosition)
            }
        } else {
            inputTextView.attributedText = result.0
            inputTextView.selectedTextRange = inputTextView.textRange(from: inputTextView.endOfDocument, to: inputTextView.endOfDocument)
        }
        
        // Reset the found tickers with the updated search
        // if indicated that new text was passed (could just
        // be a re-processing of the textview for sentiment change).
        if newText {
            inputTickerStrings.removeAll()
            inputTickerStrings = result.1
            processInputTickers()
        }
    }
    
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
        style.minimumLineHeight = 20
        let string: NSMutableAttributedString = NSMutableAttributedString(string: String(text.prefix(200)), attributes: [ //String(text.prefix(140))
            NSAttributedString.Key.foregroundColor: Settings.Theme.Color.text,
            NSAttributedString.Key.font: UIFont(name: Assets.Fonts.Default.regular, size: 16) ?? UIFont.boldSystemFont(ofSize: 16),
            NSAttributedString.Key.paragraphStyle : style
        ])
        let split = text.split { [" ", "\n"].contains(String($0)) }
        var words = split.map { String($0).trimmingCharacters(in: .whitespaces) }
//        var words: [String] = text.components(separatedBy: " ")
        var tickers = [String]()
        for i in words.indices {
            words[i] = words[i].trimmingCharacters(in: .punctuationCharacters)
            // Search for the dollar sign at the beginning of a word
            if words[i].hasPrefix("$") {
                // If the dollar sign is followed by a number or decimal point,
                // don't capture it (likely currency)
                if words[i].prefix(2).rangeOfCharacter(from: .decimalDigits) == nil && words[i].prefix(2).range(of: ".") == nil {
                    let tickerStringToAdd = String(words[i].dropFirst().uppercased())
                    tickers.append(tickerStringToAdd)
                    
                    // Check if the ticker is already in the ticker list with a sentiment value
                    // if so, use the current sentiment setting to color the text.
                    var textColorToUse = textColor
                    let foundTickers = inputTickers.filter({ $0.ticker == tickerStringToAdd })
                    if foundTickers.count > 0 {
                        textColorToUse = foundTickers[0].getSentimentColor()
                    }
                    
                    let range: NSRange = (string.string as NSString).range(of: words[i])
                    string.addAttribute(NSAttributedString.Key.foregroundColor, value: textColorToUse, range: range)
                    string.addAttribute(NSAttributedString.Key.font, value: UIFont(name: Assets.Fonts.Default.bold, size: 16) ?? UIFont.boldSystemFont(ofSize: 22), range: range)
                    string.replaceCharacters(in: range, with: words[i].uppercased())
                }
            }
        }
        return (string, tickers)
    }
    
    func formatMessageText(message: MessageGandalf) -> NSMutableAttributedString {
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = 20
        let string: NSMutableAttributedString = NSMutableAttributedString(string: message.text, attributes: [
            NSAttributedString.Key.foregroundColor: Settings.Theme.Color.text,
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
            let textField = UITextField(frame: CGRect(x: contentWidth, y: 5, width: fieldWidth, height: 30))
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
            inputTickerContainer.contentSize = CGSize(width: contentWidth, height: 40)
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
