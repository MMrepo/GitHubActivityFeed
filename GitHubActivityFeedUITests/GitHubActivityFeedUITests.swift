//
//  GitHubActivityFeedUITests.swift
//  GitHubActivityFeedUITests
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import XCTest

class GitHubActivityFeedUITests: XCTestCase {

    override func setUp() {
        continueAfterFailure = false
    }

    override func tearDown() {
    }

    func testExample() {
        let app = XCUIApplication()
        app.launch()
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
