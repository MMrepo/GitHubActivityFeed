//
//  FeedCell.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import UIKit

class FeedCell: UICollectionViewCell {
  let label = UILabel()
  static var reuseIdentifier: String {
    return NSStringFromClass(Self.self)
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    configure()
  }

  required init?(coder: NSCoder) {
    fatalError("not implemnted")
  }
}

extension FeedCell {
  func configure() {
    contentView.addSubview(label)
    label.snp.makeConstraints { make in
      make.left.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
    }

    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.preferredFont(forTextStyle: .title2)
    label.textColor = .label
    layer.borderWidth = 1
    layer.borderColor = UIColor.systemGray2.cgColor
  }
}
