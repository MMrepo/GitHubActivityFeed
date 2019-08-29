//
//  MockedFeedsProvider.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Codextended
import Combine
import Foundation

class MockedFeedsProvider: FeedsProvider {
  func getFeeds() -> AnyPublisher<(data: Data, response: URLResponse), Error> {
    return Future<(data: Data, response: URLResponse), Error> { promise in
      DispatchQueue.global(qos: .background).async {
        guard let path = Bundle.main.path(forResource: "MockedEvents", ofType: "json") else {
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
    }
    .delay(for: 1.0, scheduler: DispatchQueue(label: "mockedDownloadingBackgroundQueue"))
    .eraseToAnyPublisher()
  }
}
