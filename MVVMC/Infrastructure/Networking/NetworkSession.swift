//
//  NetworkSession.swift
//  MVVMC
//
//  Created by Dmitry Kh on 19.09.22.
//

import Foundation
import Combine

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
    return session.dataTaskPublisher(for: request).eraseToAnyPublisher()
  }
}
