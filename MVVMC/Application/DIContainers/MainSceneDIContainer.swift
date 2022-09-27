//
//  MainSceneDIContainer.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import UIKit

protocol MainSceneDependencies: DIDepenciesProtocol {
}

final class MainSceneDIContainer: MainSceneDependencies {
  
  private func makeViewModel() -> MainViewModel {
    MainViewModel()
  }
  
  private func makeCoordinator() -> NavigationCoordinatorProtocol {
    NavigationCoordinator<MainFlowRouter, MainSceneDIContainer>(container: self)
  }
  
  private func makeViewController(_ coordinator: NavigationCoordinatorProtocol) -> MainViewController {
    MainViewController( makeViewModel(), coordinator )
  }

  func rootViewController() -> UIViewController {
    var coordinator = makeCoordinator()
    UINavigationController(rootViewController: makeViewController(coordinator) )
  }
}
