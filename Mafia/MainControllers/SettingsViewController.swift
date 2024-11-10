//
//  SettingsViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 15.03.2023.
//

import UIKit
import UserNotifications

class SettingsViewController: UIViewController {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var notificationsLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Enable Notifications", comment: "")
        label.textColor = UIColor.mainWhite
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var notificationsSwitch: UISwitch = {
        let switchControl = UISwitch()
        switchControl.isOn = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        switchControl.addTarget(self, action: #selector(toggleNotifications), for: .valueChanged)
        switchControl.translatesAutoresizingMaskIntoConstraints = false
        return switchControl
    }()
    
    private lazy var privacyButton: UIButton = {
        let button = UIButton()
        button.setTitle(NSLocalizedString("Privacy Policy", comment: ""), for: .normal)
        button.setTitleColor(UIColor.mainWhite, for: .normal)
        button.setTitleColor(UIColor.gray, for: .highlighted) // Цвет при нажатии
        button.addTarget(self, action: #selector(showPrivacyPolicy), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16) // Увеличение шрифта для кнопки
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
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
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
        navigationItem.hidesBackButton = true
    }
    
    private func addSubview() {
        view.addSubview(mainButton)
        view.addSubview(notificationsLabel)
        view.addSubview(notificationsSwitch)
        view.addSubview(privacyButton) // Добавление кнопки политики конфиденциальности
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            notificationsLabel.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 40),
            notificationsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            notificationsSwitch.centerYAnchor.constraint(equalTo: notificationsLabel.centerYAnchor),
            notificationsSwitch.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            privacyButton.topAnchor.constraint(equalTo: notificationsLabel.bottomAnchor, constant: 40),
            privacyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            privacyButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    @objc private func toMain() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func showPrivacyPolicy() {
        let privacyURL: String
        let language = Locale.current.languageCode

        if language == "ru" {
            privacyURL = "https://docs.google.com/document/d/e/2PACX-1vSCnMTsGh1O33LC1n17krBINrw-lle00HNEODGwFiE3DOnhoL7br_aFyw-PYo4elENKtnHEFetTT4RE/pub"
        } else {
            privacyURL = "https://docs.google.com/document/d/e/2PACX-1vT2_FILw74ZMAFazG9-czQhsoruDE2vJiMrxyYrwixcxA3I_r-bdio_Y9njsOsJRQQxCGcrlRMWJM7c/pub"
        }

        if let url = URL(string: privacyURL) {
            UIApplication.shared.open(url)
        }
    }
    
    @objc private func toggleNotifications(_ sender: UISwitch) {
        if sender.isOn {
            requestNotificationPermission()
        } else {
            // Если уведомления отключаются, спрашиваем пользователя
            showNotificationPrompt()
        }
    }
    
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            DispatchQueue.main.async {
                if granted {
                    UserDefaults.standard.set(true, forKey: "notificationsEnabled")
                    self.notificationsSwitch.setOn(true, animated: true)
                } else {
                    self.notificationsSwitch.setOn(false, animated: true)
                    UserDefaults.standard.set(false, forKey: "notificationsEnabled")
                    self.showNotificationAlert()
                }
            }
        }
    }
    
    private func showNotificationPrompt() {
        let alert = UIAlertController(title: NSLocalizedString("Notifications", comment: "Title for notifications prompt"),
                                      message: NSLocalizedString("Do you want to enable notifications for updates and important alerts?", comment: "Message asking to enable notifications"),
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Enable", comment: "Button to enable notifications"), style: .default, handler: { _ in
            self.notificationsSwitch.setOn(true, animated: true)
            self.requestNotificationPermission()
        }))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Disable", comment: "Button to disable notifications"), style: .cancel, handler: { _ in
            self.notificationsSwitch.setOn(false, animated: true)
            UserDefaults.standard.set(false, forKey: "notificationsEnabled")
        }))
        
        present(alert, animated: true, completion: nil)
    }

    private func showNotificationAlert() {
        let alert = UIAlertController(title: NSLocalizedString("Error", comment: "Title for error alert"),
                                      message: NSLocalizedString("Notification permission not granted. Please enable it in the app settings.", comment: "Message when notification permission is not granted"),
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
