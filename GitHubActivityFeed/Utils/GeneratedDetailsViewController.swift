//
//  GeneratedViewController.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 28/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Combine
import Routable
import SnapKit
import UIKit

protocol GeneratedDetailsViewControllerFactory: AnyObject {
  func makeGeneratedDetailsViewController(parameters: Parameters?) -> GeneratedDetailsViewController
}

class GeneratedDetailsViewController: UIViewController, Pathable {
  static let detailsKey: String = "details"
  private let textView = UITextView(frame: .zero)

  init(parameters: Parameters? = nil) {
    super.init(nibName: nil, bundle: nil)

    view.addSubview(textView)
    textView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }
    textView.textColor = .label
    textView.isEditable = false

    let details = parameters?[GeneratedDetailsViewController.detailsKey] ?? "No details provided!"
    textView.text = "\(details)"
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
