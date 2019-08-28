//
//  FeedsProvider.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine

enum FeedsProviderError: Error {
  case undefined
  case decodingFailed(Error)
  case requestFailed(Error)
}

protocol FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider
}

protocol FeedsProvider {
  func getFeeds() -> AnyPublisher<[Feed], FeedsProviderError>
  func getFilteredFeedsBy(type: String) -> AnyPublisher<[Feed], FeedsProviderError>
}
