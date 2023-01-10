//
//  SceneDelegate.swift
//  filmLibrary
//
//  Created by Давид Тоноян  on 05.01.2023.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private let apiClient = ServiceCoordinator.apiClient
    
    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: windowScene)
        
        let tabBarController = createTabController()
        let startScreen = createPopularMoviesTab()
        let searchScreen = createSearchTab()
        let watchListScreen = createWatchListTab()
        
        tabBarController.viewControllers = [startScreen, searchScreen, watchListScreen]
        
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
        var popularMoviesRouter: RouterProtocol = PopularMoviesRouter()
        let popularMoviesPresenter: PopularMoviesPresenterProtocol = PopularMoviesPresenter(apiClient: apiClient,
                                                                                            router: popularMoviesRouter)
        let popularMoviesVC = PopularMoviesViewController(presenter: popularMoviesPresenter)
        let popularMoviesController = UINavigationController(rootViewController: popularMoviesVC)
        popularMoviesController.setupControllerStyle()
        
        let mainScreenTabBarItem = UITabBarItem(title: Constants.Tab.popularScreenTitle,
                                                image: UIImage(systemName: Constants.Tab.popularScreenTabImage),
                                                selectedImage: UIImage(systemName: Constants.Tab.popularSceenSelectedTabImage))
        popularMoviesController.tabBarItem = mainScreenTabBarItem
        popularMoviesRouter.navigationController = popularMoviesController
        
        return popularMoviesController
    }
    
    private func createSearchTab() -> UIViewController {
        var searchMoviesRouter: RouterProtocol = SearchMoviesRouter()
        let searchPresenter: SearchMoviesPresenterProtocol = SearchMoviesPresenter(apiClient: apiClient,
                                                                                   router: searchMoviesRouter)
        let searchMoviesVC = SearchMoviesViewController(presenter: searchPresenter)
        let searchMoviesController = UINavigationController(rootViewController: searchMoviesVC)
        searchMoviesController.setupControllerStyle()
        
        let searchScreenTabBarItem = UITabBarItem(title: Constants.Tab.searchScreenTitle,
                                                  image: UIImage(systemName: Constants.Tab.searchScreenTabImage),
                                                  selectedImage: UIImage(systemName: Constants.Tab.searchSceenSelectedTabImage))
        searchMoviesController.tabBarItem = searchScreenTabBarItem
        searchMoviesRouter.navigationController = searchMoviesController
        
        return searchMoviesController
    }
    
    private func createWatchListTab() -> UIViewController {
        var watchListRouter: RouterProtocol = WatchListRouter()
        let watchListPresenter: WatchListPresenterProtocol = WatchListPresenter(router: watchListRouter, apiClient: apiClient)
        let watchListVC = WatchListViewController(presenter: watchListPresenter)
        let watchListViewController = UINavigationController(rootViewController: watchListVC)
        watchListViewController.setupControllerStyle()
        
        let watchListTabBarItem = UITabBarItem(title: Constants.Tab.watchListScreenTitle,
                                               image: UIImage(systemName: Constants.Tab.watchListScreenTabImage),
                                               selectedImage: UIImage(systemName: Constants.Tab.watchListSceenSelectedTabImage))
        watchListViewController.tabBarItem = watchListTabBarItem
        watchListRouter.navigationController = watchListViewController
        
        return watchListViewController
    }
}
