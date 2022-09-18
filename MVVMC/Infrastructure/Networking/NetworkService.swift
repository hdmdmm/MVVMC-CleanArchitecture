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

public protocol NetworkServiceProtocol {}

public struct DefaultNetworkService: NetworkServiceProtocol {
  private let sessionManager: NetworkSessionManagerProtocol
  init(sessionManager: NetworkSessionManagerProtocol = DefaultNetworkSessionManager()) {
    self.sessionManager = sessionManager
  }
}

public protocol NetworkSessionManagerProtocol {
  func dataTask(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError>
}

public struct DefaultNetworkSessionManager: NetworkSessionManagerProtocol {
  private let session: URLSession
  
  public init(configuration: URLSessionConfiguration) {
    session = URLSession(configuration: configuration)
  }
  
  public init(session: URLSession = URLSession.shared) {
    self.session = session
  }
  
  public func dataTask(request: URLRequest) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
    session.dataTaskPublisher(for: request).eraseToAnyPublisher()
  }
}
