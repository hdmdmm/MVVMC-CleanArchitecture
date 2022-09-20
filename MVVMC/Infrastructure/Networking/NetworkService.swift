//
//  NetworkService.swift
//  MVVMC
//
//  Created by Dmitry Kh on 17.09.22.
//

import Foundation
import Combine

public enum NetworkError: Error {
  case error(statusCode: Int, data: Data?)
  case notConnected
  case cancelled
  case generic(Error)
  case urlGeneration
}

public protocol NetworkServiceProtocol {
  func request(endpoint: Requestable) -> AnyPublisher<Data, NetworkError>
}

public struct DefaultNetworkService {
  private let sessionManager: NetworkSessionManagerProtocol
  private let networkConfig: NetworkConfigurable
  init(
    networkConfig: NetworkConfigurable,
    sessionManager: NetworkSessionManagerProtocol = DefaultNetworkSessionManager()
  ) {
    self.networkConfig = networkConfig
    self.sessionManager = sessionManager
  }
}

extension DefaultNetworkService: NetworkServiceProtocol {
  public func request(endpoint: Requestable) -> AnyPublisher<Data, NetworkError> {
    
    do {
      let urlRequest = try endpoint.urlRequest(with: networkConfig)
      return sessionManager.dataTask(request: urlRequest)
        .mapError { error -> NetworkError in
          if error.code == .notConnectedToInternet {
            return .notConnected
          }
          if error.code == .cancelled {
            return .cancelled
          }
          if error.code == .badURL || error.code == .unsupportedURL {
            return .urlGeneration
          }
          return .generic(error)
        }
        .map { (data: Data, response: URLResponse) in
          return data
        }
        .eraseToAnyPublisher()
    }
    catch {
      return Fail(error: NetworkError.urlGeneration).eraseToAnyPublisher()
    }
  }
}
