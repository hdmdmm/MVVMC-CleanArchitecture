//
//  SignInSceneCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 21.09.22.
//

import Foundation
import UIKit

enum SignInFlowNavigationTypes: NavigationType {
  
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol) {
  }

}

final class SignInSceneCoordinator {
  // important: weak referenced here due to strong referenced in UI hierarchy
  weak var rootViewController: UINavigationController?
  private let container: SignInSceneDIContainer

  init ( container: SignInSceneDIContainer ) {
    self.container = container
  }
}

extension SignInSceneCoordinator: NavigationCoordinator {
  func next(arg: Any) {
    guard let navigation = arg as? SignInFlowNavigationTypes else {
      // put the navigation error to logger
      return
    }

    navigation.navigate(rootViewController: rootViewController, container: container)
  }

  func start() {
    // while on top level here is nothing to add
  }
}
