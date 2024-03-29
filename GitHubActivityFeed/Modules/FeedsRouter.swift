//
//  FeedsRouter.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Routable
import UIKit

protocol FeedsRouterFactory: AnyObject {
  func makeFeedsRouter() -> FeedsRouter
}

final class FeedsRouter: Router, Pathable {
  typealias Factory = FeedsListViewControllerFactory
    & GeneratedDetailsViewControllerFactory
    & FeedsListParameterParserFactory

  private weak var factory: Factory!
  private weak var navController: UINavigationController!
  private let parameterParser: ParameterParser

  init(factory: Factory) {
    self.factory = factory
    self.parameterParser = factory.makeParameterParserForFeedsList()
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
      let parsedParameters = self.parameterParser.parse(parameters: parameters)
      let viewController = self.factory.makeFeedsListViewController(router: self, parameters: parsedParameters)
      self.navController.pushViewController(viewController, animated: animated)
      return self
    }

    register(path: GeneratedDetailsViewController.path) { [unowned self] parameters, animated in
      let viewController = self.factory.makeGeneratedDetailsViewController(parameters: parameters)
      self.navController.pushViewController(viewController, animated: animated)
      return self
    }
  }
}

extension FeedsRouter: FeedDetailsRouter {
  func showDetails(with details: String) {
    let parameters = [GeneratedDetailsViewController.detailsKey: details]
    try? go(to: GeneratedDetailsViewController.path, parameters: parameters, animated: true)
  }
}
