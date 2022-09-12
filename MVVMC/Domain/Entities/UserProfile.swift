//
//  UserProfile.swift
//  MVVMC
//
//  Created by Dmitry Kh on 6.09.22.
//

import Foundation

struct UserProfileEntity: Codable, Equatable {
  let userId: UUID
  let name: String
  let lastName: String
  let username: String
  
  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.userId.hashValue == rhs.userId.hashValue
  }
}

struct UserCredentialEntity: Equatable {
  let userId: UUID
  let username: String
  let password: String

  static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.userId.hashValue == rhs.userId.hashValue
  }
}

typealias Salt = Int
