//
//  ShadowPosition.swift
//  Gandalf
//
//  Created by Sean Hart on 4/3/21.
//

import Foundation
import FirebaseFirestoreSwift

struct ShadowPosition: Identifiable, Codable {
    @DocumentID var id: String?
    var target: String?
    var shadow: String?
    var symbol: String?
    var perc: Double?
    var percIdeal: Double?
    var price: Double?
    var quantity: Double?
    var quantityIdeal: Double?
    var quantityNoDaytrading: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case target
        case shadow
        case symbol
        case perc
        case percIdeal = "perc_ideal"
        case price
        case quantity
        case quantityIdeal = "quantity_ideal"
        case quantityNoDaytrading = "quantity_no_daytrading"
    }
}
