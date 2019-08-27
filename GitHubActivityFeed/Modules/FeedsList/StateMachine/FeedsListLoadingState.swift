//
//  FeedsListLoadingState.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit
import UIKit

class FeedsListLoadingState: GKState {
  private weak var viewController: FeedsListViewController!
  private weak var refreshControl: UIRefreshControl!
  private let loadingIndicator: UIAlertController

  override func didEnter(from previousState: GKState?) {
    if previousState is FeedsListInitialState {
      viewController.present(loadingIndicator, animated: true)
    }
  }

  override func willExit(to nextState: GKState) {
    loadingIndicator.dismiss(animated: true)
    refreshControl.endRefreshing()
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == FeedsListLoadedState.self || stateClass == FeedsListFailedToLoadState.self
  }

  init(viewController: FeedsListViewController, refreshControl: UIRefreshControl) {
    self.viewController = viewController
    self.loadingIndicator = FeedsListLoadingState.makeLoadingIndicator()
    self.refreshControl = refreshControl
    super.init()
  }
}

private extension FeedsListLoadingState {
  static func makeLoadingIndicator() -> UIAlertController {
    let alert = UIAlertController(title: nil, message: "Loading feeds...", preferredStyle: .alert)

    let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 10, width: 50, height: 50))
    loadingIndicator.hidesWhenStopped = true
    loadingIndicator.style = UIActivityIndicatorView.Style.medium
    loadingIndicator.startAnimating()

    alert.view.addSubview(loadingIndicator)
    return alert
  }
}
