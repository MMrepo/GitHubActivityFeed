//  
//  FeedsListStateMachine.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import GameplayKit

class FeedsListStateMachine: GKStateMachine {
  weak var vc: FeedsListViewController!
  
  init(vc: FeedsListViewController,
       states: [GKState]) {
    self.vc = vc
    super.init(states: states)
  }
}

fileprivate extension GKState {
  var getFeedsListStateMachine: FeedsListStateMachine? {
    return stateMachine as? FeedsListStateMachine
  }
}
