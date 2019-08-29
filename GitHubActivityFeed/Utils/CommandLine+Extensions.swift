//
//  CommandLine+Extensions.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

extension CommandLine {
  struct Option {
    let commandArgument: String
    let valueArgument: String?
  }

  static func option(for commandArgument: String) -> Option? {
    guard let commandIndex = CommandLine.arguments.firstIndex(of: commandArgument) else { return nil }
    let nextIndex = CommandLine.arguments.index(after: commandIndex)
    let valueArgument = CommandLine.arguments[optional: nextIndex]
    return Option(commandArgument: commandArgument, valueArgument: valueArgument)
  }
}
