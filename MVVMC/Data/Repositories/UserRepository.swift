//
//  UserRepository.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import Combine

final class UserRepository: UserRepositoryProtocol {
  private let dataTransferService: DataTransferServiceProtocol
  private let userStorage: UserPersistentStorage
  
  init(
    dataTransferService: DataTransferServiceProtocol = DefaultDataTransferService(),
    userStorage: UserPersistentStorage = CoreDataPersistentStorage()
  ) {
    self.dataTransferService = dataTransferService
    self.userStorage = userStorage
  }

  func fetchCurrentUser() -> AnyPublisher<UserProfileEntity, Error> {
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }
  
  func storeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error> {
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }
  
  func updateUser(_ profile: UserProfileEntity) -> AnyPublisher<UserProfileEntity, Error> {
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }
  
  func removeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error> {
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }
}
