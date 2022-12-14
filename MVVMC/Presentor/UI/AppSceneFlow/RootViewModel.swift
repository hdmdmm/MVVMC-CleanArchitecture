//
//  RootViewModel.swift
//  MVVMC
//
//  Created by Dmitry Kh on 31.08.22.
//

import Foundation
import Combine

struct RootViewModelDependencies {
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

final class RootViewModel: ObservableObject {
  @Published private(set) var status: DataReadyStatus
  @Published private(set) var router: Any
  
  private let dependencies: RootViewModelDependencies
  
  private var cancellables: Set<AnyCancellable> = []
  
  init(_ dependencies: RootViewModelDependencies) {
    status = .prepearing
    self.dependencies = dependencies
    router = Empty<Any, Never>().eraseToAnyPublisher()
  }
  
  func update() {
    status = .loading

    authenticationPublisher
      .assign(to: \.router, on: self)
      .store(in: &cancellables)

    authenticationPublisher
      .map { _ -> DataReadyStatus in
        return .finished
      }
      .assign(to: \.status, on: self)
      .store(in: &cancellables)
  }

  // MARK: - Private API Helper
  private lazy var authenticationPublisher: AnyPublisher<Any, Never> = {
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
      .eraseToAnyPublisher()
  }()
}
