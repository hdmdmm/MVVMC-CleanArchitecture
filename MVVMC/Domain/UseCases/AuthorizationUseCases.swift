//
//  AuthorizationUseCases.swift
//  MVVMC
//
//  Created by Dmitry Kh on 6.09.22.
//

import Foundation
import Combine

enum AuthorizationUseCasesErrors: Error{
  case savingUserProfileWasNotSuccess
}

extension AuthorizationUseCasesErrors: LocalizedError {
  var errorDescription: String? {
    switch (self) {
    case .savingUserProfileWasNotSuccess:
      return "".localized
    }
  }
}

protocol AuthorizationUseCasesProtocol {
  func authorizeUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error>
  func createUser(_ user: UserProfileEntity, credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error>
}

final class AuthorizationUseCases {
  private var authGateway: AuthGatewayProtocol
  private var userRepository: UserRepositoryProtocol
  init(authRepository: AuthGatewayProtocol, userRepository: UserRepositoryProtocol) {
    self.authGateway = authRepository
    self.userRepository = userRepository
  }
}

extension AuthorizationUseCases: AuthorizationUseCasesProtocol {
  func authorizeUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error> {
    authGateway.authorizeCurrentUser(with: credentials)
      .flatMap { [userRepository] profile in
        userRepository.updateUser(profile)
      }
      .eraseToAnyPublisher()
  }
  
  func createUser(_ user: UserProfileEntity, credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error> {
    // create user in the network -> receiving user from network and store into db
    // read user from the repository -> fetching the user profile from db
    authGateway.createUser(profile: user, with: credentials)
      .flatMap { [userRepository] profile in
        userRepository.storeUser(profile)
      }
      .flatMap { [userRepository] success -> AnyPublisher<UserProfileEntity, Error> in
        if success {
          // read the stored user profile
          return userRepository.fetchCurrentUser()
        }
        return Fail(error: AuthorizationUseCasesErrors.savingUserProfileWasNotSuccess).eraseToAnyPublisher()
      }
      .eraseToAnyPublisher()
  }
}


