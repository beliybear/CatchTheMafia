//
//  ViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.03.2023.
//

import UIKit

class MainViewController: UIViewController {

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
    }

    private func addSubview(){
        view.addSubview(logoImage)
        view.addSubview(textLabel)
        view.addSubview(playButton)
    }

    private func setupVC(){
        view.backgroundColor = UIColor.mainBlack
        view.scalesLargeContentImage = true
        navigationItem.hidesBackButton = true
    }

    @objc private func toPlay(){
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

    func setupConstraints(){
        NSLayoutConstraint.activate([
            logoImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            logoImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            logoImage.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5),
            logoImage.heightAnchor.constraint(equalTo: logoImage.widthAnchor),
            
            textLabel.topAnchor.constraint(equalTo: logoImage.bottomAnchor, constant: 15),
            textLabel.heightAnchor.constraint(equalToConstant: 30),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            playButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            playButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            playButton.heightAnchor.constraint(equalToConstant: 80),
            playButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            
        ])
    }


}

