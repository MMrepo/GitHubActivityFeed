//
//  FeedsController.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine
import Foundation

protocol FeedsControllerFactory {
  func makeFeedsController() -> FeedsController
}

class FeedsController {
  typealias Factory = FeedsProviderFactory
  private let provider: FeedsProvider
  private var cachedFeeds: [Feed] = []

  init(factory: Factory) {
    self.provider = factory.makeFeedsProvider()
  }
}

// MARK: API
extension FeedsController {
  func getFeeds() -> AnyPublisher<[Feed], FeedsProviderError> {
    provider.getFeeds()
      .tryMap {
        try $0.data.decoded() as [Feed]
      }
      .cache { [unowned self] in self.cachedFeeds += $0 }
      .mapError {
        if $0 is DecodingError {
          return FeedsProviderError.decodingFailed($0)
        } else if let error = $0 as? FeedsProviderError {
          return error
        } else {
          return FeedsProviderError.undefined
        }
      }.eraseToAnyPublisher()
  }

  func getFilteredFeedsBy(type: String) -> AnyPublisher<[Feed], FeedsProviderError> {
    Just(cachedFeeds.filter { $0.type.lowercased().contains(type.lowercased()) })
      .setFailureType(to: FeedsProviderError.self)
      .eraseToAnyPublisher()
  }
}
