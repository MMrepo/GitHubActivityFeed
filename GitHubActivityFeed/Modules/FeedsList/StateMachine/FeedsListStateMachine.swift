//
//  FeedsListStateMachine.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit

class FeedsListStateMachine: GKStateMachine {
  override init(states: [GKState]) {
    super.init(states: states)
  }
}

private extension GKState {
  var getFeedsListStateMachine: FeedsListStateMachine? {
    return stateMachine as? FeedsListStateMachine
  }
}
