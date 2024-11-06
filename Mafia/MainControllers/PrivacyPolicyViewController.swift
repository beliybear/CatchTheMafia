//
//  PrivacyPolicyViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 06.11.2024.
//

import UIKit

class PrivacyPolicyViewController: UIViewController {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toSettings), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    private lazy var privacyTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.mainWhite
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = """
        \(NSLocalizedString("Privacy Policy", comment: "Privacy policy title")):

        1. \(NSLocalizedString("We respect your privacy and are committed to protecting your personal data.", comment: "Privacy commitment"))
        2. \(NSLocalizedString("The data collected is used solely to improve the quality of the services provided.", comment: "Data usage purpose"))
        3. \(NSLocalizedString("We will not share your data with third parties without your consent.", comment: "Data sharing policy"))
        4. \(NSLocalizedString("You have the right to request information about your data and demand its deletion.", comment: "Data access and deletion rights"))
        5. \(NSLocalizedString("By using this application, you agree to our privacy policy.", comment: "Agreement to privacy policy"))
        """
        return textView
    }()

    
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
        view.addSubview(privacyTextView)
    }
    
    private func setupConstraints() {
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            privacyTextView.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 20),
            privacyTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            privacyTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            privacyTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func toSettings() {
        self.navigationController?.popViewController(animated: true)
    }
}
