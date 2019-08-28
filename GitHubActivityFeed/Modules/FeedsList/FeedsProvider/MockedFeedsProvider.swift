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
  func getFeeds() -> AnyPublisher<[Feed], FeedsProviderError> {
    return Future<[Feed], FeedsProviderError> { promise in
      DispatchQueue.global(qos: .background).async {
        guard let path = Bundle.main.path(forResource: "MockedEvents", ofType: "json") else {
          promise(.failure(FeedsProviderError.undefined))
          return
        }
        do {
          let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
          let feeds = try data.decoded() as [Feed]
          promise(.success(feeds))
        } catch {
          promise(.failure(FeedsProviderError.decodingFailed(error)))
        }
      }
    }
    .delay(for: 2.0, scheduler: DispatchQueue(label: "mockedDownloadingBackgroundQueue"))
    .eraseToAnyPublisher()
  }

  func getFilteredFeedsBy(type: String) -> AnyPublisher<[Feed], FeedsProviderError> {
    return getFeeds().map { $0.filter { $0.type.contains(type) } }.eraseToAnyPublisher()
  }
}
