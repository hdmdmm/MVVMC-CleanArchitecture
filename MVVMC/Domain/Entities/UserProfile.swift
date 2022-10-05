//
//  UserProfile.swift
//  MVVMC
//
//  Created by Dmitry Kh on 6.09.22.
//

import Foundation

struct UserProfileEntity: Codable, Equatable {
  let name: String
  let lastName: String
  let username: String

  var hasher: Hasher {
    var hasher = Hasher()
    hasher.combine(username + name + lastName)
    return hasher
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.hasher.finalize() == rhs.hasher.finalize()
  }
}

struct UserCredentialEntity: Equatable {
  let username: String
  let password: String
  
  var hasher: Hasher {
    var hasher = Hasher()
    hasher.combine(username + password)
    return hasher
  }

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.hasher.finalize() == rhs.hasher.finalize()
  }
}
