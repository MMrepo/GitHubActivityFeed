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
  private var withAnimations: Bool
  private weak var viewController: FeedsListViewController!
  private weak var refreshControl: UIRefreshControl!
  private let loadingIndicator: UIAlertController

  override func didEnter(from previousState: GKState?) {
    // As we don't want to show two loading indicators at once.
    if !refreshControl.isRefreshing {
      viewController.present(loadingIndicator, animated: withAnimations)
    }
  }

  override func willExit(to nextState: GKState) {
    loadingIndicator.dismiss(animated: true)
    refreshControl.endRefreshing()
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == FeedsListLoadedState.self || stateClass == FeedsListFailedToLoadState.self
  }

  init(viewController: FeedsListViewController, refreshControl: UIRefreshControl, withAnimations: Bool) {
    self.viewController = viewController
    self.loadingIndicator = FeedsListLoadingState.makeLoadingIndicator()
    self.refreshControl = refreshControl
    self.withAnimations = withAnimations
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
    loadingIndicator.accessibilityIdentifier = "loadingIndicator"
    alert.view.addSubview(loadingIndicator)
    return alert
  }
}

extension FeedsListLoadingState: Parametrable {
  static var parameterName: String {
    return "loading"
  }
}
