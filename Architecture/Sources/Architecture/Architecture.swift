//
//  Architecture.swift
//
//
//  Created by Mateusz Małek on 21/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

open class GenericViewController<MainViewType: UIView>: UIViewController {
  public var mainView: MainViewType {
    // swiftlint:disable:next superfluous_disable_command force_cast
    return view as! MainViewType
    // swiftlint:enable:next superfluous_disable_command force_cast
  }

  public var builder: AnyViewBuilderFactory<MainViewType>

  public init(builder: AnyViewBuilderFactory<MainViewType>) {
    self.builder = builder
    super.init(nibName: nil, bundle: nil)
  }

  public required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  open override func loadView() {
    super.loadView()
    view = builder.mainView()
    builder.positioner(for: mainView).setupLayout()
    builder.stylizer(for: mainView).setupStyle()
  }

  open override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
  }

  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    builder.stylizer(for: mainView).setupStyle()
  }

  open override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
      builder.stylizer(for: mainView).setupStyle()
    }
  }
}
