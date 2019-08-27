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
  private let dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>

  override func didEnter(from previousState: GKState?) {}

  init(dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>) {
    self.dataSource = dataSource
    super.init()
  }

  func apply(snapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>) {
    dataSource.apply(snapshot)
  }
}
