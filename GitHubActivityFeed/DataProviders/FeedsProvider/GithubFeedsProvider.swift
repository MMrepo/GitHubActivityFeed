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
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    let config = URLSessionConfiguration.default
    config.requestCachePolicy = .reloadIgnoringLocalCacheData
    config.urlCache = nil
    let session = URLSession(configuration: config)
    let url = URL(string: "https://api.github.com/events")!
    return session.dataTaskPublisher(for: url)
      .mapError { FeedsProviderError.requestFailed($0) }
      .tryMap { (data, response) -> (data: Data, response: URLResponse) in

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
          throw FeedsProviderError.serverError(statusCode: httpResponse.statusCode)
        }
        return (data: data, response: response)
      }.eraseToAnyPublisher()
  }
}
