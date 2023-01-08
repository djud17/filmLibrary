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
        
        let tabBarController = createTabController()
        let startScreen = createStartTab()
        tabBarController.viewControllers = [startScreen]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func createStartTab() -> UIViewController {
        let router = PopularMoviesRouter()
        let popularMoviesPresenter = PopularMoviesPresenter(apiClient: ServiceCoordinator.apiClient, router: router)
        let popularMoviesVC = PopularMoviesViewController(presenter: popularMoviesPresenter)
        let popularMoviesController = UINavigationController(rootViewController: popularMoviesVC)
        popularMoviesController.setupControllerStyle()
        
        let mainScreenTabBarItem = UITabBarItem(title: "Top-50",
                                                image: UIImage(systemName: "popcorn"),
                                                selectedImage: UIImage(systemName: "popcorn.fill"))
        popularMoviesController.tabBarItem = mainScreenTabBarItem
        router.navigationController = popularMoviesController
        
        return popularMoviesController
    }
    
    private func createTabController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Constants.Color.orange
        tabBarController.tabBar.backgroundColor = Constants.Color.white.withAlphaComponent(0.5)
        
        return tabBarController
    }
}

extension UINavigationController {
    func setupControllerStyle() {
        self.navigationBar.prefersLargeTitles = true
        self.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.white
        ]
        self.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Constants.Color.orange
        ]
        self.navigationBar.tintColor = Constants.Color.white
    }
}
