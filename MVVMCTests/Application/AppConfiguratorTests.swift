//
//  AppConfiguratorTests.swift
//  MVVMCTests
//
//  Created by Dmitry Kh on 30.08.22.
//

import XCTest
@testable import MVVMC

class AppConfiguratorTests: XCTestCase {
  
  func testExistentConfigFile() throws {
    _ = try AppConfigurator()
  }
  
  func testPolygonApiKeyValue() throws {
    let configurator = try AppConfigurator()
    XCTAssertFalse(configurator.model.polygonApiKey.isEmpty)
    XCTAssertEqual(configurator.model.polygonApiKey.count, 32)
  }  
}
