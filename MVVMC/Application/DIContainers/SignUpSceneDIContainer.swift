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
  private func makeViewModel() -> SignUpViewModel {
    SignUpViewModel()
  }
  
  private func makeCoordinator() -> SignUpSceneCoordinator {
    SignUpSceneCoordinator(container: self)
  }
  
  private func makeViewController() -> SignUpViewController {
    SignUpViewController( makeViewModel(), makeCoordinator() )
  }

  func rootViewController() -> UINavigationController {
    UINavigationController(rootViewController: makeViewController() )
  }
}
