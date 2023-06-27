//
//  Protocols.swift
//  Mafia
//
//  Created by Beliy.Bear on 27.06.2023.
//

import Foundation

protocol CardSelectionDelegate: AnyObject {
    func showSelectedCardAlert(cardNumber: Int)
}
