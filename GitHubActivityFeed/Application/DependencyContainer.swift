//
//  DependencyContainer.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation
import Routable

final class DependencyContainer {}

// MARK: ApplicationFactory
extension DependencyContainer: ApplicationFactory {
  func makeApplication() -> Application {
    return Application(factory: self)
  }
}

extension DependencyContainer: FeedsRouterFactory {
  func makeFeedsRouter() -> FeedsRouter {
    return FeedsRouter(factory: self)
  }
}

extension DependencyContainer: FeedsListViewBuilderFactory {
  func makeFeedsListScreenBuilder() -> FeedsListScreenBuilder {
    return FeedsListScreenBuilder()
  }
}

extension DependencyContainer: FeedsListViewControllerFactory {
  func makeFeedsListViewController(parameters: Parameters?) -> FeedsListViewController {
    return FeedsListViewController(factory: self, parameters: parameters)
  }
}
