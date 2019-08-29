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
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let window = UIWindow(windowScene: windowScene)
    self.window = window

    let shouldUseMockedProviders = CommandLine.arguments.contains("-t")
    let startPath = CommandLine.option(for: "-s")?.valueArgument ?? "/FeedsRouter/FeedsListViewController"
    let startPathURL = URL(string: startPath)!
    restartAppWith(window: window, startPath: startPathURL, shouldUseMockedProviders: shouldUseMockedProviders)
    window.makeKeyAndVisible()
  }
}

private extension SceneDelegate {
  @discardableResult func open(url: URL, from startingRouter: Routable) throws -> Routable {
    // Important: `dropFirst` is added to ommit `/`. As app always starts with `Application` router.
    return try url.pathComponents.dropFirst().reduce(startingRouter) { (router: Routable, component) -> Routable in
      try router.go(to: component, parameters: url.queryParameters, animated: false)
    }
  }

  func restartAppWith(window: UIWindow, startPath: URL, shouldUseMockedProviders: Bool) {
    dependecyContainer = DependencyContainer(shouldUseMockedProviders: shouldUseMockedProviders)
    let app = dependecyContainer.makeApplication()
    window.rootViewController = app

    do {
      try open(url: startPath, from: app)
    } catch RoutableError.pathNotFound(let path) {
      print("Couldn't go to the `\(path)`. Path not found!")
    } catch {
      print("Other error: \(error)")
    }
  }
}

private extension URL {
  var queryParameters: [String: String]? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let queryItems = components.queryItems else { return nil }
    return queryItems.reduce(into: [String: String]()) { result, item in
      result[item.name] = item.value
    }
  }
}
