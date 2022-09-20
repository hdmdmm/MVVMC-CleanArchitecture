//
//  AppConfigurator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation

struct AppConfiguratorModel: Decodable {
  let urlString: String
  let polygonApiKey: String
  // add the config keys here and in the AppConfig.plist file
}

struct AppConfigurator: ConfiguratorProtocol {
  private(set) var model: AppConfiguratorModel
  
  let baseURL: URL

  init(_ fileName: String = "AppConfig") throws {
    model = try Self.load(fileName)
    
    guard let url = URL(string: model.urlString) else {
      throw ConfiguratorErrors.configDataMismatch
    }

    baseURL = url
  }
}
