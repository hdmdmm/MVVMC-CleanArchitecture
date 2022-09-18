//
//  AppDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit

protocol DIDepenciesProtocol{}

protocol AppDIDependencies: DIDepenciesProtocol {
  func makeMainSceneFlowDIContainer() -> MainSceneDIContainer
  func makeSignInSceneFlowDIContainer() -> SignInSceneDIContainer
  func makeSignUpSceneFlowDIContainer() -> SignUpSceneDIContainer
}

final class AppDIContainer {
  let config: AppConfigurator

  lazy var authorizationService: AuthorizationServiceProtocol = {
    AuthorizationService(
      dataTransferService: makeAuthDataTransferService(),
      securityQueries: SecurityQueriesDependencies()
    )
  }()

  lazy var coordinator: AppCoordinator = {
    AppCoordinator(container: self)
  }()

  init(config: AppConfigurator) {
    self.config = config
  }

  func makeRootViewController() -> UINavigationController {
    UINavigationController(rootViewController: makeMainViewController())
  }

  private func makeMainViewController() -> UIViewController {
    MainViewController(makeMainViewModel(), coordinator)
  }

  private func makeMainViewModel() -> MainViewModel {
    let dependencies = MainViewModelDependencies(
      authorizationService: authorizationService,
      userInteractorUseCases: makeUserUseCases(),
      navigateToSignInSceneFlow: AppNavigationTypes.signInSceneFlow,
      navigateToSignUpSceneFlow: AppNavigationTypes.signUpSceneFlow,
      navigateToMainSceneFlow: AppNavigationTypes.mainSceneFlow
    )
    return MainViewModel(dependencies)
  }

  private func makeUserUseCases() -> UserUseCasesProtocol {
    UserUseCases(repository: makeUserRepository())
  }

  private func makeUserRepository() -> UserRepositoryProtocol {
    UserRepository()
  }

  private func makeAuthDataTransferService() -> DataTransferServiceProtocol {
    AuthDataTransferService()
  }
}

extension AppDIContainer: AppDIDependencies {
  func makeMainSceneFlowDIContainer() -> MainSceneDIContainer {
    MainSceneDIContainer()
  }
  
  func makeSignInSceneFlowDIContainer() -> SignInSceneDIContainer {
    SignInSceneDIContainer()
  }
  
  func makeSignUpSceneFlowDIContainer() -> SignUpSceneDIContainer {
    SignUpSceneDIContainer()
  }
}
