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

  private func makeViewController(_ coordinator: NavigationCoordinatorProtocol) -> SignInViewController {
    SignInViewController( makeViewModel(), coordinator )
  }

  func rootViewController() -> UIViewController {
    var coordinator = makeCoordinator()
    let rootViewController = UINavigationController(rootViewController: makeViewController(coordinator) )
    coordinator.rootViewController = rootViewController
    return rootViewController
  }
}
