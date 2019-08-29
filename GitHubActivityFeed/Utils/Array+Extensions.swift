//
//  Array+Extensions.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

extension Array where Element: Hashable {
  subscript(optional index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}
