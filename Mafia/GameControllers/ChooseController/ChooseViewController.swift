// PlayViewController.swift
// Mafia
//
// Created by Beliy.Bear on 10.03.2023.
//

import UIKit

class ChooseViewController: UIViewController {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.sizeToFit()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var doneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainWhite
        button.layer.cornerRadius = 25
        button.setTitle(NSLocalizedString("START", comment: ""), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
        button.addTarget(self, action: #selector(toGivingCard), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView(arrangedSubviews: cardViews)
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        
        view.addSubview(doneButton)
        scrollView.addSubview(mainButton)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            doneButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.widthAnchor.constraint(equalToConstant: 280),
            
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 100),
            stackView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -80),
        ])
        
        cardViews.forEach { cardView in
            cardView.widthAnchor.constraint(equalToConstant: 320).isActive = true
            cardView.heightAnchor.constraint(equalToConstant: 390).isActive = true
        }
        
        setupVC()
        
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
        self.navigationController?.navigationBar.isHidden = true
    }
    
    let cards = [
        Card(word: NSLocalizedString("MAFIA", comment: ""), avatar: UIImage(named: "mafia")!, countCard: 0),
        Card(word: NSLocalizedString("CIVILIAN", comment: ""), avatar: UIImage(named: "civilian")!, countCard: 0),
        Card(word: NSLocalizedString("SHERIFF", comment: ""), avatar: UIImage(named: "police")!, countCard: 0),
        Card(word: NSLocalizedString("DOCTOR", comment: ""), avatar: UIImage(named: "doctor")!, countCard: 0),
        Card(word: NSLocalizedString("HOOKER", comment: ""), avatar: UIImage(named: "hooker")!, countCard: 0),
        Card(word: NSLocalizedString("SPEAKER", comment: ""), avatar: UIImage(named: "Speaker")!, countCard: 0)
    ]
    
    lazy var cardViews: [CardView] = {
        cards.map { CardView(card: $0) }
    }()
    
    @objc private func toMain(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    @objc func toGivingCard() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()

        let totalCardCount = cards.reduce(0, { $0 + $1.countCard })
        if totalCardCount > 2 {
            let swipeCardVC = SwipeCardViewController()
            swipeCardVC.cards = cards
            self.navigationController?.pushViewController(swipeCardVC, animated: true)
        } else {
            let title = NSLocalizedString("Not enough cards", comment: "")
            let message = NSLocalizedString("You need at least 3 cards to start the game", comment: "")
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okTitle = NSLocalizedString("OK", comment: "OK button title")
            let okAction = UIAlertAction(title: okTitle, style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
    }


    
    
}
