//
//  SignUpSceneCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 21.09.22.
//

import Foundation
import UIKit

enum SignUpFlowNavigationTypes: NavigationType {
  
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol) {
  }

}

final class SignUpSceneCoordinator {
  // important: weak referenced here due to strong referenced in UI hierarchy
  weak var rootViewController: UINavigationController?
  private let container: SignUpSceneDIContainer

  init ( container: SignUpSceneDIContainer ) {
    self.container = container
  }
}

extension SignUpSceneCoordinator: NavigationCoordinator {
  func next(arg: Any) {
    guard let navigation = arg as? SignUpFlowNavigationTypes else {
      // put the navigation error to logger
      return
    }

    navigation.navigate(rootViewController: rootViewController, container: container)
  }

  func start() {
    // while on top level here is nothing to add
  }
}
