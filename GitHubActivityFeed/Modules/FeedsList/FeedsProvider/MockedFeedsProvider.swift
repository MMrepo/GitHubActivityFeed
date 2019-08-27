//
//  MockedFeedsProvider.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine

class MockedFeedsProvider: FeedsProvider {
  func getFeeds() -> AnyPublisher<[Feed], FeedsProviderError> {
    let feeds = (1...100).map { Feed(eventName: "event nr. \($0)") }
    return Just(feeds).setFailureType(to: FeedsProviderError.self).eraseToAnyPublisher()
  }
}
