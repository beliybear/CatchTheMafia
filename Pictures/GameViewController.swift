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
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    private lazy var textLabel: UILabel = {
        let mainText = UILabel()
        mainText.text = "CATCH THE MAFIA"
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

    // CONSTRAINTS
    
    func setupConstraints() {
        view.addSubview(scrollView)
        scrollView.addSubview(timeLabel)
        scrollView.addSubview(textLabel)
        NSLayoutConstraint.activate([

            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
             scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
             scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
             scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            
             timeLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
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

