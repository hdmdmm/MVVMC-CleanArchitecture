//
//  SignInSceneDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import UIKit

protocol SignInSceneDependencies: DIDepenciesProtocol {
}

final class SignInSceneDIContainer: SignInSceneDependencies {
  func rootViewController() -> UINavigationController {
    UINavigationController()
  }
}
