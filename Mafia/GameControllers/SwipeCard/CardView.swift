//
//  ChooseView.swift
//  Mafia
//
//  Created by Beliy.Bear on 25.03.2023.
//

import Foundation
import UIKit

class CardView: UIView {
    
    let card: Card
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.zPosition = -9999
        imageView.layer.opacity = 0.8
        return imageView
    }()
    
    let wordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        label.textColor = .mainWhite
        label.layer.zPosition = 99
        return label
    }()

    var countCard: Int {
        get { return card.countCard }
        set(newValue) { card.countCard = newValue }
    }
    
    let frameImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    init(card: Card) {
        self.card = card
        super.init(frame: .zero)
        
        setupSubviews()
        configureView()
        setSpeakerCard()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setSpeakerCard(){
    }
    
    private func setupSubviews() {
        addSubview(frameImageView)
        addSubview(avatarImageView)
        addSubview(wordLabel)
        addSubview(card.plusButton)
        addSubview(card.minusButton)
        addSubview(card.countCardLabel)
    }
    
    private func configureView() {
        layer.cornerRadius = 8
        clipsToBounds = true
        
        avatarImageView.image = card.avatar
        frameImageView.image = card.frame
        wordLabel.text = card.word
        
        // Layout subviews using AutoLayout or CGRect frame calculations
        // Example with AutoLayout (Remember to set translatesAutoresizingMaskIntoConstraints to false)
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        card.plusButton.translatesAutoresizingMaskIntoConstraints = false
        card.minusButton.translatesAutoresizingMaskIntoConstraints = false
        frameImageView.translatesAutoresizingMaskIntoConstraints = false
        card.countCardLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            frameImageView.topAnchor.constraint(equalTo: topAnchor),
            frameImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            frameImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            frameImageView.heightAnchor.constraint(equalToConstant: 390),
            frameImageView.widthAnchor.constraint(equalToConstant: 320),
            
            avatarImageView.topAnchor.constraint(equalTo: frameImageView.topAnchor, constant: 10),
            avatarImageView.leadingAnchor.constraint(equalTo: frameImageView.leadingAnchor),
            avatarImageView.trailingAnchor.constraint(equalTo: frameImageView.trailingAnchor),
            avatarImageView.heightAnchor.constraint(equalToConstant: 300),
            
            wordLabel.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: -20),
            wordLabel.centerXAnchor.constraint(equalTo: frameImageView.centerXAnchor),
            
            card.plusButton.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -5),
            card.plusButton.leadingAnchor.constraint(equalTo: frameImageView.leadingAnchor, constant: 8),
            
            card.minusButton.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -5),
            card.minusButton.trailingAnchor.constraint(equalTo: frameImageView.trailingAnchor, constant: -8),
            
            card.countCardLabel.bottomAnchor.constraint(equalTo: frameImageView.bottomAnchor, constant: -5),
            card.countCardLabel.centerXAnchor.constraint(equalTo: frameImageView.centerXAnchor),
            card.countCardLabel.widthAnchor.constraint(equalToConstant: 60),
            card.countCardLabel.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
}
