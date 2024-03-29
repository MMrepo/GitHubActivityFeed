//
//  FeedsListMainView.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

class FeedsListMainView: UIView {
  let feedsCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: FeedsListMainView.createLayout())
  let refreshControl = UIRefreshControl()
  let searchBar = UISearchBar(frame: .zero)

  init() {
    super.init(frame: .zero)

    addSubview(searchBar)
    addSubview(feedsCollectionView)
    feedsCollectionView.refreshControl = refreshControl

    refreshControl.accessibilityIdentifier = "refreshControl"
    self.accessibilityIdentifier = "feedsListMainView"
    searchBar.accessibilityIdentifier = "filterFeeds"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension FeedsListMainView {
  enum FeedListSection: CaseIterable {
    case main
  }
}

private extension FeedsListMainView {
  private static func createLayout() -> UICollectionViewLayout {
    let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .fractionalHeight(1.0))
    let item = NSCollectionLayoutItem(layoutSize: itemSize)
    let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                           heightDimension: .absolute(44))
    let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                   subitems: [item])
    let section = NSCollectionLayoutSection(group: group)
    let layout = UICollectionViewCompositionalLayout(section: section)
    return layout
  }
}
