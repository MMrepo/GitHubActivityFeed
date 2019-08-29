//
//  DependencyContainer.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation
import Routable

final class DependencyContainer {
  private let shouldUseMockedProviders: Bool
  init(shouldUseMockedProviders: Bool) {
    self.shouldUseMockedProviders = shouldUseMockedProviders
  }
}

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
  func makeFeedsListViewController(router: FeedDetailsRouter, parameters: Parameters?) -> FeedsListViewController {
    return FeedsListViewController(factory: self, router: router, parameters: parameters)
  }
}

extension DependencyContainer: FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider {
    return shouldUseMockedProviders ? MockedFeedsProvider() : GithubFeedsProvider()
  }
}

extension DependencyContainer: FeedsControllerFactory {
  func makeFeedsController() -> FeedsController {
    return FeedsController(factory: self)
  }
}

extension DependencyContainer: GeneratedDetailsViewControllerFactory {
  func makeGeneratedDetailsViewController(parameters: Parameters?) -> GeneratedDetailsViewController {
    return GeneratedDetailsViewController(parameters: parameters)
  }
}

extension DependencyContainer: FeedsListParameterParserFactory {
  func makeParameterParserForFeedsList() -> ParameterParser {
    return FeedsListParameterParser()
  }
}
