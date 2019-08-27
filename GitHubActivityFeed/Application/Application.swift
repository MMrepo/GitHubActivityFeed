//
//  Application.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation
import Routable
import UIKit

protocol ApplicationFactory {
  func makeApplication() -> Application
}

final class Application: Router {
  typealias Factory = DependencyContainer
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
  }
}
