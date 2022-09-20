//
//  BaseViewModel.swift
//  MVVMC
//
//  Created by Dmitry Kh on 31.08.22.
//

import Foundation
import Combine

struct MainViewModelDependencies {
  let authorizationService: AuthorizationServiceProtocol
  let userInteractorUseCases: UserUseCasesProtocol
  let navigateToSignInSceneFlow: Any
  let navigateToSignUpSceneFlow: Any
  let navigateToMainSceneFlow: Any
}

enum DataReadyStatus {
  case prepearing
  case loading
  case finished
  case cancelled
}

final class MainViewModel: ObservableObject {
  @Published private(set) var status: DataReadyStatus
  @Published private(set) var navigateTo: Any
  
  private let dependencies: MainViewModelDependencies
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(_ dependencies: MainViewModelDependencies) {
    status = .prepearing
    self.dependencies = dependencies
    navigateTo = Empty<Any, Never>().eraseToAnyPublisher()
  }
  
  func update() {
    status = .loading
    
    Publishers.CombineLatest(
      dependencies.userInteractorUseCases.currentUser().map { _ in true }.catch{_ in Just(false)},
      dependencies.authorizationService.isAuthorized.catch {_ in Just(false)}
    )
    .map { [dependencies] (isCurrentUser, isAuthorized) -> Any in
      guard isCurrentUser else {
        return dependencies.navigateToSignUpSceneFlow
      }
      guard isAuthorized else {
        return dependencies.navigateToSignInSceneFlow
      }
      return dependencies.navigateToMainSceneFlow
    }
    .assign(to: \.navigateTo, on: self)
    .store(in: &cancellables)
  }
  // MARK: - Private API Helper
}
