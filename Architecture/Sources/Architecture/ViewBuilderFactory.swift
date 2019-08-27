//
//  ViewBuilderFactory.swift
//
//
//  Created by Mateusz Małek on 21/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

public protocol ViewBuilderFactory {
  associatedtype MainViewType: UIView
  func positioner(for mainView: MainViewType) -> Positioner
  func stylizer(for mainView: MainViewType) -> Stylizer
  func mainView() -> MainViewType
}

public struct AnyViewBuilderFactory<MainViewType: UIView>: ViewBuilderFactory {
  private let _positioner: (MainViewType) -> Positioner
  private let _stylizer: (MainViewType) -> Stylizer
  private let _mainView: () -> MainViewType

  public init<VBF: ViewBuilderFactory>(_ viewBuilderFactory: VBF) where VBF.MainViewType == MainViewType {
    self._positioner = viewBuilderFactory.positioner
    self._stylizer = viewBuilderFactory.stylizer
    self._mainView = viewBuilderFactory.mainView
  }

  public func mainView() -> MainViewType {
    return _mainView()
  }

  public func positioner(for mainView: MainViewType) -> Positioner {
    return _positioner(mainView)
  }

  public func stylizer(for mainView: MainViewType) -> Stylizer {
    return _stylizer(mainView)
  }
}
