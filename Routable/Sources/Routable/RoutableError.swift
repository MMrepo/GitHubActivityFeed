//
//  RoutableError.swift
//
//
//  Created by Mateusz Małek on 22/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation

public enum RoutableError: Error {
  case pathNotFound(String)
}
