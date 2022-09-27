//
//  SignInViewController.swift
//  MVVMC
//
//  Created by Dmitry Kh on 21.09.22.
//

import Combine
import SwiftUI

class SignInViewController: UIViewController {
  @ObservedObject private(set) var viewModel: SignInViewModel
  private(set) var navigationCoordinator: NavigationCoordinatorProtocol

  private var cancellables: Set<AnyCancellable> = []
  
  init(
    _ viewModel: SignInViewModel,
    _ coordinator: NavigationCoordinatorProtocol
  ) {
    self.viewModel = viewModel
    self.navigationCoordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
