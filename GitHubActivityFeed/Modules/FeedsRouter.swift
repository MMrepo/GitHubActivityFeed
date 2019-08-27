//
//  FeedsRouter.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Routable
import UIKit

protocol FeedsRouterFactory {
  func makeFeedsRouter() -> FeedsRouter
}

final class FeedsRouter: Router, Pathable {
  typealias Factory = FeedsListViewControllerFactory
  private weak var factory: Factory!
  private weak var navController: UINavigationController!

  init(factory: Factory) {
    self.factory = factory
    let navController = UINavigationController()
    self.navController = navController

    super.init(nibName: nil, bundle: nil)
    add(childController: navController)

    registerPaths()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension FeedsRouter {
  func registerPaths() {
    register(path: FeedsListViewController.path) { [unowned self] parameters, animated in
      let viewController = self.factory.makeFeedsListViewController(parameters: parameters)
      self.navController.pushViewController(viewController, animated: animated)
      return self
    }
  }
}
