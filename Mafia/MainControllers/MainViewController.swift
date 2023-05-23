//
//  ViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.03.2023.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {
    
    private lazy var audioPlayer = AVAudioPlayer()
    
    private lazy var audioButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "VolumeOn"), for: .normal)
        button.addTarget(self, action: #selector(toggleAudio), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.sizeToFit()
        return button
    }()
    
    private lazy var logoImage: UIImageView = {
        let logoImage = UIImageView()
        logoImage.image = UIImage (named: "AppIcon")
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        DispatchQueue.main.async {
            self.updateAudio()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateAudio()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        setupVC()
        addSubview()
        setupConstraints()
        setupAudioPlayer()
        
        updateAudio()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAudioState), name: Notification.Name("AudioStateChange"), object: nil)
    }
    
    private func setupAudioPlayer() {
        if let audioFilePath = Bundle.main.path(forResource: "mafiaSong", ofType: "mp3") {
            let audioFileUrl = URL(fileURLWithPath: audioFilePath)
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: audioFileUrl)
            } catch {
                print("Ошибка при создании аудиоплеера: \(error.localizedDescription)")
            }
        } else {
            print("Не удалось найти файл аудио")
        }
    }
    
    private func updateAudio(){
        let isPlaying = UserDefaults.standard.bool(forKey: "musicState")
        if isPlaying {
            playAudio()
        } else {
            stopAudio()
        }
    }
    
    @objc func updateAudioState() {
        DispatchQueue.main.async {
            self.updateAudio()
        }
    }
    
    func saveMusicState(isPlaying: Bool) {
        UserDefaults.standard.set(isPlaying, forKey: "musicState")
    }
    
    private func addSubview(){
        view.addSubview(logoImage)
        view.addSubview(textLabel)
        view.addSubview(playButton)
        view.addSubview(audioButton)
        view.addSubview(madeLabel)
    }
    
    private func setupVC(){
        view.backgroundColor = UIColor.mainBlack
        view.scalesLargeContentImage = true
        navigationItem.hidesBackButton = true
    }
    
    @objc private func toPlay(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(ChooseViewController(), animated: true)
    }
    
    @objc private func toSettings(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
    
    @objc private func toInfo(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(InfoViewController(), animated: true)
    }
    
    @objc private func toggleAudio() {
        if audioPlayer.isPlaying {
            stopAudio()
        } else {
            stopAudio()
            playAudio()
        }
        NotificationCenter.default.post(name: Notification.Name("AudioStateChange"), object: nil)
    }
    
    private func playAudio() {
        audioPlayer.play()
        audioButton.setImage(UIImage(named: "VolumeOn"), for: .normal)
        saveMusicState(isPlaying: true)
    }
    
    private func stopAudio() {
        audioPlayer.stop()
        audioPlayer.currentTime = 0 // добавьте эту строку
        audioButton.setImage(UIImage(named: "VolumeOff"), for: .normal)
        saveMusicState(isPlaying: false)
    }
    
    func setupConstraints(){
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
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
            madeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            madeLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -10)
            
        ])
    }
    
    
}

