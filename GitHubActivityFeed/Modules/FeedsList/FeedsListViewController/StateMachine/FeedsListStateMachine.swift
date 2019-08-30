//
//  FeedsListStateMachine.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit

protocol Parametrable {
  static var parameterName: String { get }
}

class FeedsListStateMachine {
  private let stateMachine: GKStateMachine
  init(states: [GKState]) {
    self.stateMachine = GKStateMachine(states: states)
  }

  func currentState() -> GKState? {
    return stateMachine.currentState
  }
}

// MARK: API
extension FeedsListStateMachine {
  func enterInitialState() {
    stateMachine.enter(FeedsListInitialState.self)
  }

  func enterLoadingState() {
    stateMachine.enter(FeedsListLoadingState.self)
  }

  func enterLoadedState(with snapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>? = nil) {
    let loadedState = stateMachine.state(forClass: FeedsListLoadedState.self)
    if let snapshot = snapshot { loadedState?.lastDownloadedSnapshot = snapshot }
    stateMachine.enter(FeedsListLoadedState.self)
  }

  func enterFilterState(with snapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>?) {
    let loadedState = stateMachine.state(forClass: FeedsListFilterState.self)
    loadedState?.searchSnapshot = snapshot
    stateMachine.enter(FeedsListFilterState.self)
  }

  func enterFailedLoadingState(with error: Error) {
    let state = stateMachine.state(forClass: FeedsListFailedToLoadState.self)
    state?.error = error
    stateMachine.enter(FeedsListFailedToLoadState.self)
  }

  var lastLoadedSnapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>? {
    return stateMachine.state(forClass: FeedsListLoadedState.self)?.lastDownloadedSnapshot
  }

  var searchSnapshot: NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>? {
    return stateMachine.state(forClass: FeedsListFilterState.self)?.searchSnapshot
  }
}
