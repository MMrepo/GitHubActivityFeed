//
//  SnapshotTests.swift
//  GitHubActivityFeedTests
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import SnapshotTesting
import XCTest
import Routable
@testable import GitHubActivityFeed

extension FeedTests {
  func forceCallLifecycleMethods(rootViewController: UIViewController) {
    rootViewController.beginAppearanceTransition(true, animated: false)
    rootViewController.endAppearanceTransition()
    rootViewController.children.forEach{
      forceCallLifecycleMethods(rootViewController: $0)
    }
  }
}

class FeedTests: XCTestCase {
  private let dependecyContainer = DependencyContainer(shouldUseMockedProviders: true)
  private var app: Application!
  private var sceneDelegate: SceneDelegate?
  
  override func setUp() {
    app = Application(factory: dependecyContainer)
  }

  func testFeedsListViewControllerLoadedStateSnapshot() {
    guard let router = try! app.open(url: URL(string: feedsListViewControllerLoaded)!) as? UIViewController else { return }
    forceCallLifecycleMethods(rootViewController: router)
    assertSnapshot(matching: app, as: .image(drawHierarchyInKeyWindow: true))
  }
  
  func testFeedsListViewControllerInitialStateSnapshot() {
    guard let router = try! app.open(url: URL(string: feedsListViewControllerInitial)!) as? UIViewController else { return }
    forceCallLifecycleMethods(rootViewController: router)
    assertSnapshot(matching: app, as: .image(drawHierarchyInKeyWindow: true))
  }
}

extension FeedTests {
  var feedsListViewControllerLoaded: String { "/FeedsRouter/FeedsListViewController?state=loaded&withAnimations=false&snapshot=%5B%7B%22id%22%3A%2210292486768%22%2C%22type%22%3A%22PushEvent%22%2C%22actor%22%3A%7B%22id%22%3A49118570%2C%22login%22%3A%22ClaireKi%22%2C%22display_login%22%3A%22ClaireKi%22%2C%22gravatar_id%22%3A%22%22%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Fusers%2FClaireKi%22%2C%22avatar_url%22%3A%22https%3A%2F%2Favatars.githubusercontent.com%2Fu%2F49118570%3F%22%7D%2C%22repo%22%3A%7B%22id%22%3A203605313%2C%22name%22%3A%22qwlake%2Fknu-festival%22%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%22%7D%2C%22payload%22%3A%7B%22push_id%22%3A3967590834%2C%22size%22%3A2%2C%22distinct_size%22%3A1%2C%22ref%22%3A%22refs%2Fheads%2Fmaster%22%2C%22head%22%3A%22e77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%2C%22before%22%3A%2262809b8f41741af053374a9acb3560738e55ef2f%22%2C%22commits%22%3A%5B%7B%22sha%22%3A%22103c478842522a4b574dc641275519282f182e67%22%2C%22author%22%3A%7B%22email%22%3A%22ksy201811677%40likelion.org%22%2C%22name%22%3A%22unknown%22%7D%2C%22message%22%3A%22feat+foodMap+img%22%2C%22distinct%22%3Afalse%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%2Fcommits%2F103c478842522a4b574dc641275519282f182e67%22%7D%2C%7B%22sha%22%3A%22e77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%2C%22author%22%3A%7B%22email%22%3A%2249118570%2BClaireKi%40users.noreply.github.com%22%2C%22name%22%3A%22ClaireKi%22%7D%2C%22message%22%3A%22Merge+pull+request+%2313+from+qwlake%2FseoYeon%5Cn%5Cnfeat+foodMap+img%22%2C%22distinct%22%3Atrue%2C%22url%22%3A%22https%3A%2F%2Fapi.github.com%2Frepos%2Fqwlake%2Fknu-festival%2Fcommits%2Fe77b993ee391e478d5d8e24ed3c7e95bf5143dbd%22%7D%5D%7D%2C%22public%22%3Atrue%2C%22created_at%22%3A%222019-08-27T14%3A33%3A01Z%22%7D%5D"
  }
  
  var feedsListViewControllerInitial: String { "/FeedsRouter/FeedsListViewController?state=initial&withAnimations=false"
  }
}
