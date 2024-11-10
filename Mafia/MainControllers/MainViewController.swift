//
//  ViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.03.2023.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    private lazy var audioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "VolumeOff"), for: .normal)
        button.addTarget(self, action: #selector(toggleAudio), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage(named: "MostIcon")
        logoImage.translatesAutoresizingMaskIntoConstraints = false
        return logoImage
    }()
    
    private lazy var textLabel: UILabel = {
        let mainText = UILabel()
        mainText.text = NSLocalizedString("Catch The Mafia", comment: "")
        mainText.textAlignment = .center
        mainText.font = UIFont(name: "Inter-SemiBold", size: 30)
        mainText.textColor = UIColor.mainWhite
        mainText.translatesAutoresizingMaskIntoConstraints = false
        mainText.setContentCompressionResistancePriority(.required, for: .vertical)
        return mainText
    }()
    
    private lazy var madeLabel: UILabel = {
        let mainText = UILabel()
        mainText.text = NSLocalizedString("Made by BeliyBear", comment: "")
        mainText.textAlignment = .center
        mainText.layer.opacity = 0.1
        mainText.font = UIFont(name: "Inter-SemiBold", size: 30)
        mainText.textColor = UIColor.mainWhite
        mainText.translatesAutoresizingMaskIntoConstraints = false
        return mainText
    }()
    
    private lazy var playButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainWhite
        button.layer.cornerRadius = 40
        button.setTitle(NSLocalizedString("New Game", comment: ""), for: .normal)
        button.setTitleColor(UIColor.mainBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
        button.addTarget(self, action: #selector(toPlay), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var settingsButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.mainWhite
        button.layer.cornerRadius = 40
        button.setTitle(NSLocalizedString("Settings", comment: ""), for: .normal)
        button.setTitleColor(UIColor.mainBlack, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
        button.addTarget(self, action: #selector(toSettings), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupConstraints()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        addSubview()
        setupConstraints()
        
        // Обновляем состояние музыки
        AudioManager.shared.updateAudio()
        
        // Восстанавливаем состояние иконки
        let isPlaying = UserDefaults.standard.bool(forKey: "musicState")
        audioButton.setImage(UIImage(named: isPlaying ? "VolumeOn" : "VolumeOff"), for: .normal)
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateAudioState), name: Notification.Name("AudioStateChange"), object: nil)
    }
    
    @objc func updateAudioState() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        DispatchQueue.main.async {
            AudioManager.shared.updateAudio()
        }
    }
    
    @objc private func toggleAudio() {
        if let player = AudioManager.shared.audioPlayer {
            if player.isPlaying {
                AudioManager.shared.stopAudio()
                audioButton.setImage(UIImage(named: "VolumeOff"), for: .normal)
            } else {
                AudioManager.shared.playAudio()
                audioButton.setImage(UIImage(named: "VolumeOn"), for: .normal)
            }
            NotificationCenter.default.post(name: Notification.Name("AudioStateChange"), object: nil)
        }
    }

    
    private func addSubview() {
        view.addSubview(logoImage)
        view.addSubview(textLabel)
        view.addSubview(playButton)
        view.addSubview(settingsButton)
        view.addSubview(audioButton)
        view.addSubview(madeLabel)
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
        view.scalesLargeContentImage = true
        navigationItem.hidesBackButton = true
    }
    
    @objc private func toPlay() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(ChooseViewController(), animated: true)
    }
    
    @objc private func toSettings() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            audioButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            audioButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            textLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15),
            textLabel.heightAnchor.constraint(equalToConstant: 30),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.bottomAnchor.constraint(equalTo: settingsButton.topAnchor, constant: -20),
            
            settingsButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            settingsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            settingsButton.heightAnchor.constraint(equalToConstant: 80),
            settingsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            madeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            madeLabel.topAnchor.constraint(equalTo: settingsButton.bottomAnchor, constant: 10)
        ])
    }
}
