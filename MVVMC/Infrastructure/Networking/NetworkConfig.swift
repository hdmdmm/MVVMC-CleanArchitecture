//
//  NetworkConfig.swift
//  MVVMC
//
//  Created by Dmitry Kh on 19.09.22.
//

import Foundation

public protocol NetworkConfigurable {
  var baseURL: URL { get }
  var headers: [String: String] { get }
  var queryParameters: [String: String] { get }
}

public struct ApiDataNetworkConfig: NetworkConfigurable {
  public let baseURL: URL
  public let headers: [String: String]
  public let queryParameters: [String: String]
  
  public init(baseURL: URL,
              headers: [String: String] = [:],
              queryParameters: [String: String] = [:]) {
    self.baseURL = baseURL
    self.headers = headers
    self.queryParameters = queryParameters
  }
}
