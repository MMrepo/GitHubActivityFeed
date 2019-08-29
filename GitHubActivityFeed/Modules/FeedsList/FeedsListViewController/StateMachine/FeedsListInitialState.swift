//
//  FeedsListInitialState.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit
import UIKit

class FeedsListInitialState: GKState {
  private weak var viewController: FeedsListViewController!

  override func didEnter(from previousState: GKState?) {
    viewController.getNewFeeds()
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == FeedsListLoadingState.self
  }

  init(viewController: FeedsListViewController) {
    self.viewController = viewController
    super.init()
  }
}

extension FeedsListInitialState: Parametrable {
  static var parameterName: String {
    return "initial"
  }
}
