//
//  Numbers.swift
//  Gandalf
//
//  Created by Sean Hart on 5/1/21.
//

import Foundation

func dollarString(_ value: Double?) -> String {
    guard value != nil else { return "$0.00" }
    let oldValueRounded = Double(round(100 * value!) / 100)
    let formatter = NumberFormatter()
    formatter.currencyCode = "USD"
    formatter.currencySymbol = "$"
    formatter.maximumFractionDigits = 2
    formatter.numberStyle = .currencyAccounting
    return formatter.string(from: NSNumber(value: oldValueRounded)) ?? "$\(oldValueRounded)"
}

func timestampToDateEST(timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp / 1000)
    let dateFormatter = DateFormatter()
    dateFormatter.timeZone = TimeZone(abbreviation: "EST")
    dateFormatter.locale = NSLocale.current
//    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
    dateFormatter.dateFormat = "MMM dd, yyyy"
    return dateFormatter.string(from: date).uppercased()
}

func timestampToDatetimeLocal(timestamp: Double) -> String {
    let date = Date(timeIntervalSince1970: timestamp / 1000)
    let dateFormatter = DateFormatter()
    dateFormatter.locale = NSLocale.current
    dateFormatter.amSymbol = "AM"
    dateFormatter.pmSymbol = "PM"
    dateFormatter.dateFormat = "MMM dd, h:mm a"
    return dateFormatter.string(from: date).uppercased()
}
