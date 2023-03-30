//
//  Players.swift
//  Mafia
//
//  Created by Beliy.Bear on 25.03.2023.
//

import Foundation
import UIKit

class Players{
    private var countPlayers: Int = 0
    private var countPlayersLabel: UILabel = {
        let count = UILabel()
        count.textColor = .mainWhite
        count.text = "\(countPlayers)"
        return count
    }()
}
