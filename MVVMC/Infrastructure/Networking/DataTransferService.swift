//
//  DataTransferService.swift
//  MVVMC
//
//  Created by Dmitry Kh on 15.09.22.
//

import Foundation
import Combine

public enum DataTransferError: Error {
  case generic(Error)
  case noResponse
  case parsing(Error)
  case networkFailure(NetworkError)
  case resolvedNetworkFailure(Error)
}

public protocol DataTransferServiceProtocol {
  func request<T, E>(to endPoint: E) -> AnyPublisher<T, DataTransferError> where T : Decodable
}

public struct DefaultDataTransferService: DataTransferServiceProtocol {
  public func request<T, E>(to endPoint: E) -> AnyPublisher<T, DataTransferError> where T : Decodable {
    Fail(error: .generic (
      NSError(domain: String(describing: self), code: -9001, userInfo: [NSLocalizedDescriptionKey: "The \(#function) under maintenance"])
    ))
    .eraseToAnyPublisher()
  }
}

