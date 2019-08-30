//
//  FeedsControllerTests.swift
//  GitHubActivityFeedTests
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import XCTest
import Combine
@testable import GitHubActivityFeed

struct OneFeedMockedFactory: FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider {
    OneFeedProvider()
  }
}

struct CorruptedDataMockedFactory: FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider {
    CorruptedEventsProvider()
  }
}

struct AllEventsMockedFactory: FeedsProviderFactory {
  func makeFeedsProvider() -> FeedsProvider {
    FullPageEventsProvider()
  }
}

struct CorruptedFeedMock: Decodable {
  let id: Identifier<CorruptedFeedMock, Int>
}

extension CorruptedFeedMock {
  struct Error: Swift.Error {}
  
  init(from decoder: Decoder) throws {
    throw Error()
  }
}

class FeedsControllerTests: XCTestCase {
  func testgGetFeedsShouldCorrectlyGetAndParseData() {
    let feedsController = FeedsController(factory: OneFeedMockedFactory())
    
    let expectation = XCTestExpectation(description: "Get and parse feed from OnePushEvent.json)")
    
    let cancellable = feedsController.getFeeds().sink(receiveCompletion: { completion in
      switch completion {
      case .finished: expectation.fulfill()
      case .failure: XCTFail()
      }
    }) { feeds in
      XCTAssertNotNil(feeds)
      XCTAssertEqual(feeds.count, 1)
      XCTAssertEqual(feeds.first?.type, "PushEvent")
    }
    
    XCTAssertNotNil(cancellable)
    wait(for: [expectation], timeout: 2.0)
  }
  
  func testGetFeedsShouldReturnErrorWhenDataIsCorrupted() {
    let feedsController = FeedsController(factory: CorruptedDataMockedFactory())
    
    let expectedError = FeedsProviderError.decodingFailed(CorruptedFeedMock.Error())
    let expectation = XCTestExpectation(description: "Fail to parse data from CorruptedEvent.json)")
    
    let cancellable = feedsController.getFeeds().sink(receiveCompletion: { completion in
      switch completion {
      case .finished: XCTFail()
      case .failure(let error):
        XCTAssertEqual(error.localizedDescription, expectedError.localizedDescription)
        expectation.fulfill()
      }
    }) { feeds in
      XCTFail()
    }
    
    XCTAssertNotNil(cancellable)
    wait(for: [expectation], timeout: 2.0)
  }
  
  func testGetFilteredFeedsByShouldReturnFilteredData() {
    let feedsController = FeedsController(factory: AllEventsMockedFactory())
    
    let expectation = XCTestExpectation(description: "Filter successfully events from 30Events.json")
    
    preLoadDataFor(feedsController) {
      let cancellable = feedsController.getFilteredFeedsBy(type: "create").sink(receiveCompletion: { completion in
        switch completion {
        case .finished: expectation.fulfill()
        case .failure: XCTFail()
        }
      }) { feeds in
        XCTAssertNotNil(feeds)
        XCTAssertEqual(feeds.count, 6)
        feeds.forEach { XCTAssertEqual($0.type, "CreateEvent") }
      }
      
      XCTAssertNotNil(cancellable)
      self.wait(for: [expectation], timeout: 2.0)
    }
  }
}

private extension FeedsControllerTests {
  func preLoadDataFor(_ controller: FeedsController, then action: @escaping () -> Void) {
    let _ = controller.getFeeds().sink(receiveCompletion: { _ in }) { _ in action() }
  }
}
