// Cards.swift
// Mafia
//
// Created by Beliy.Bear on 25.03.2023.
//
import Foundation
import UIKit

class Card {
    var word: String
    var avatar: UIImage
    var frame = UIImage(named: "cardFrame")
    var countCard: Int
    lazy var plusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "plusButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(plusAction), for: .touchUpInside)
        button.layer.zPosition = 50
        return button
    }()
    lazy var minusButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "minusButton")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(minusAction), for: .touchUpInside)
        button.layer.zPosition = 50
        return button
    }()
    var countCardLabel: UILabel = {
        let count = UILabel()
        count.text = "0"
        count.textColor = .black
        count.textAlignment = .center
        count.font = .boldSystemFont(ofSize: 45)
        count.translatesAutoresizingMaskIntoConstraints = false
        count.layer.zPosition = 50
        return count
    }()
    
    init(word: String, avatar: UIImage, countCard: Int) {
        self.word = word
        self.avatar = avatar
        self.countCard = countCard
    }
    
    @objc func plusAction() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        countCard += 1
        countCardLabel.text = "\(countCard)"
    }
    
    @objc func minusAction() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        if countCard >= 1 {
            countCard -= 1
        }
        countCardLabel.text = "\(countCard)"
    }
}
