//
//  Pathable.swift
//
//
//  Created by Mateusz Małek on 22/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

public protocol Pathable {
  static var path: String { get }
}

public extension Pathable where Self: UIViewController {
  static var path: String {
    return "\(classForCoder())"
  }
}
