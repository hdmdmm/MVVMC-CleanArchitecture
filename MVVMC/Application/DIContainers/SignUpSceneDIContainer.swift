//
//  SignUpSceneDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import UIKit

protocol SignUpSceneDependencies: DIDepenciesProtocol {
}

final class SignUpSceneDIContainer: SignUpSceneDependencies {
  func rootViewController() -> UINavigationController {
    UINavigationController()
  }
}
