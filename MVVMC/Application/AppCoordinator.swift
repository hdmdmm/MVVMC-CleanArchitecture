//
//  AppCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit

protocol NavigationCoordinator {
  func next(arg: Any)
  func start()
}

protocol NavigationType {
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol)
}

enum AppNavigationTypes: NavigationType {
  case mainSceneFlow, signInSceneFlow, signUpSceneFlow
  
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol) {
    guard let dependencies = container as? AppDIDependencies else {
      // put the logs
      return
    }
    let viewController: UIViewController
    switch self {
    case .mainSceneFlow:
      viewController = navigateToMainSceneFlow(dependencies.makeMainSceneFlowDIContainer())
    case .signUpSceneFlow:
      viewController = navigateToSignUpSceneFlow(dependencies.makeSignUpSceneFlowDIContainer())
    case .signInSceneFlow:
      viewController = navigateToSignInSceneFlow(dependencies.makeSignInSceneFlowDIContainer())
    }
    
    rootViewController?.present(viewController, animated: true)
  }

  private func navigateToSignInSceneFlow(_ container: SignInSceneDIContainer) -> UIViewController  {
    container.rootViewController()
  }
  private func navigateToSignUpSceneFlow(_ container: SignUpSceneDIContainer) -> UIViewController  {
    container.rootViewController()
  }
  private func navigateToMainSceneFlow(_ container: MainSceneDIContainer) -> UIViewController {
    container.rootViewController()
  }
}

final class AppCoordinator {
  // important: weak referenced here due to strong referenced in UI hierarchy
  weak var rootViewController: UINavigationController?
  private let container: AppDIContainer

  init ( container: AppDIContainer ) {
    self.container = container
  }
}

extension AppCoordinator: NavigationCoordinator {
  func next(arg: Any) {
    guard let navigation = arg as? AppNavigationTypes else {
      // put the navigation error to logger
      return
    }

    navigation.navigate(rootViewController: rootViewController, container: container)
  }

  func start() {
    // while on top level here is nothing to add
  }
}
