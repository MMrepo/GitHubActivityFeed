//
//  Publishers+Extensions.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine

extension Publisher {
  func tap(_ action: @escaping () -> Void) -> AnyPublisher<Self.Output, Self.Failure> {
    return map {
      action()
      return $0
    }.eraseToAnyPublisher()
  }

  func cache(with cacheAction: @escaping (Self.Output) -> Void) -> AnyPublisher<Self.Output, Self.Failure> {
    return map {
      cacheAction($0)
      return $0
    }.eraseToAnyPublisher()
  }
}
