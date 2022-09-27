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
  
  private func makeViewController() -> MainViewController {
    MainViewController( makeViewModel(), makeCoordinator() )
  }

  func rootViewController() -> UIViewController {
    UINavigationController(rootViewController: makeViewController() )
  }
}
