//
//  Application.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Routable
import UIKit

protocol ApplicationFactory {
  func makeApplication() -> Application
}

final class Application: Router {
  typealias Factory = FeedsRouterFactory
  private weak var factory: Factory!

  init(factory: Factory) {
    self.factory = factory
    super.init(nibName: nil, bundle: nil)
    registerPaths()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension Application {
  func registerPaths() {
    register(path: FeedsRouter.path) { [unowned self] _, _ in
      let router = self.factory.makeFeedsRouter()
      self.add(childController: router)
      return router
    }
  }
}
