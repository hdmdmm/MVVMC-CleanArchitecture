//
//  AuthDataTransferService.swift
//  MVVMC
//
//  Created by Dmitry Kh on 17.09.22.
//

import Foundation
import Combine

struct AuthDataTransferService: DataTransferServiceProtocol {
  let networkService: NetworkServiceProtocol

  init(networkService: NetworkServiceProtocol = DefaultNetworkService()) {
    self.networkService = networkService
  }

  func request<T, E>(to endPoint: E) -> AnyPublisher<T, DataTransferError> where T : Decodable {
    Fail(error: .generic (
      NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])
    ))
    .eraseToAnyPublisher()
  }
}
