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
  private var loadingFeedsCancellable: AnyCancellable?

  init(factory: Factory, parameters: Parameters? = nil) {
    self.feedsProvider = factory.makeFeedsProvider()
    super.init(builder: AnyViewBuilderFactory(factory.makeFeedsListScreenBuilder()))

    let loadedState = FeedsListLoadedState(dataSource: configureDataSource(with: mainView.feedsCollectionView))
    let loadingState = FeedsListLoadingState(viewController: self, refreshControl: mainView.refreshControl)
    self.stateMachine = FeedsListStateMachine(vc: self, states: [FeedsListInitialState(),
                                                                 loadingState,
                                                                 loadedState,
                                                                 FeedsListFailedToLoadState()])

    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    stateMachine.enter(FeedsListInitialState.self)
    loadData()
  }
}

private extension FeedsListViewController {
  func configure() {
    mainView.feedsCollectionView.register(FeedCell.self,
                                          forCellWithReuseIdentifier: FeedCell.reuseIdentifier)

    mainView.refreshControl.addTarget(self, action: #selector(loadData), for: .valueChanged)
  }

  @objc func loadData() {
    stateMachine.enter(FeedsListLoadingState.self)
    loadingFeedsCancellable = feedsProvider.getFeeds()
      .receive(on: RunLoop.main)
      .tap { [unowned self] in
        self.stateMachine.enter(FeedsListInitialState.self)
      }.sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.stateMachine.state(forClass: FeedsListFailedToLoadState.self)?.error = error
          self.stateMachine.enter(FeedsListFailedToLoadState.self)
        }
      }, receiveValue: { [unowned self] feeds in
        let loadedState = self.stateMachine.state(forClass: FeedsListLoadedState.self)
        let snapshot = loadedState?.lastSnapshot ?? self.makeSnapshot()
        if let lastItem = snapshot.itemIdentifiers.first {
          snapshot.insertItems(feeds, beforeItem: lastItem)
        } else {
          snapshot.appendItems(feeds)
        }
        loadedState?.lastSnapshot = snapshot
        self.stateMachine.enter(FeedsListLoadedState.self)
      })
  }

  func refreshButtonTapped(sender: UIBarButtonItem) {}
}

private extension FeedsListViewController {
  func makeSnapshot() -> NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed> {
    let snapshot = NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>()
    snapshot.appendSections([.main])
    return snapshot
  }

  func configureDataSource(with collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed> {
    return UICollectionViewDiffableDataSource(collectionView: collectionView) {
      (collectionView: UICollectionView, indexPath: IndexPath,
       feed: Feed) -> UICollectionViewCell? in

      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeedCell.reuseIdentifier,
                                                          for: indexPath) as? FeedCell else {
        fatalError("Cannot create new cell")
      }

      cell.label.text = "\(indexPath.row): \(feed.type) - \(feed.id.rawValue)"
      return cell
    }
  }
}
