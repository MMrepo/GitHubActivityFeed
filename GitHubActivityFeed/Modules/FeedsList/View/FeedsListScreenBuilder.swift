//  
//  FeedsListScreenBuilder.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Architecture

protocol FeedsListViewBuilderFactory {
  func makeFeedsListScreenBuilder() -> FeedsListScreenBuilder
}

struct FeedsListScreenBuilder: ViewBuilderFactory {
  func mainView() -> FeedsListMainView {
    return FeedsListMainView()
  }

  func stylizer(for mainView: FeedsListMainView) -> Stylizer {
    return FeedsListStylizer(mainView: mainView)
  }

  func positioner(for mainView: FeedsListMainView) -> Positioner {
    return FeedsListPositioner(mainView: mainView)
  }
}
