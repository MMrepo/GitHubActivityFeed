//
//  UIViewController+ViewControllersHierarchy.swift
//
//
//  Created by Mateusz Małek on 22/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

public extension UIViewController {
  static func viewControllersHierarchy() -> [UIViewController] {
    guard let root = UIApplication.shared.keyWindow?.rootViewController else { return [] }
    return leaves(from: root, excluding: [UIAlertController.self])
  }

  private static func leaves(from parent: UIViewController,
                             excluding excludedTypes: [UIViewController.Type] = []) -> [UIViewController] {
    let isExcluded: (UIViewController) -> Bool = { vc in
      excludedTypes.contains(where: { vc.isKind(of: $0) }) || vc.modalPresentationStyle == .popover
    }

    if let presented = parent.presentedViewController, !isExcluded(presented) {
      return self.leaves(from: presented, excluding: excludedTypes)
    }

    let leaves = parent.children.reversed().flatMap {
      self.leaves(from: $0, excluding: excludedTypes)
    }

    if !leaves.isEmpty {
      return leaves + [parent]
    } else if !isExcluded(parent) {
      return [parent]
    } else {
      return []
    }
  }
}
