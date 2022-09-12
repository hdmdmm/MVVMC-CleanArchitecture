//
//  UserRepositoryProtocol.swift
//  MVVMC
//
//  Created by Dmitry Kh on 7.09.22.
//

import Foundation
import Combine

protocol UserRepositoryProtocol {
  func fetchCurrentUser() -> AnyPublisher<UserProfileEntity, Error>
  func storeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error>
  func updateUser(_ profile: UserProfileEntity) -> AnyPublisher<UserProfileEntity, Error>
  func removeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error>
}
