@testable import Routable
import XCTest

public func areEqual(_ lhs: Error, _ rhs: Error) -> Bool {
  return lhs.reflectedString == rhs.reflectedString
}

public extension Error {
  var reflectedString: String {
    return String(reflecting: self)
  }

  func isEqual(to: Self) -> Bool {
    return reflectedString == to.reflectedString
  }
}

final class RoutableTests: XCTestCase {
  class MockRoutable: Routable {
    init() {}
  }

  class MockRouter: Router {
    init() {
      super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }
  }

  func testGoToInvokeDestinationCallback() {
    let expect = expectation(description: "destination callback is called when go(to:) method is called on router")

    let router = mockRoutable()
    router.destinations["testPath"] = { _, _ in
      expect.fulfill()
      return router
    }
    try! router.go(to: "testPath")

    waitForExpectations(timeout: 0.1)
  }

  func testGoToReturnTheSameObjectAsDestinationCallback() {
    let router = mockRoutable()
    router.destinations["testPath"] = { _, _ in
      router
    }
    let returnedObject = try! router.go(to: "testPath")

    XCTAssert(returnedObject === router)
  }

  func testGoToThrowsErrorIfPathIsNotRegistered() {
    let router = mockRoutable()
    router.destinations["testPath"] = { _, _ in
      router
    }

    XCTAssertThrowsError(try router.go(to: "testPathNotRegistered")) { error in
      guard case RoutableError.pathNotFound(let notRegisteredPath) = error else {
        return XCTFail()
      }

      XCTAssert(areEqual(error, RoutableError.pathNotFound("testPathNotRegistered")))
      XCTAssertEqual(notRegisteredPath, "testPathNotRegistered")
    }
  }

  func testAddingChildToRouter() {
    let router = mockRouter()
    let testViewController = UIViewController()
    router.add(childController: testViewController)

    XCTAssert(router.children.contains(testViewController))
    XCTAssert(router.view.subviews.contains(testViewController.view))
  }

  func testRemovingChildFromRouter() {
    let router = mockRouter()
    let testViewController = UIViewController()

    router.addChild(testViewController)
    router.view.addSubview(testViewController.view)

    router.remove(childController: testViewController)

    XCTAssertFalse(router.children.contains(testViewController))
    XCTAssertFalse(router.view.subviews.contains(testViewController.view))
  }

  func testRemovingAllChildren() {
    let router = mockRouter()
    let testViewController = UIViewController()
    let testViewController2 = UIViewController()

    router.add(childController: testViewController)
    router.add(childController: testViewController2)

    XCTAssertFalse(router.children.isEmpty)
    XCTAssert(router.view.subviews.contains(testViewController.view))
    XCTAssert(router.view.subviews.contains(testViewController.view))

    router.removeAllChildren()
    XCTAssert(router.children.isEmpty)

    XCTAssertFalse(router.children.contains(testViewController))
    XCTAssertFalse(router.view.subviews.contains(testViewController.view))
    XCTAssertFalse(router.view.subviews.contains(testViewController2.view))
  }

  static var allTests = [("testGoToInvokeDestinationCallback", testGoToInvokeDestinationCallback),
                         ("testGoToThrowsErrorIfPathIsNotRegistered", testGoToThrowsErrorIfPathIsNotRegistered),
                         ("testAddingChildToRouter", testAddingChildToRouter),
                         ("testRemovingChildToRouter", testRemovingChildFromRouter)]
}
