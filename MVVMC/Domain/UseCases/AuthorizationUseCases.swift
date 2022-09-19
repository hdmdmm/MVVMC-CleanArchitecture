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
  func createUser(_ user: UserProfileEntity, credentials: UserCredentialEntity) -> AnyPublisher<Bool, Error>
  func confirmAuthorization(receivedCode: String) -> AnyPublisher<UserProfileEntity, Error>
}

final class AuthorizationUseCases {
  private var authentication: AuthenticationProtocol
  private var userRepository: UserRepositoryProtocol
  init(authRepository: AuthenticationProtocol, userRepository: UserRepositoryProtocol) {
    self.authentication = authRepository
    self.userRepository = userRepository
  }
}

extension AuthorizationUseCases: AuthorizationUseCasesProtocol {
  func confirmAuthorization(receivedCode: String) -> AnyPublisher<UserProfileEntity, Error> {
    authentication.activateUserProtile(receivedCode: receivedCode)
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

  func authorizeUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error> {
    authentication.authorizeCurrentUser(with: credentials)
      .flatMap { [userRepository] profile in
        userRepository.updateUser(profile)
      }
      .eraseToAnyPublisher()
  }
  
  func createUser(_ user: UserProfileEntity, credentials: UserCredentialEntity) -> AnyPublisher<Bool, Error> {
    // send request to backend and wait for confirmation code
    authentication.createUser(profile: user, with: credentials)
  }
}


