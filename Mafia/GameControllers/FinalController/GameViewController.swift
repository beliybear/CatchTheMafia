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
    private var timeElapsed: Int = 0
    private let timeLabel = UILabel()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        return button
    }()

    private lazy var textLabel: UILabel = {
        let mainText = UILabel()
        mainText.text = NSLocalizedString("Let's play!", comment: "")
        mainText.textAlignment = .center
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
        startTimer()
    }
    
    private func setupTimeLabel() {
        timeLabel.textAlignment = .center
        timeLabel.text = "0:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = .mainWhite
        timeLabel.font = .systemFont(ofSize: 60)
    }
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeElapsed += 1
            self.updateTimeLabel()
        }
    }
    
    private func updateTimeLabel() {
        let minutes = timeElapsed / 60
        let seconds = timeElapsed % 60
        timeLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
    }
    
    @objc private func toMain(){
        if isReady(){
            let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
            feedbackGenerator.prepare()
            feedbackGenerator.impactOccurred()
            self.navigationController?.pushViewController(MainViewController(), animated: true)
        }
    }
    
    func isReady() -> Bool {
        
        return true
    }
    
    func showAlert(){
        
    }

    // CONSTRAINTS
    
    func setupConstraints() {
        view.addSubview(timeLabel)
        view.addSubview(textLabel)
        view.addSubview(mainButton)
        NSLayoutConstraint.activate([
            
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            
             timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
             timeLabel.heightAnchor.constraint(equalToConstant: 250),
             timeLabel.widthAnchor.constraint(equalToConstant: 250),
            
            textLabel.heightAnchor.constraint(equalToConstant: 50),
             textLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 30),
             textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
             textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
}

