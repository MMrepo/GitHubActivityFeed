//
//  FeedsListParameterParser.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 29/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Foundation
import Routable
import UIKit

protocol FeedsListParameterParserFactory {
  func makeParameterParserForFeedsList() -> ParameterParser
}

struct FeedsListParameterParser: ParameterParser {
  func parse(parameters: Parameters?) -> Parameters? {
    var parsed: [String: Any]? = parameters

    // For now parser will only support undefined error with string
    if let errorString = parameters?["error"] as? String { parsed?["error"] = FeedsProviderError.undefined(errorString) }
    if let snapshotString = parameters?["snapshot"] as? String, let feeds: [Feed] = try? snapshotString.removingPercentEncoding?.data(using: .utf8)?.decoded() {
      let snapshot = NSDiffableDataSourceSnapshot<FeedsListMainView.FeedListSection, Feed>()
      snapshot.appendSections([.main])
      snapshot.appendItems(feeds)
      parsed?["snapshot"] = snapshot
    }
    return parsed
  }
}
