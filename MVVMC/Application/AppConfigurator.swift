//
//  AppConfigurator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation

struct Config: Decodable {
  let polygonApiKey: String
  // add the config keys here and in the AppConfig.plist file
}

final class AppConfigurator {
  let config: Config

  init(_ bundle: Bundle = Bundle.main, _ fileName: String = "AppConfig") throws {

    guard let url = bundle.url(forResource: fileName, withExtension: "plist")
    else {
      throw ConfigErrors.configFileNotFound
    }

    guard let data = try? Data(contentsOf: url)
    else {
      throw ConfigErrors.configInvalidPath
    }

    guard let config = try? PropertyListDecoder().decode(Config.self, from: data)
    else {
      throw ConfigErrors.configDataMismatch
    }

    self.config = config
  }
}

enum ConfigErrors: Error {
  case configFileNotFound
  case configInvalidPath
  case configDataMismatch
}

extension ConfigErrors: LocalizedError {
  var errorDescription: String? {
    switch(self) {
    case .configDataMismatch: return "config_data_mismatch".localized
    case .configInvalidPath: return "config_invalid_path".localized
    case .configFileNotFound: return "config_file_not_found".localized
    }
  }
}
