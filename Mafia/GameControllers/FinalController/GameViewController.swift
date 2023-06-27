//
//  GameViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 24.03.2023.
//

import UIKit

class GameViewController: UIViewController {
    
    // VAR
    private var timer: Timer?
    private let timeLabel = UILabel()
    var cardCount = 0
    var swipeVC = SwipeCardViewController()
    var showSelectedCardNumber: ((Int) -> Void)?
    weak var cardSelectionDelegate: CardSelectionDelegate?
    var cardViewControllers: [UIViewController] = []
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "quest"), for: .normal)
        button.addTarget(self, action: #selector(showCardList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()
    
    private lazy var startTimer: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.addTarget(self, action: #selector(startTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var resetTimer: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "resetButton"), for: .normal)
        button.addTarget(self, action: #selector(resetTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var textLabel: UILabel = {
        let mainText = UILabel()
        mainText.text = NSLocalizedString("Made by BeliyBear", comment: "")
        mainText.textAlignment = .center
        mainText.layer.opacity = 0.1
        mainText.font = UIFont(name: "Inter-SemiBold", size: 30)
        mainText.textColor = UIColor.mainWhite
        mainText.translatesAutoresizingMaskIntoConstraints = false
        return mainText
    }()
    
    // FUNC
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTimeLabel()
        setupVC()
        setupConstraints()
        
        showSelectedCardNumber = { [weak self] cardNumber in
            self?.showSelectedCardNumber?(cardNumber)
        }
    }
    
    private func setupTimeLabel() {
        timeLabel.textAlignment = .center
        timeLabel.text = "1:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .mainWhite
        timeLabel.font = .systemFont(ofSize: 60)
    }
    
    @objc private func showCardList() {
        let alertController = UIAlertController(title: "Выберите интересующего вас игрока", message: nil, preferredStyle: .alert)
        
        for i in 1..<cardCount+1 {
            let action = UIAlertAction(title: "Игрок №\(i)", style: .default) { _ in
                self.cardSelectionDelegate?.showSelectedCardAlert(cardNumber: i)
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func startTime() {
        timer?.invalidate()
        
        var timeRemaining = 60
        updateTimeLabel(timeRemaining)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            timeRemaining -= 1
            self.updateTimeLabel(timeRemaining)
            
            if timeRemaining == 0 {
                self.timer?.invalidate()
            }
        }
    }
    
    @objc private func resetTime(){
        timer?.invalidate()
        timeLabel.text = "1:00"
    }
    
    private func updateTimeLabel(_ timeRemaining: Int) {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timeLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
    }
    
    @objc private func toMain(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    // CONSTRAINTS
    
    func setupConstraints() {
        view.addSubview(timeLabel)
        view.addSubview(textLabel)
        view.addSubview(mainButton)
        view.addSubview(startTimer)
        view.addSubview(resetTimer)
        view.addSubview(infoButton)
        NSLayoutConstraint.activate([
            
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            infoButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -55),
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            timeLabel.heightAnchor.constraint(equalToConstant: 100),
            timeLabel.widthAnchor.constraint(equalToConstant: 250),
            
            textLabel.heightAnchor.constraint(equalToConstant: 50),
            textLabel.topAnchor.constraint(equalTo: resetTimer.bottomAnchor, constant: 30),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            startTimer.heightAnchor.constraint(equalToConstant: 60),
            startTimer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            startTimer.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 45),
            
            resetTimer.heightAnchor.constraint(equalToConstant: 60),
            resetTimer.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            resetTimer.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: -45),
        ])
    }
}
