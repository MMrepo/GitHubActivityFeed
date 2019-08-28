//
//  FeedsListFailedToLoadState.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit
import UIKit

class FeedsListFailedToLoadState: GKState {
  var error: Error?

  override func didEnter(from previousState: GKState?) {
    guard let error = error else { return }
    print("received the error: ", error)
  }

  override init() {
    super.init()
  }
}
