//
//  SceneDelegate.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Routable
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  private var dependecyContainer: DependencyContainer!

  func scene(_ scene: UIScene,
             willConnectTo session: UISceneSession,
             options connectionOptions: UIScene.ConnectionOptions) {
    // Don't start whole machinery when running Unit tests

    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window
    guard !CommandLine.arguments.contains("-ut") else {
      UIView.setAnimationsEnabled(false)
      window.makeKeyAndVisible()
      return
    }

    let shouldUseMockedProviders = CommandLine.arguments.contains("-uit")
    let startPath = CommandLine.option(for: "-s")?.valueArgument ?? "/FeedsRouter/FeedsListViewController?withAnimations=true&state=loading"

    let startPathURL = URL(string: startPath)!
    restartAppWith(window: window, startPath: startPathURL, shouldUseMockedProviders: shouldUseMockedProviders)
    window.makeKeyAndVisible()
  }
}

private extension SceneDelegate {
  func restartAppWith(window: UIWindow, startPath: URL, shouldUseMockedProviders: Bool) {
    dependecyContainer = DependencyContainer(shouldUseMockedProviders: shouldUseMockedProviders)
    let app = dependecyContainer.makeApplication()
    window.rootViewController = app

    do {
      try app.open(url: startPath)
    } catch RoutableError.pathNotFound(let path) {
      print("Couldn't go to the `\(path)`. Path not found!")
    } catch {
      print("Other error: \(error)")
    }
  }
}
