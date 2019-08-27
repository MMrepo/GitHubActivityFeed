//
//  Identifier.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

struct Identifier<Entity, RawType: Hashable & Decodable> {
  let rawValue: RawType
}

extension Identifier: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(rawValue.hashValue)
  }

  static func == (lhs: Identifier, rhs: Identifier) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
}
