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

protocol FeedDetailsRouter: AnyObject {
  func showDetails(with details: String)
}

protocol FeedsListViewControllerFactory: AnyObject {
  func makeFeedsListViewController(router: FeedDetailsRouter, parameters: Parameters?) -> FeedsListViewController
}

class FeedsListViewController: GenericViewController<FeedsListMainView>, Pathable {
  typealias Factory = FeedsListViewBuilderFactory & FeedsControllerFactory

  private var stateMachine: FeedsListStateMachine!
  private let feedsController: FeedsController
  private var loadingFeedsCancellable: AnyCancellable?
  private var filteringFeedsCancellable: AnyCancellable?
  private var dataSource: UICollectionViewDiffableDataSource<FeedsListMainView.FeedListSection, Feed>!
  private weak var router: FeedDetailsRouter!
  private var parameters: Parameters?

  init(factory: Factory, router: FeedDetailsRouter, parameters: Parameters? = nil) {
    self.feedsController = factory.makeFeedsController()
    self.router = router
    self.parameters = parameters

    super.init(builder: AnyViewBuilderFactory(factory.makeFeedsListScreenBuilder()))

    self.dataSource = configureDataSource(with: mainView.feedsCollectionView)
    let initialState = FeedsListInitialState(viewController: self)
    let loadedState = FeedsListLoadedState(dataSource: dataSource)
    let filteredState = FeedsListFilterState(dataSource: dataSource)
    let loadingState = FeedsListLoadingState(viewController: self, refreshControl: mainView.refreshControl)
    self.stateMachine = FeedsListStateMachine(states: [initialState,
                                                       loadingState,
                                                       loadedState,
                                                       filteredState,
                                                       FeedsListFailedToLoadState()])

    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    startWith(parameters: parameters)
  }
}

extension FeedsListViewController {
  @objc func getNewFeeds() {
    stateMachine.enterLoadingState()

    loadingFeedsCancellable = feedsController.getFeeds()
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.stateMachine.enterFailedLoadingState(with: error)
        }
      }, receiveValue: { feeds in
        let snapshot = self.makeSnapshot()
        snapshot.appendItems(feeds)

        if let oldItems = self.stateMachine.lastLoadedSnapshot?.itemIdentifiers {
          snapshot.appendItems(oldItems)
        }

        self.stateMachine.enterLoadedState(with: snapshot)
      })
  }
}

private extension FeedsListViewController {
  func configure() {
    mainView.feedsCollectionView.register(FeedCell.self,
                                          forCellWithReuseIdentifier: FeedCell.reuseIdentifier)
    mainView.feedsCollectionView.delegate = self

    mainView.refreshControl.addTarget(self, action: #selector(getNewFeeds), for: .valueChanged)
    mainView.searchBar.delegate = self
  }

  func startWith(parameters: Parameters?) {
    guard let state = parameters?["state"] as? String else {
      stateMachine.enterInitialState()
      return
    }

    switch state {
    case FeedsListInitialState.parameterName:
      stateMachine.enterInitialState()
    case FeedsListLoadingState.parameterName:
      stateMachine.enterLoadingState()
    case FeedsListFailedToLoadState.parameterName:
      if let error = parameters?["error"] as? Error {
        stateMachine.enterFailedLoadingState(with: error)
      } else { fallthrough }
    case FeedsListLoadedState.parameterName:
      if let snapshot = parameters?["snapshot"] as? NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed> {
        stateMachine.enterLoadedState(with: snapshot)
      } else { fallthrough }
    case FeedsListFilterState.parameterName:
      if let snapshot = parameters?["snapshot"] as? NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed> {
        stateMachine.enterFilterState(with: snapshot)
      } else { fallthrough }

    default:
      stateMachine.enterInitialState()
    }
  }

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

      cell.titleLabel.text = "\(feed.type)"
      return cell
    }
  }
}

extension FeedsListViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    collectionView.deselectItem(at: indexPath, animated: true)
    guard let feed = self.dataSource.itemIdentifier(for: indexPath) else { return }

    router.showDetails(with: "\(feed)")
  }
}

extension FeedsListViewController: UISearchBarDelegate {
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    guard !searchText.isEmpty else {
      stateMachine.enterLoadedState()
      return
    }

    filteringFeedsCancellable = feedsController.getFilteredFeedsBy(type: searchText)
      .receive(on: RunLoop.main)
      .sink(receiveCompletion: { completion in
        switch completion {
        case .finished:
          break
        case .failure(let error):
          self.stateMachine.enterFailedLoadingState(with: error)
        }
      }, receiveValue: { feeds in
        let snapshot = self.makeSnapshot()
        snapshot.appendItems(feeds)
        self.stateMachine.enterFilterState(with: snapshot)
      })
  }
}
