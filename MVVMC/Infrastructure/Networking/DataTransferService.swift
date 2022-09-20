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
  func request<T: Decodable, E: ResponseRequestable>(to endPoint: E) -> AnyPublisher<T, DataTransferError> where E.Response == T
}

public struct DefaultDataTransferService: DataTransferServiceProtocol {
  private var networkService: NetworkServiceProtocol
  init(networkService: NetworkServiceProtocol) {
    self.networkService = networkService
  }
  
  public func request<T:Decodable, E: ResponseRequestable>(to endpoint: E) -> AnyPublisher<T, DataTransferError> where E.Response == T {
    networkService.request(endpoint: endpoint)
      .mapError { DataTransferError.networkFailure($0) }
      .tryMap { data -> T in
        try endpoint.responseDecoder.decode(data) as T
      }
      .mapError { DataTransferError.parsing($0) }
      .eraseToAnyPublisher()
  }
}

// MARK: - Response Decoders
public struct JSONResponseDecoder: ResponseDecoder {
  private let jsonDecoder = JSONDecoder()
  
  public func decode<T: Decodable>(_ data: Data) throws -> T {
    return try jsonDecoder.decode(T.self, from: data)
  }
}

public struct RawDataResponseDecoder: ResponseDecoder {
  enum CodingKeys: String, CodingKey {
    case `default` = ""
  }
  
  public func decode<T: Decodable>(_ data: Data) throws -> T {
    if T.self is Data.Type, let data = data as? T {
      return data
    } else {
      let context = DecodingError.Context(codingPath: [CodingKeys.default], debugDescription: "Expected Data type")
      throw Swift.DecodingError.typeMismatch(T.self, context)
    }
  }
}
