//
//  Routable.swift
//
//  Created by Mateusz Małek on 21/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

public typealias Parameters = [String: Any]
public typealias Router = UIViewController & Routable

private var routableAssociateKey: Void?

// MARK: Routable

/// Should be use to navigate between the modules and view controllers.
/// When used, viewControllers should only present popups or popovers.
/// Rest of the navigation should be done by Routers.
/// **Important!**  Each Router should be also a view controller!
public protocol Routable: AnyObject {
  /// This method should be used to navigate between the modules and view controllers.
  /// - Parameter path: Identifier of the view controller or router to present.
  /// - Parameter parameters: Dictionary of parameters that will be send to the next view controller or router.
  /// - Parameter animated: This parameter is used to determine if transition should be animated or not.
  @discardableResult func go(to path: String, parameters: Parameters?, animated: Bool) throws -> Routable
}

// MARK: Routable + destinations
private extension Routable {
  private var destinations: [String: DestinationFactoryMethod] {
    get {
      return objc_getAssociatedObject(self, &routableAssociateKey) as? [String: DestinationFactoryMethod] ?? [:]
    }
    set {
      objc_setAssociatedObject(self, &routableAssociateKey, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }
}

public extension Routable {
  typealias DestinationFactoryMethod = (_ parameters: Parameters?, _ animated: Bool) -> Routable

  @discardableResult func go(to path: String,
                             parameters: Parameters? = nil,
                             animated: Bool = false) throws -> Routable {
    guard let goTo = destinations[path] else {
      throw RoutableError.pathNotFound(path)
    }

    return goTo(parameters, animated)
  }

  /// Use this method to register factory method for view controller you want to navigate to.
  /// In case of registering a router it should always return registered router.
  /// In case of registering a view controller it should return registering router instead.
  ///
  /// - Parameter path: Identifier of the view controller or router to present.
  /// - Parameter destinationFactory: Should use dependacy container to initialize view controller
  ///  and them manage how it is added to the view hierarchy.
  func register(path: String, with destinationFactory: @escaping DestinationFactoryMethod) {
    destinations[path] = destinationFactory
  }

  @discardableResult func open(url: URL) throws -> Routable {
    // Important: `dropFirst` is added to ommit `/` because `self` is already opened.
    return try url.pathComponents.dropFirst().reduce(self) { (router: Routable, component) -> Routable in
      try router.go(to: component, parameters: url.queryParameters, animated: false)
    }
  }
}

// MARK: Helpers for managing children controllers
public extension Routable where Self: UIViewController {
  func add(childController: UIViewController) {
    addChild(childController)
    view.addSubview(childController.view)
    childController.didMove(toParent: self)
    childController.view.bindFrameToSuperviewBounds()
  }

  func remove(childController: UIViewController) {
    childController.willMove(toParent: nil)
    childController.view.removeFromSuperview()
    childController.removeFromParent()
  }

  func removeAllChildren() {
    children.forEach { child in
      remove(childController: child)
    }
  }
}

// MARK: UIView extensions
private extension UIView {
  func bindFrameToSuperviewBounds() {
    guard let superview = self.superview else { return }

    translatesAutoresizingMaskIntoConstraints = false
    topAnchor.constraint(equalTo: superview.topAnchor, constant: 0).isActive = true
    bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0).isActive = true
    leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0).isActive = true
    trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0).isActive = true
  }
}

// MARK: URL extensions
private extension URL {
  var queryParameters: [String: String]? {
    guard
      let components = URLComponents(url: self, resolvingAgainstBaseURL: true),
      let queryItems = components.queryItems else { return nil }
    return queryItems.reduce(into: [String: String]()) { result, item in
      result[item.name] = item.value
    }
  }
}
