//
//  FeedsListViewController.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Architecture
import Combine
import GameplayKit
import Routable
import UIKit

protocol FeedsListViewControllerFactory: AnyObject {
  func makeFeedsListViewController(parameters: Parameters?) -> FeedsListViewController
}

class FeedsListViewController: GenericViewController<FeedsListMainView>, Pathable {
  typealias Factory = FeedsListViewBuilderFactory & FeedsProviderFactory

  private var stateMachine: FeedsListStateMachine!
  private let feedsProvider: FeedsProvider

  init(factory: Factory, parameters: Parameters? = nil) {
    self.feedsProvider = factory.makeFeedsProvider()
    super.init(builder: AnyViewBuilderFactory(factory.makeFeedsListScreenBuilder()))

    let initialState = FeedsListInitialState(dataSource: configureDataSource(with: mainView.feedsCollectionView))
    self.stateMachine = FeedsListStateMachine(vc: self, states: [initialState])

    configure()
    stateMachine.enter(FeedsListInitialState.self)
    loadData()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension FeedsListViewController {
  func configure() {
    mainView.feedsCollectionView.register(FeedCell.self,
                                          forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
  }

  func loadData() {
    feedsProvider.getFeeds().sink(receiveCompletion: { completion in
      switch completion {
      case .finished:
        break
      case .failure(let error):
        print("received the error: ", error)
      }
    }, receiveValue: { [unowned self] feeds in
      let snapshot = NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>()
      snapshot.appendSections([.main])
      snapshot.appendItems(feeds)
      self.stateMachine.state(forClass: FeedsListInitialState.self)?.apply(snapshot: snapshot)
    })
  }
}

private extension FeedsListViewController {
  func configureDataSource(with collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed> {
    return UICollectionViewDiffableDataSource(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath,
       feed: Feed) -> UICollectionViewCell? in

      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier,
                                                          for: indexPath) as? FeedCell else {
        fatalError("Cannot create new cell")
      }

      cell.label.text = feed.eventName
      return cell
    }
  }
}
