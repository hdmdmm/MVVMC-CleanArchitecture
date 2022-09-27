//
//  AppDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Foundation
import UIKit

protocol DIDepenciesProtocol{
  func rootViewController() -> UIViewController
}

protocol AppDIDependencies: DIDepenciesProtocol {
  func makeMainSceneFlowDIContainer() -> DIDepenciesProtocol
  func makeSignInSceneFlowDIContainer() -> DIDepenciesProtocol
  func makeSignUpSceneFlowDIContainer() -> DIDepenciesProtocol
}

final class AppDIContainer {
  let config: AppConfigurator
  
  init(config: AppConfigurator) {
    self.config = config
  }

  
  private func makeAuthDataTransferService() -> DataTransferServiceProtocol {
    return AuthDataTransferService(networkService: networkService)
  }
  
  lazy var authorizationService: AuthorizationServiceProtocol = {
    AuthorizationService(
      dataTransferService: makeAuthDataTransferService(),
      securityQueries: SecurityQueriesDependencies()
    )
  }()
  
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

  func makeCoordinator() -> NavigationCoordinatorProtocol {
    NavigationCoordinator<AppRouter, AppDIContainer>(container: self)
  }

  private func makeMainViewModel() -> RootViewModel {
    let dependencies = RootViewModelDependencies(
      authorizationService: authorizationService,
      userInteractorUseCases: makeUserUseCases(),
      navigateToSignInSceneFlow: AppRouter.signInSceneFlow,
      navigateToSignUpSceneFlow: AppRouter.signUpSceneFlow,
      navigateToMainSceneFlow: AppRouter.mainSceneFlow
    )
    return RootViewModel(dependencies)
  }

  private func makeMainViewController(_ coordinator: NavigationCoordinatorProtocol) -> UIViewController {
    RootViewController(makeMainViewModel(), coordinator)
  }
  
  func rootViewController() -> UIViewController {
    var coordinator = makeCoordinator()
    let rootViewConroller = UINavigationController(rootViewController: makeMainViewController(coordinator))
    coordinator.rootViewController = rootViewConroller
    return rootViewConroller
  }
}

extension AppDIContainer: AppDIDependencies {
  func makeMainSceneFlowDIContainer() -> DIDepenciesProtocol {
    MainSceneDIContainer()
  }
  
  func makeSignInSceneFlowDIContainer() -> DIDepenciesProtocol {
    SignInSceneDIContainer()
  }
  
  func makeSignUpSceneFlowDIContainer() -> DIDepenciesProtocol {
    SignUpSceneDIContainer()
  }
}
