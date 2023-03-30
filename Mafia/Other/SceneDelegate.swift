//
//  SceneDelegate.swift
//  Mafia
//
//  Created by Beliy.Bear on 10.03.2023.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        let vc = MainViewController()
        let navController = UINavigationController(rootViewController: vc)
        window?.rootViewController = navController
        
    }
}
