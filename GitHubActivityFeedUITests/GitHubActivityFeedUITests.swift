//
//  GitHubActivityFeedUITests.swift
//  GitHubActivityFeedUITests
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import XCTest

class FeedsListUITests: XCTestCase {
  
  private var app: XCUIApplication!
  
  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    app = XCUIApplication()
    app.launchArguments.append("-t")
    app.launchArguments.append("-s")
    app.launchArguments.append("/FeedsRouter/FeedsListViewController/")
  }
  
  override func tearDown() {
  }
  
  func testShouldShowLoadingIndicatorPresentLoadedDataAndHideIndicatorOnAppStart() {
    app.launch()
    XCTAssert(app.isLoadingIndicatorVisible)
    XCTAssert(app.cells["feedCell"].waitForExistence(timeout: 2))
    XCTAssertFalse(app.isLoadingIndicatorVisible)
  }
  
  func testFilteringShouldShowOnlyEventsThatMatchingQuery() {
    app.launch()
    XCTAssert(app.cells["feedCell"].waitForExistence(timeout: 2))
    app.searchBar("filterFeeds").tap()
    app.searchBar("filterFeeds").typeText("create")
    XCTAssert(app.cells["feedCell"].staticTexts["CreateEvent"].waitForExistence(timeout: 2))
    XCTAssertFalse(app.cells["feedCell"].staticTexts["PushEvent"].exists)
  }
  
  func testTapOnFeedCellOpenDetails() {
    app.launch()
    XCTAssert(app.cells["feedCell"].waitForExistence(timeout: 2))
    app.collectionViews.cells["feedCell"].staticTexts["PushEvent"].firstMatch.tap()
    XCTAssert(app.textViews["detailsTextView"].waitForExistence(timeout: 2))
  }
  
    func testLaunchPerformance() {
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
        measure(metrics: [XCTClockMetric(),
                          XCTStorageMetric(),
                          XCTMemoryMetric(),
                          XCTOSSignpostMetric.applicationLaunch]) {
                            XCUIApplication().launch()
        }
      }
    }
}

fileprivate extension XCUIApplication {
  var isLoadingIndicatorVisible: Bool {
    alerts.activityIndicators["loadingIndicator"].exists || otherElements["refreshControl"].exists
  }
  
  func searchBar(_ identifier: String) -> XCUIElement {
    otherElements[identifier].searchFields.firstMatch
  }
}
