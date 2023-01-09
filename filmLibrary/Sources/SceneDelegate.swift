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
        let startScreen = createPopularMoviesTab()
        let searchScreen = createSearchTab()
        
        tabBarController.viewControllers = [startScreen, searchScreen]
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        
        self.window = window
    }

    private func createTabController() -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.tabBar.tintColor = Constants.Color.orange
        tabBarController.tabBar.backgroundColor = Constants.Color.white.withAlphaComponent(0.5)
        
        return tabBarController
    }
    
    private func createPopularMoviesTab() -> UIViewController {
        let router = PopularMoviesRouter()
        let popularMoviesPresenter = PopularMoviesPresenter(apiClient: ServiceCoordinator.apiClient, router: router)
        let popularMoviesVC = PopularMoviesViewController(presenter: popularMoviesPresenter)
        let popularMoviesController = UINavigationController(rootViewController: popularMoviesVC)
        popularMoviesController.setupControllerStyle()
        
        let mainScreenTabBarItem = UITabBarItem(title: Constants.Tab.popularScreenTitle,
                                                image: UIImage(systemName: Constants.Tab.popularScreenTabImage),
                                                selectedImage: UIImage(systemName: Constants.Tab.popularSceenSelectedTabImage))
        popularMoviesController.tabBarItem = mainScreenTabBarItem
        router.navigationController = popularMoviesController
        
        return popularMoviesController
    }
    
    private func createSearchTab() -> UIViewController {
        let router = SearchMoviesRouter()
        let searchPresenter = SearchMoviesPresenter(apiClient: ServiceCoordinator.apiClient, router: router)
        let searchMoviesVC = SearchMoviesViewController(presenter: searchPresenter)
        let searchMoviesController = UINavigationController(rootViewController: searchMoviesVC)
        searchMoviesController.setupControllerStyle()
        
        let searchScreenTabBarItem = UITabBarItem(title: Constants.Tab.searchScreenTitle,
                                                  image: UIImage(systemName: Constants.Tab.searchScreenTabImage),
                                                  selectedImage: UIImage(systemName: Constants.Tab.searchSceenSelectedTabImage))
        searchMoviesController.tabBarItem = searchScreenTabBarItem
        router.navigationController = searchMoviesController
        
        return searchMoviesController
    }
}
