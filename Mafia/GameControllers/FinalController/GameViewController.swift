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
    private var isTimerRunning = false
    private var timeRemaining = 60
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
        return button
    }()
    
    private lazy var infoButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "quest"), for: .normal)
        button.addTarget(self, action: #selector(showCardList), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var startTimerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "playButton"), for: .normal)
        button.addTarget(self, action: #selector(toggleTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var resetTimerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "resetButton"), for: .normal)
        button.addTarget(self, action: #selector(resetTime), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
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
    
    private lazy var musicToggleButton: UIButton = {
        let button = UIButton()
        let isPlaying = UserDefaults.standard.bool(forKey: "musicState")
        button.setImage(UIImage(named: isPlaying ? "VolumeOn" : "VolumeOff"), for: .normal)
        button.addTarget(self, action: #selector(toggleMusic), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        // Добавляем кнопку для управления музыкой в иерархию представлений
        view.addSubview(musicToggleButton)
    }
    
    private func setupTimeLabel() {
        timeLabel.textAlignment = .center
        timeLabel.text = "1:00"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLabel.textColor = UIColor.mainWhite
        timeLabel.font = .systemFont(ofSize: 60)
    }
    
    @objc private func showCardList() {
        let alertController = UIAlertController(
            title: NSLocalizedString("Select the player you are interested in", comment: ""),
            message: nil,
            preferredStyle: .alert
        )
        
        for i in 1..<cardCount + 1 {
            let action = UIAlertAction(title: String(format: NSLocalizedString("Player #%@", comment: ""), "\(i)"), style: .default) { _ in
                self.cardSelectionDelegate?.showSelectedCardAlert(cardNumber: i)
            }
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }

    
    @objc private func toggleTimer() {
        if isTimerRunning {
            pauseTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.timeRemaining -= 1
            self.updateTimeLabel(self.timeRemaining)
            
            if self.timeRemaining <= 0 {
                self.timer?.invalidate()
                self.isTimerRunning = false
            }
        }
        
        isTimerRunning = true
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        isTimerRunning = false
    }
    
    @objc private func resetTime() {
        timer?.invalidate()
        timeRemaining = 60
        updateTimeLabel(timeRemaining)
        isTimerRunning = false
    }
    
    private func updateTimeLabel(_ timeRemaining: Int) {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        timeLabel.text = String(format: "%d:%02d", minutes, seconds)
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
    }
    
    @objc private func toggleMusic() {
        if let player = AudioManager.shared.audioPlayer {
            if player.isPlaying {
                AudioManager.shared.stopAudio()
                musicToggleButton.setImage(UIImage(named: "VolumeOff"), for: .normal)
            } else {
                AudioManager.shared.playAudio()
                musicToggleButton.setImage(UIImage(named: "VolumeOn"), for: .normal)
            }
            NotificationCenter.default.post(name: Notification.Name("AudioStateChange"), object: nil)
        }
    }
    
    @objc private func toMain() {
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
        view.addSubview(startTimerButton)
        view.addSubview(resetTimerButton)
        view.addSubview(infoButton)
        view.addSubview(musicToggleButton) // Добавляем кнопку для управления музыкой

        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            infoButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            infoButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            musicToggleButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            musicToggleButton.trailingAnchor.constraint(equalTo: infoButton.leadingAnchor, constant: -10), // Расстояние между кнопками
            
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30),
            timeLabel.heightAnchor.constraint(equalToConstant: 100),
            timeLabel.widthAnchor.constraint(equalToConstant: 250),
            
            textLabel.heightAnchor.constraint(equalToConstant: 50),
            textLabel.topAnchor.constraint(equalTo: resetTimerButton.bottomAnchor, constant: 30),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            startTimerButton.heightAnchor.constraint(equalToConstant: 60),
            startTimerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            startTimerButton.leadingAnchor.constraint(equalTo: timeLabel.leadingAnchor, constant: 45),
            
            resetTimerButton.heightAnchor.constraint(equalToConstant: 60),
            resetTimerButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            resetTimerButton.trailingAnchor.constraint(equalTo: timeLabel.trailingAnchor, constant: -45),
        ])
    }
}
