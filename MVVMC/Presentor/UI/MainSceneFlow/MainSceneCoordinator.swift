//
//  MainCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 20.09.22.
//

import Foundation
import UIKit

enum MainFlowNavigationTypes: NavigationType {
  // enumerate navigation cases here
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol) {
  }

}

final class MainSceneCoordinator {
  // important: weak referenced here due to strong referenced in UI hierarchy
  weak var rootViewController: UINavigationController?
  private let container: MainSceneDIContainer

  init ( container: MainSceneDIContainer ) {
    self.container = container
  }
}

extension MainSceneCoordinator: NavigationCoordinator {
  func next(arg: Any) {
    guard let navigation = arg as? MainFlowNavigationTypes else {
      // put the navigation error to logger
      return
    }

    navigation.navigate(rootViewController: rootViewController, container: container)
  }

  func start() {
    // while on top level here is nothing to add
  }
}
