//
//  GithubFeedsProvider.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Codextended
import Combine
import Foundation

class GithubFeedsProvider: FeedsProvider {
  private var cachedFeeds: [Feed] = []

  func getFeeds() -> AnyPublisher<[Feed], FeedsProviderError> {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil

    let session = URLSession(configuration: config)

    let url = URL(string: "https://api.github.com/events")!
    return session.dataTaskPublisher(for: url).eraseToAnyPublisher()
      .tryMap { [unowned self] in
        let newFeeds = try $0.data.decoded() as [Feed]
        self.cachedFeeds += newFeeds
        return newFeeds
      }
      .mapError {
        if $0 is DecodingError {
          return FeedsProviderError.decodingFailed($0)
        } else if $0 is URLError {
          return FeedsProviderError.requestFailed($0)
        } else {
          return FeedsProviderError.undefined
        }
      }.eraseToAnyPublisher()
  }

  func getFilteredFeedsBy(type: String) -> AnyPublisher<[Feed], FeedsProviderError> {
    return Just(cachedFeeds.filter { $0.type.lowercased().contains(type.lowercased()) })
      .setFailureType(to: FeedsProviderError.self)
      .eraseToAnyPublisher()
  }
}
