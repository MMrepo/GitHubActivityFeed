//
//  FeedsProvider.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine
import Foundation

enum FeedsProviderError: Error {
  case undefined
  case decodingFailed(Error)
  case requestFailed(Error)
  case serverError(statusCode: Int)
}

protocol FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider
}

protocol FeedsProvider {
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error>
}
