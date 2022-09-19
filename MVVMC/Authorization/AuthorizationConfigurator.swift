//
//  AuthorizationConfigurator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 17.09.22.
//

import Foundation

protocol AuthorizationConfiguratorProtocol {
  var urlSessionConfigurator: URLSessionConfiguration { get }
}

struct AuthorizationConfig: Decodable {
  let apiKey: String
}

struct AuthorizationConfigurator: ConfiguratorProtocol {
  let model: AuthorizationConfig
  
  init(_ fileName: String = "AuthorizationConfigurator") throws {
    model = try Self.load(fileName)
  }
}

