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
    RootViewController(makeMainViewModel(), coordinator)
  }

  private func makeMainViewModel() -> RootViewModel {
    let dependencies = RootViewModelDependencies(
      authorizationService: authorizationService,
      userInteractorUseCases: makeUserUseCases(),
      navigateToSignInSceneFlow: AppNavigationTypes.signInSceneFlow,
      navigateToSignUpSceneFlow: AppNavigationTypes.signUpSceneFlow,
      navigateToMainSceneFlow: AppNavigationTypes.mainSceneFlow
    )
    return RootViewModel(dependencies)
  }
  
  private lazy var networkService: NetworkServiceProtocol = {
    let networkConfig = ApiDataNetworkConfig (
      baseURL: config.baseURL,
      headers: ["apiKey" : config.model.polygonApiKey]
    )
    return DefaultNetworkService(networkConfig: networkConfig)
  }()

  private func makeDataTransferService() -> DataTransferServiceProtocol {
    return DefaultDataTransferService(networkService: networkService)
  }
  
  private func makeUserRepository() -> UserRepositoryProtocol {
    return UserRepository(dataTransferService: makeDataTransferService())
  }
  
  private func makeUserUseCases() -> UserUseCasesProtocol {
    UserUseCases(repository: makeUserRepository())
  }

  private func makeAuthDataTransferService() -> DataTransferServiceProtocol {
    return AuthDataTransferService(networkService: networkService)
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
