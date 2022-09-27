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

  private func makeCoordinator() -> NavigationCoordinatorProtocol {
    NavigationCoordinator<SignInFlowRouter, SignInSceneDIContainer> (container: self)
  }

  private func makeViewController() -> SignInViewController {
    SignInViewController( makeViewModel(), makeCoordinator() )
  }

  func rootViewController() -> UIViewController {
    UINavigationController(rootViewController: makeViewController() )
  }
}
