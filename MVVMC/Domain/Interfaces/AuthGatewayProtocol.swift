//
//  AuthGatewayProtocol.swift
//  MVVMC
//
//  Created by Dmitry Kh on 6.09.22.
//

import Foundation
import Combine

protocol AuthGatewayProtocol {
  func authorizeCurrentUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error>
  func createUser(profile: UserProfileEntity, with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error>
}
