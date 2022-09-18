//
//  AppConfigurator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation

struct AppConfiguratorData: Decodable {
  let polygonApiKey: String
  // add the config keys here and in the AppConfig.plist file
}

struct AppConfigurator: ConfiguratorProtocol {
  private(set) var configurator: AppConfiguratorData

  init(_ fileName: String = "AppConfig") throws {
    self.configurator = try Self.load(fileName)
  }
}
