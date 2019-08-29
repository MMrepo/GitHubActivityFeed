//
//  OneFeedProvider.swift
//  GitHubActivityFeedTests
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine
import Foundation
@testable import GitHubActivityFeed

fileprivate extension FeedsProvider {
  func getFeeds(from file: String) -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return Future<(data: Data, response: URLResponse), Error> { promise in
      DispatchQueue.global(qos: .background).async {
        let bundle = Bundle(for: type(of: self) as! AnyClass)
        guard let path = bundle.path(forResource: file, ofType: "json") else {
          promise(.failure(FeedsProviderError.serverError(statusCode: 404)))
          return
        }
        
        do {
          let url = URL(fileURLWithPath: path)
          let data = try Data(contentsOf: url, options: .mappedIfSafe)
          let response = URLResponse(url: url, mimeType: "application/json", expectedContentLength: data.count, textEncodingName: nil)
          promise(.success((data: data, response: response)))
        } catch {
          promise(.failure(FeedsProviderError.requestFailed(error)))
        }
      }
    }.eraseToAnyPublisher()
  }
}

class OneFeedProvider: FeedsProvider {
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return getFeeds(from: "OnePushEvent")
  }
}

class CorruptedEventsProvider: FeedsProvider {
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return getFeeds(from: "CorruptedEvents")
  }
}

class FullPageEventsProvider: FeedsProvider {
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return getFeeds(from: "30Events")
  }
}
