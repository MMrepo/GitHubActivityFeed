//  
//  FeedsListStylizer.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Architecture
import UIKit

struct FeedsListStylizer {
  
  private(set) weak var mainView: FeedsListMainView!
  
  init(mainView: FeedsListMainView) {
    self.mainView = mainView
  }
}

extension FeedsListStylizer: Stylizer {
  func setupStyle() {
    mainView.backgroundColor = .systemBackground
  }
}
