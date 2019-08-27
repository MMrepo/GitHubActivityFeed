//
//  Feed.swift
//  GitHubActivityFeed
//
//  Created by Mateusz Małek on 27/08/2019.
//  Copyright © 2019 Mateusz Małek. All rights reserved.
//

import Codextended
import Foundation

struct Feed: Decodable {
  private static let dateFormatter = Feed.makeDateFormatter()

  let id: Identifier<Feed, String>
  let type: String
  let actor: Actor
  let repo: Repo
  let isPublic: Bool
  let createdAt: Date

  init(from decoder: Decoder) throws {
    self.id = try decoder.decode("id")
    self.type = try decoder.decode("type")
    self.actor = try decoder.decode("actor")
    self.repo = try decoder.decode("repo")
    self.isPublic = try decoder.decode("public")
    self.createdAt = try decoder.decode("created_at", using: Feed.dateFormatter)
  }
}

extension Feed {
  struct Actor: Decodable {
    let id: Identifier<Actor, UInt>
    let login: String
    let displayLogin: String
    let gravatarId: String
    let url: URL
    let avatarURL: URL

    init(from decoder: Decoder) throws {
      self.id = try decoder.decode("id")
      self.login = try decoder.decode("login")
      self.displayLogin = try decoder.decode("display_login")
      self.gravatarId = try decoder.decode("gravatar_id")
      self.url = try decoder.decode("url")
      self.avatarURL = try decoder.decode("avatar_url")
    }
  }
}

extension Feed {
  struct Repo: Decodable {
    let id: Identifier<Repo, UInt>
    let name: String
    let url: URL

    init(from decoder: Decoder) throws {
      self.id = try decoder.decode("id")
      self.name = try decoder.decode("name")
      self.url = try decoder.decode("url")
    }
  }
}

extension Feed: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }

  static func == (lhs: Feed, rhs: Feed) -> Bool {
    return lhs.id == rhs.id
  }
}

private extension Feed {
  static func makeDateFormatter() -> DateFormatter {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    return formatter
  }
}

// MARK: Identifier
extension Identifier: Decodable {
  init(from decoder: Decoder) throws {
    let rawValue = try decoder.decodeSingleValue(as: RawType.self)
    self.init(rawValue: rawValue)
  }
}
