//
//  UserUseCases.swift
//  MVVMC
//
//  Created by Dmitry Kh on 7.09.22.
//

import Foundation
import Combine

protocol UserUseCasesProtocol {
  func currentUser() -> AnyPublisher<UserProfileEntity, Error>
  func removeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error>
}

final class UserUseCases {
  private var repository: UserRepositoryProtocol
  init(repository: UserRepositoryProtocol) {
    self.repository = repository
  }
}

extension UserUseCases: UserUseCasesProtocol {
  func currentUser() -> AnyPublisher<UserProfileEntity, Error> {
    repository.fetchCurrentUser()
  }
  
  func removeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error> {
    repository.removeUser(profile)
  }
}
