//
//  AppCoordinator.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit

protocol RouterProtocol {
  func navigate(rootViewController: UINavigationController?, container: DIDepenciesProtocol)
}

protocol NavigationCoordinatorProtocol {
  var rootViewController: UINavigationController? {get set}
  var container: DIDepenciesProtocol { get }

  func next(arg: RouterProtocol?)
  func start()
}

final class NavigationCoordinator<R: RouterProtocol, C: DIDepenciesProtocol>: NavigationCoordinatorProtocol {
  // important: weak referenced here due to strong referenced in UI hierarchy
  weak var rootViewController: UINavigationController?
  private(set) var container: DIDepenciesProtocol

  init( container: DIDepenciesProtocol ) {
    self.container = container
  }

  func next(arg: RouterProtocol?) {
    guard let router = arg as? R else {
      // to log the navigation error to UI logger
      return
    }
    router.navigate(rootViewController: rootViewController, container: container)
  }

  func start() {}
}


enum AppRouter: RouterProtocol {
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
    
    rootViewController?.show(viewController, sender: self)
  }

  private func navigateToSignInSceneFlow(_ container: DIDepenciesProtocol) -> UIViewController  {
    container.rootViewController()
  }
  private func navigateToSignUpSceneFlow(_ container: DIDepenciesProtocol) -> UIViewController  {
    container.rootViewController()
  }
  private func navigateToMainSceneFlow(_ container: DIDepenciesProtocol) -> UIViewController {
    container.rootViewController()
  }
}
