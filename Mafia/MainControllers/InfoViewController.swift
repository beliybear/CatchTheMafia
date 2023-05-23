//
//  InfoViewController.swift
//  Mafia
//
//  Created by Beliy.Bear on 15.03.2023.
//

import UIKit

class InfoViewController: UIViewController {
    
    let scrollView = UIScrollView()
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.sizeToFit()
        return button
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.isEditable = false
        tv.isSelectable = false
        tv.textColor = .white
        tv.backgroundColor = .mainBlack
        tv.font = UIFont.systemFont(ofSize: 25)
        tv.textColor = .mainWhite
        tv.text = NSLocalizedString("""
        # Catch The Mafia
        
        ## Overview
        Catch the Mafia is a social deduction game that involves players trying to figure out who among them are the
        "Mafia" while the Mafia try to eliminate the other players.
        
        ## Gameplay
        The game is played in rounds. Each round has two phases: the "night" phase and the "day" phase.
        
        ### Night Phase
        During the night phase, the Mafia choose a player to eliminate. The other players are "asleep" and do not participate in this phase.
        
        ### Day Phase
        During the day phase, all players wake up and discuss who they think is the Mafia. Players can make accusations, defend themselves, and vote on who they think should be eliminated. The player with the most votes is eliminated. If there is a tie, nobody is eliminated.
        The game continues until either all the Mafia are eliminated or the Mafia have eliminated all the other players.
        
        ## Roles
        In addition to the Catch the Mafia, there are other roles that can be played in the game, such as the Doctor (who can protect a player from being eliminated), the Detective (who can investigate a player to see if they are Mafia), and the Civilians (who have no special abilities).
        
        ## Conclusion
        Catch the Mafia is a fun and engaging game that is perfect for groups of friends or family. It requires strategy, teamwork, and a bit of deception to win. So gather some friends, and see if you can figure out who among you is the Mafia!
        """, comment: "")
        return tv
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
        addSubviews()
        setupConstraints()
    }
    
    private func setupVC() {
        view.backgroundColor = UIColor.mainBlack
        navigationItem.hidesBackButton = true
    }
    
    private func addSubviews(){
        view.addSubview(scrollView)
        scrollView.addSubview(textView)
        scrollView.addSubview(mainButton)
    }
    
    private func setupConstraints(){
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        mainButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            
            textView.topAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leadingAnchor),
            textView.trailingAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
    
    @objc private func toMain(){
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
}
