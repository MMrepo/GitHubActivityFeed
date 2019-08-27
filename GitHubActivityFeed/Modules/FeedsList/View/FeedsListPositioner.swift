//  
//  FeedsListPositioner.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import SnapKit
import UIKit
import Architecture

struct FeedsListPositioner {
  
  private(set) weak var mainView: FeedsListMainView!
  
  init(mainView: FeedsListMainView) {
    self.mainView = mainView
  }
}

extension FeedsListPositioner: Positioner {
  func setupLayout() {
  }
}
