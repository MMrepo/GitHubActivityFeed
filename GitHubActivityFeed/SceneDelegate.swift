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
//    let startPath = CommandLine.option(for: "-s")?.valueArgument ?? "/FeedsRouter/FeedsListViewController"

    // swiftlint:disable:next superfluous_disable_command line_length
    let startPath = "/FeedsRouter/FeedsListViewController?state=loaded&snapshot=%5B%7B%22id%22%3A%2210292486768%22%2C%22type%22%3A%22PushEvent%22%2C%22actor%22%3A%7B%22id%22%3A49118570%2C%22login%22%3A%22ClaireKi%22%2C%22display_login%22%3A%22ClaireKi%22%2C%22gravatar_id%22%3A%22%22%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Fusers%2FClaireKi%22%2C%22avatar_url%22%3A%22https%3A%2F%2Favatars.githubusercontent.com%2Fu%2F49118570%3F%22%7D%2C%22repo%22%3A%7B%22id%22%3A203605313%2C%22name%22%3A%22qwlake%2Fknu-festival%22%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%22%7D%2C%22payload%22%3A%7B%22push_id%22%3A3967590834%2C%22size%22%3A2%2C%22distinct_size%22%3A1%2C%22ref%22%3A%22refs%2Fheads%2Fmaster%22%2C%22head%22%3A%22e77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%2C%22before%22%3A%2262809b8f41741af053374a9acb3560738e55ef2f%22%2C%22commits%22%3A%5B%7B%22sha%22%3A%22103c478842522a4b574dc641275519282f182e67%22%2C%22author%22%3A%7B%22email%22%3A%22ksy201811677%40likelion.org%22%2C%22name%22%3A%22unknown%22%7D%2C%22message%22%3A%22feat+foodMap+img%22%2C%22distinct%22%3Afalse%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%2Fcommits%2F103c478842522a4b574dc641275519282f182e67%22%7D%2C%7B%22sha%22%3A%22e77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%2C%22author%22%3A%7B%22email%22%3A%2249118570%2BClaireKi%40users.noreply.github.com%22%2C%22name%22%3A%22ClaireKi%22%7D%2C%22message%22%3A%22Merge+pull+request+%2313+from+qwlake%2FseoYeon%5Cn%5Cnfeat+foodMap+img%22%2C%22distinct%22%3Atrue%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%2Fcommits%2Fe77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%7D%5D%7D%2C%22public%22%3Atrue%2C%22created_at%22%3A%222019-08-27T14%3A33%3A01Z%22%7D%5D"
    // swiftlint:enable:next superfluous_disable_command line_length

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
