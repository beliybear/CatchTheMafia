import UIKit

class TermsViewController: UIViewController {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toSettings), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    private lazy var termsTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = UIColor.mainWhite
        textView.backgroundColor = UIColor.clear
        textView.isEditable = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.text = """
        \(NSLocalizedString("Terms and Conditions", comment: "Terms and conditions title")):

        1. \(NSLocalizedString("You must be at least 18 years old to use this application.", comment: "Age requirement"))
        2. \(NSLocalizedString("Respect other players and their right to participate in the game.", comment: "Respect for other players"))
        3. \(NSLocalizedString("Cheating or any other forms of fraud are prohibited.", comment: "Cheating policy"))
        4. \(NSLocalizedString("We reserve the right to modify these terms at any time.", comment: "Modification rights"))
        5. \(NSLocalizedString("By using this application, you agree to these terms.", comment: "Agreement to terms"))
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
        view.addSubview(termsTextView)
    }
    
    private func setupConstraints() {
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            termsTextView.topAnchor.constraint(equalTo: mainButton.bottomAnchor, constant: 20),
            termsTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            termsTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            termsTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func toSettings() {
        self.navigationController?.popViewController(animated: true)
    }
}
