//
//  Endpoint.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation

public enum HTTPMethodType: String {
  case get = "GET"
  case head = "HEAD"
  case post = "POST"
  case put = "PUT"
  case patch = "PATCH"
  case delete = "DELETE"
}

public enum Encoding {
  case jsonSerializationData
  case stringEncodingAscii
}

public protocol ResponseDecoder {
  func decode<T: Decodable>(_ data: Data) throws -> T
}

public protocol ResponseRequestable: Requestable {
  associatedtype Response
  
  var responseDecoder: ResponseDecoder { get }
}

public protocol Requestable {
  var path: String { get }
  var isFullPath: Bool { get }
  var method: HTTPMethodType { get }
  var headers: [String: String] { get }
  var queryParametersEncodable: Encodable? { get }
  var bodyParametersEncodable: Encodable? { get }
  var queryParameters: [String: Any] { get }
  var bodyParameters: [String: Any] { get }
  var bodyEncoding: Encoding { get }
  
  func urlRequest(with config: NetworkConfigurable) throws -> URLRequest
}

public struct Endpoint<R>: ResponseRequestable {
  public typealias Response = R
  
  public let path: String
  public let isFullPath: Bool
  public let method: HTTPMethodType
  public let headers: [String : String]
  public let queryParametersEncodable: Encodable?
  public let bodyParametersEncodable: Encodable?
  public let queryParameters: [String : Any]
  public let bodyParameters: [String : Any]
  public let bodyEncoding: Encoding
  public let responseDecoder: ResponseDecoder
  
  init(
    path: String,
    isFullPath: Bool = false,
    method: HTTPMethodType,
    headers: [String: String] = [:],
    queryParametersEncodable: Encodable? = nil,
    bodyParametersEncodable: Encodable? = nil,
    queryParameters: [String : Any] = [:],
    bodyParameters: [String : Any] = [:],
    bodyEncoding: Encoding = .jsonSerializationData,
    responseDecoder: ResponseDecoder = JSONResponseDecoder()
  ) {
    self.path = path
    self.isFullPath = isFullPath
    self.method = method
    self.headers = headers
    self.queryParametersEncodable = queryParametersEncodable
    self.bodyParametersEncodable = bodyParametersEncodable
    self.queryParameters = queryParameters
    self.bodyParameters = bodyParameters
    self.bodyEncoding = bodyEncoding
    self.responseDecoder = responseDecoder
  }
}

enum RequestGenerationError: Error {
  case components
}

extension Requestable {
  func url(with config: NetworkConfigurable) throws -> URL {
    
    let baseURL = config.baseURL.absoluteString.last != "/"
    ? config.baseURL.absoluteString + "/"
    : config.baseURL.absoluteString
    
    let endpoint = isFullPath ? path : baseURL.appending(path)
    
    guard var urlComponents = URLComponents(string: endpoint) else {
      throw RequestGenerationError.components
    }
    
    var urlQueryItems: [URLQueryItem] = []
    
    let queryParameters = try queryParametersEncodable?.toDictionary() ?? self.queryParameters
    queryParameters.forEach {
      urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
    }

    config.queryParameters.forEach {
      urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
    }

    urlComponents.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
    guard let url = urlComponents.url else {
      throw RequestGenerationError.components
    }
    return url
  }
  
  public func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
    let url = try url(with: config)
    var urlRequest = URLRequest(url: url)
    var allHeaders: [String: String] = config.headers
    
    headers.forEach { allHeaders.updateValue($1, forKey: $0) }
    
    let bodyParameters = try bodyParametersEncodable?.toDictionary() ?? self.bodyParameters
    if !bodyParameters.isEmpty {
      urlRequest.httpBody = encodeBody(bodyParameters: bodyParameters, encoding: bodyEncoding)
    }
    urlRequest.httpMethod = method.rawValue
    urlRequest.allHTTPHeaderFields = allHeaders
    return urlRequest
  }
  
  private func encodeBody(bodyParameters: [String: Any], encoding: Encoding) -> Data? {
    switch encoding {
    case .jsonSerializationData:
      return try? JSONSerialization.data(withJSONObject: bodyParameters)
    case .stringEncodingAscii:
      return bodyParameters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
    }
  }
}

private extension Dictionary {
  var queryString: String {
    map { "\($0.key)=\($0.value)" }
      .joined(separator: "&")
      .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
  }
}

private extension Encodable {
  func toDictionary() throws -> [String: Any]? {
    let data = try JSONEncoder().encode(self)
    let jsonData = try JSONSerialization.jsonObject(with: data)
    return jsonData as? [String : Any]
  }
}
