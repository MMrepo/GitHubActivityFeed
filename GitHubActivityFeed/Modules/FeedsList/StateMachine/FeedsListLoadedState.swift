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
  private let dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>
  var lastSnapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>?

  override func didEnter(from previousState: GKState?) {
    guard let snapshot = lastSnapshot else { return } // It would be good to add some error handling here
    dataSource.apply(snapshot, animatingDifferences: true)
  }

  override func isValidNextState(_ stateClass: AnyClass) -> Bool {
    return stateClass == FeedsListLoadingState.self
  }

  init(dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>) {
    self.dataSource = dataSource
    super.init()
  }
}
