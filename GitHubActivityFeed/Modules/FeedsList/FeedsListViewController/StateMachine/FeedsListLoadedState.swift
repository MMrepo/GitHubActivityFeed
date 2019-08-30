//
//  FeedsListLoadedState.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit
import UIKit

class FeedsListLoadedState: GKState {
  private var withAnimations: Bool
  private weak var dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>!
  var lastDownloadedSnapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>?

  override func didEnter(from previousState: GKState?) {
    guard let snapshot = lastDownloadedSnapshot else { return } // It would be good to add some error handling here
    dataSource.apply(snapshot, animatingDifferences: withAnimations)
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == FeedsListLoadingState.self || stateClass == FeedsListFilterState.self
  }

  init(dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>,
       withAnimations: Bool) {
    self.dataSource = dataSource
    self.withAnimations = withAnimations
    super.init()
  }
}

extension FeedsListLoadedState: Parametrable {
  static var parameterName: String {
    return "loaded"
  }
}
