//
//  PlayViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.03.2023.
//

import UIKit

class ChooseViewController: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView(arrangedSubviews: cardViews)
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 200)
        ])

        cardViews.forEach { cardView in
            cardView.widthAnchor.constraint(equalToConstant: 200).isActive = true
            cardView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        }
        
        setupVC()
    }
    
    private func setupVC(){
        view.backgroundColor = UIColor.mainBlack
    }
    
    let cards = [
        Card(word: "MAFIA", avatar: UIImage()),
        Card(word: "POLICE", avatar: UIImage()),
        Card(word: "DOCTOR", avatar: UIImage()),
    ]
    
    lazy var cardViews: [CardView] = {
        cards.map { CardView(card: $0) }
    }()
    
}
    
