//
//  Feed.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

struct Feed {
  var eventName: String
  let identifier = UUID()
}

extension Feed: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(identifier)
  }

  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.identifier == rhs.identifier
  }
}
