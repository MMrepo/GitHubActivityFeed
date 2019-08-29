//
//  ParameterParser.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation
import Routable

protocol ParameterParser {
  func parse(parameters: Parameters?) -> Parameters?
}
