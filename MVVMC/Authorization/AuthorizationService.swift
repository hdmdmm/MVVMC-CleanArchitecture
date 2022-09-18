//
//  AuthorizationService.swift
//  MVVMC
//
//  Created by Dmitry Kh on 6.09.22.
//

import Foundation
import Combine
import CryptoKit

enum AuthorizationError: Error {
  case generic(Error)
}

struct SecurityQueriesDependencies {
  let saltQueries: SecuritySaltQueriesProtocol
  let passwordQueries: SecurityPasswordQueriesProtocol
  
  init(
    _ saltQueries: SecuritySaltQueriesProtocol = DefaultSecurityQueriesForSalt(),
    _ passwordQueries: SecurityPasswordQueriesProtocol = DefaultSecurityQueriesForPassword()
  ) {
    self.saltQueries = saltQueries
    self.passwordQueries = passwordQueries
  }
}

protocol AuthorizationServiceProtocol {
  var isAuthorized: CurrentValueSubject<Bool, Error> { get }
}

final class AuthorizationService: AuthorizationServiceProtocol {
  private(set) var isAuthorized: CurrentValueSubject<Bool, Error>
  
  private let dataTransferService: DataTransferServiceProtocol
  private let security: SecurityQueriesDependencies

  init (
    dataTransferService: DataTransferServiceProtocol,
    securityQueries: SecurityQueriesDependencies
  ) {
    self.dataTransferService = dataTransferService
    security = securityQueries
    isAuthorized = CurrentValueSubject(false)
  }
}

extension AuthorizationService: AuthenticationProtocol {
  func activateUserProtile(receivedCode: String) -> AnyPublisher<UserProfileEntity, Error> {
    // 1. send request with confirmation code and receive the created UserProfile with updates.
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }

  func createUser(profile: UserProfileEntity, with credentials: UserCredentialEntity) -> AnyPublisher<Bool, Error> {
    // 1. get salt from backend
    // 2. generate the hash256 for password + salt
    // 3. create user on backend side
    return Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }

  func authorizeCurrentUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error> {
    // 1. get salt from backend
    // 2. generate the hash256 for password + salt
    // 3. get authorize user
    Fail(error: NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])).eraseToAnyPublisher()
  }
}

private extension String {
  var stringSHA256: (String) -> String? {
    {
      guard let data = "\(self).\($0)".data(using: .utf8) else {
        return nil
      }
      let digest = SHA256.hash(data: data)
      return digest.map { String(format: "%02X", $0) }.joined()
    }
  }
}
