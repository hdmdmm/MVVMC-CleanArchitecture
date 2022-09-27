//
//  RootViewController.swift
//  MVVMC
//
//  Created by Dmitry Kh on 30.08.22.
//

import Combine
import SwiftUI

class RootViewController: UIViewController {
  @ObservedObject private(set) var viewModel: RootViewModel
  private(set) var navigationCoordinator: NavigationCoordinatorProtocol

  private var cancellables: Set<AnyCancellable> = []

  // MARK: UI components
  lazy var activityIndicator: UIActivityIndicatorView = {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    activityIndicator.color = .gray
    return activityIndicator
  }()
  //

  init(
    _ viewModel: RootViewModel,
    _ coordinator: NavigationCoordinatorProtocol
  ) {
    self.viewModel = viewModel
    self.navigationCoordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setupBackground()

    setupConstraints()

    bindViewModel()
    viewModel.update()
  }

  private func bindViewModel() {
    viewModel.$status
      .sink { [weak self] status in
        self?.updateActivityIndicator(with: status)
      }
      .store(in: &cancellables)
    
    viewModel.$router
      .sink {[navigationCoordinator] router in
        navigationCoordinator.next(arg: router as? RouterProtocol)
      }
      .store(in: &cancellables)
  }

  private func setupConstraints() {
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(activityIndicator)

    NSLayoutConstraint.activate(
      [
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor)
      ]
    )
  }
  
  private func setupBackground() {
    view.backgroundColor = .white
  }

  private func updateActivityIndicator(with status: DataReadyStatus) {
    status == .finished || status == .cancelled
    ? activityIndicator.stopAnimating()
    : activityIndicator.startAnimating()
  }
}

