import UIKit

class SwipeCardViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    private lazy var mainButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "cancel"), for: .normal)
        button.addTarget(self, action: #selector(toMain), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.sizeToFit()
        return button
    }()
    
    var cards: [Card] = []
    var finalCountCard: [String] = []
    var showCardCallback: ((Int) -> Void)?
    
    private var cardViewControllers: [UIViewController] = []
    
    private lazy var showButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .mainWhite
        button.layer.cornerRadius = 20
        button.setTitle(NSLocalizedString("PLAY", comment: ""), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont(name: "Inter-SemiBold", size: 30)
        button.addTarget(self, action: #selector(showButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isHidden = true
        return button
    }()
    
    private var logoImage = UIImageView(image: UIImage(named: "logoImage"))
    private var isOverlayTapped = false

    private lazy var swipeHintLabel: UILabel = {
        let label = UILabel()
        label.text = NSLocalizedString("Swipe to Switch", comment: "")
        label.textColor = .white
        label.font = UIFont(name: "Inter-SemiBold", size: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.alpha = 0 // Начальное значение прозрачности
        return label
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.delegate = self
        
        setupCards()
        setupUIComponents()
        setupSwipeHintLabel()
    }
    
    private func setupCards() {
        let filteredCards = cards.filter { $0.countCard > 0 }
        var allCards: [Card] = []
        
        filteredCards.forEach { card in
            allCards.append(contentsOf: Array(repeating: card, count: card.countCard))
        }
        
        let shuffledCards = allCards.shuffled()
        let newCardViews = shuffledCards.map { CardView(card: $0) }
        
        for view in self.view.subviews {
            if let scrollView = view as? UIScrollView {
                scrollView.isScrollEnabled = false
            }
        }
        
        cardViewControllers = newCardViews.map { cardView in
            let viewController = UIViewController()
            viewController.view.addSubview(cardView)
            viewController.view = cardView
            viewController.view.backgroundColor = .mainBlack
            finalCountCard.append(cardView.card.word)
            return viewController
        }
        
        if let firstCardViewController = cardViewControllers.first {
            setViewControllers([firstCardViewController], direction: .forward, animated: true, completion: nil)
            addConstraints(to: firstCardViewController)
        }
        
        for (index, cardView) in newCardViews.enumerated() {
            configureCardView(cardView, index: index + 1, totalCards: newCardViews.count)
        }
    }
    
    private func configureCardView(_ cardView: CardView, index: Int, totalCards: Int) {
        cardView.card.minusButton.isHidden = true
        cardView.card.plusButton.isHidden = true
        cardView.card.countCardLabel.isHidden = true
        cardView.frameImageView.isHidden = true
        cardView.backgroundColor = .mainBlack
        
        if cardView.card.word == NSLocalizedString("MAFIA", comment: "") {
            cardView.wordLabel.textColor = .red
        } else {
            cardView.wordLabel.textColor = .mainWhite
        }
        
        NSLayoutConstraint.activate([
            cardView.wordLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 20),
        ])
        
        let blackOverlay = UIView()
        blackOverlay.tag = 100
        
        let backgroundImage = UIImageView(image: logoImage.image)
        backgroundImage.contentMode = .scaleAspectFill
        backgroundImage.clipsToBounds = true
        blackOverlay.addSubview(backgroundImage)
        
        backgroundImage.translatesAutoresizingMaskIntoConstraints = false
        cardView.wordLabel.isHidden = true
        cardView.addSubview(blackOverlay)
        blackOverlay.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImage.topAnchor.constraint(equalTo: blackOverlay.topAnchor),
            backgroundImage.bottomAnchor.constraint(equalTo: blackOverlay.bottomAnchor),
            backgroundImage.leadingAnchor.constraint(equalTo: blackOverlay.leadingAnchor),
            backgroundImage.trailingAnchor.constraint(equalTo: blackOverlay.trailingAnchor),
            
            blackOverlay.topAnchor.constraint(equalTo: cardView.topAnchor),
            blackOverlay.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),
            blackOverlay.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
            blackOverlay.trailingAnchor.constraint(equalTo: cardView.trailingAnchor)
        ])
        
        // Инициализация label для счетчика
        let cardCounterLabel = UILabel()
        cardCounterLabel.textColor = .white
        cardCounterLabel.font = UIFont(name: "Inter-SemiBold", size: 20)
        cardCounterLabel.translatesAutoresizingMaskIntoConstraints = false
        blackOverlay.addSubview(cardCounterLabel)

        // Установка ограничений для счетчика
        NSLayoutConstraint.activate([
            cardCounterLabel.trailingAnchor.constraint(equalTo: blackOverlay.trailingAnchor, constant: -10),
            cardCounterLabel.topAnchor.constraint(equalTo: blackOverlay.topAnchor, constant: 10)
        ])

        // Обновляем текст счетчика
        cardCounterLabel.text = "\(index)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped(_:)))
        cardView.addGestureRecognizer(tapGesture)
    }
    
    private func setupUIComponents() {
        view.backgroundColor = .mainBlack
        view.addSubview(mainButton)
        setupMainButtonConstraints()
        
        view.addSubview(showButton)
        setupShowButtonConstraints()
    }
    
    private func setupMainButtonConstraints() {
        NSLayoutConstraint.activate([
            mainButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5),
            mainButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
        ])
    }
    
    private func setupShowButtonConstraints() {
        NSLayoutConstraint.activate([
            showButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -5),
            showButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            showButton.heightAnchor.constraint(equalToConstant: 60),
            showButton.widthAnchor.constraint(equalToConstant: 280),
        ])
    }
    
    private func setupSwipeHintLabel() {
        view.addSubview(swipeHintLabel)
        
        NSLayoutConstraint.activate([
            swipeHintLabel.bottomAnchor.constraint(equalTo: showButton.topAnchor, constant: -10),
            swipeHintLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
        ])
        
        UIView.animate(withDuration: 1.0) {
            self.swipeHintLabel.alpha = 1 // Показать надпись
        }
    }
    
    private func addConstraints(to viewController: UIViewController) {
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewController.view)
        
        NSLayoutConstraint.activate([
            viewController.view.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            viewController.view.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            viewController.view.widthAnchor.constraint(equalToConstant: 320),
            viewController.view.heightAnchor.constraint(equalToConstant: 390),
        ])
    }
    
    private func updateShowButton() {
        if isOverlayTapped {
            showButton.alpha = 1
            showButton.isEnabled = true
        } else {
            showButton.alpha = 0.5
            showButton.isEnabled = false
        }
    }
    
    @objc private func cardTapped(_ sender: UITapGestureRecognizer) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        if let cardView = sender.view as? CardView,
           let blackOverlay = cardView.viewWithTag(100) {
            
            let rotationAngle = CGFloat(Double.pi / 2)
            let rotationTransform = CATransform3DMakeRotation(rotationAngle, 0, 1, 0)
            let finalTransform = CATransform3DConcat(rotationTransform, CATransform3DIdentity)
            
            UIView.animate(withDuration: 0.5, animations: {
                blackOverlay.layer.transform = finalTransform
                blackOverlay.alpha = 0.5
            }, completion: { _ in
                blackOverlay.removeFromSuperview()
                cardView.wordLabel.isHidden = false
                self.isOverlayTapped = blackOverlay.superview == nil
                self.updateShowButton()
                
                if self.swipeHintLabel.alpha == 1 {
                    UIView.animate(withDuration: 0.5) {
                        self.swipeHintLabel.alpha = 0 // Скрыть надпись
                    }
                }
            })
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if isOverlayTapped {
            if let index = cardViewControllers.firstIndex(of: viewController) {
                if index < (cardViewControllers.count - 1) {
                    isOverlayTapped = false
                    updateShowButton()
                }
                
                if index < (cardViewControllers.count - 1) {
                    let nextVC = cardViewControllers[index + 1]
                    addConstraints(to: nextVC)
                    return nextVC
                }
            }
        }
        return nil
    }
    
    @objc private func toMain() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        self.navigationController?.pushViewController(MainViewController(), animated: true)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        if let nextViewController = pendingViewControllers.first,
           let targetIndex = cardViewControllers.firstIndex(of: nextViewController) {
            showButton.isHidden = targetIndex != cardViewControllers.count - 1
        }
    }
    
    @objc private func showButtonTapped() {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
        feedbackGenerator.prepare()
        feedbackGenerator.impactOccurred()
        
        let gameVC = GameViewController()
        gameVC.cardCount = cardViewControllers.count
        gameVC.cardSelectionDelegate = self
        self.navigationController?.pushViewController(gameVC, animated: true)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return cardViewControllers.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        if let currentViewController = viewControllers?.first,
           let currentIndex = cardViewControllers.firstIndex(of: currentViewController) {
            return currentIndex
        }
        return 0
    }
}

extension SwipeCardViewController: CardSelectionDelegate {
    
    func showSelectedCardAlert(cardNumber: Int) {
        guard cardNumber > 0 && cardNumber <= cardViewControllers.count else {
            print("Invalid card number")
            return
        }
        let alertController = UIAlertController(title: "Игрок №\(cardNumber)", message: "\(finalCountCard[cardNumber - 1])", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
}
