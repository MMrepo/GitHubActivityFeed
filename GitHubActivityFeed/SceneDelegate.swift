//
//  SceneDelegate.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var dependecyContainer: DependencyContainer!

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    
    dependecyContainer = DependencyContainer()
    let app = dependecyContainer.makeApplication()
    window.rootViewController = app

    self.window = window
    
    try! app.go(to: FeedsRouter.path).go(to: FeedsListViewController.path)
    window.makeKeyAndVisible()
  }
}
