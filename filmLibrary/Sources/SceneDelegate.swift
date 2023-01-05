//
//  SceneDelegate.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = UITabBarController()
        
        let navigationController = UINavigationController(rootViewController: MainScreenViewController())
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.white
        ]
        navigationController.navigationBar.tintColor = Constants.Color.white
        
        let mainScreen = navigationController
        let mainScreenTabBarItem = UITabBarItem(title: "Main",
                                                image: UIImage(systemName: "film.stack"),
                                                selectedImage: UIImage(systemName: "film.stack.fill"))
        mainScreen.tabBarItem = mainScreenTabBarItem
        
        tabBarController.tabBar.tintColor = Constants.Color.blue
        tabBarController.tabBar.backgroundColor = Constants.Color.white.withAlphaComponent(0.5)
        tabBarController.viewControllers = [mainScreen]
        
        window.rootViewController = tabBarController
        
        window.makeKeyAndVisible()
        self.window = window
    }
}
