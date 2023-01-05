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
        // root
        window.makeKeyAndVisible()
        self.window = window
    }
}
