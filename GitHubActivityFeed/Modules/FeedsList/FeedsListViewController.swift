//  
//  FeedsListViewController.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine
import Architecture
import UIKit
import Routable
import GameplayKit

protocol FeedsListViewControllerFactory: AnyObject {
    func makeFeedsListViewController(parameters: Parameters?) -> FeedsListViewController
}

class FeedsListViewController: GenericViewController<FeedsListMainView>, Pathable {
  typealias Factory = FeedsListViewBuilderFactory
  private var stateMachine: FeedsListStateMachine!
  
  init(factory: Factory, parameters: Parameters? = nil) {
    super.init(builder: AnyViewBuilderFactory(factory.makeFeedsListScreenBuilder()))
    self.stateMachine = FeedsListStateMachine(vc: self, states: [])
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
