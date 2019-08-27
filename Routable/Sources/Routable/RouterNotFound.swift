//
//  RouterNotFound.swift
//
//
//  Created by Mateusz Małek on 22/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

public class RouterNotFound: Routable {
  @discardableResult public func go(to path: String,
                                    parameters: Parameters? = nil,
                                    animated: Bool = false) throws -> Routable {
    throw RoutableError.pathNotFound(path)
  }

  public init() {}
}
