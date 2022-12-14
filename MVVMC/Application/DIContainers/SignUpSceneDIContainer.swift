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
  
  private func makeCoordinator() -> NavigationCoordinatorProtocol {
    NavigationCoordinator<SignUpFlowRouter, SignUpSceneDIContainer>(container: self)
  }
  
  private func makeViewController(_ coordinator: NavigationCoordinatorProtocol) -> SignUpViewController {
    SignUpViewController( makeViewModel(), coordinator )
  }

  func rootViewController() -> UIViewController {
    var coordinator = makeCoordinator()
    let rootViewController = UINavigationController(rootViewController: makeViewController(coordinator) )
    coordinator.rootViewController = rootViewController
    return rootViewController
  }
}
