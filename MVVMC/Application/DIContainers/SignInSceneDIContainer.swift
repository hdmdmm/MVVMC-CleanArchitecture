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
  private func makeViewModel() -> SignInViewModel {
    SignInViewModel()
  }
  
  private func makeCoordinator() -> SignInSceneCoordinator {
    SignInSceneCoordinator(container: self)
  }
  
  private func makeViewController() -> SignInViewController {
    SignInViewController( makeViewModel(), makeCoordinator() )
  }

  func rootViewController() -> UINavigationController {
    UINavigationController(rootViewController: makeViewController() )
  }
}
