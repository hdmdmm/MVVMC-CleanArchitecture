//
//  AuthorizationUseCasesTests.swift
//  MVVMCTests
//
//  Created by Dmitry Kh on 6.09.22.
//

import XCTest
import Combine
@testable import MVVMC


class AuthorizationUseCasesTests: XCTestCase {
  private let mockedUserID = UUID()
  private lazy var testUserProfile = UserProfileEntity(userId: mockedUserID, name: "Robert", lastName: "Martin", username: "unclebob")
  private lazy var testCredentials = UserCredentialEntity(userId: mockedUserID, username: "unclebob", password: "CleanArchitecture")

  private var cancellables: Set<AnyCancellable>!
  override func setUp() {
      super.setUp()
      cancellables = []
  }

  func testAuthorization() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: MockUserRepository(user: testUserProfile)
    )
    
    let publisher = authUseCase.authorizeUser(with: testCredentials)
    let authorizedUser = try awaitPublisher(publisher)
    XCTAssertEqual(authorizedUser, testUserProfile)
  }

  func testAuthorizationError_AuthGateway() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile, true), // setup true to simulate error from auth gateway
      userRepository: MockUserRepository(user: testUserProfile)
    )
    
    let publisher = authUseCase.authorizeUser(with: testCredentials)
    catchUpAndCheckForError(publisher, expectedError: MockAuthGateway.MockErrors.mockedAuthCurrentUserError)
  }

  func testAuthorizationError_UserRepository() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: MockUserRepository(user: testUserProfile, .mockedUpdeateUserError)  // setup true to simulate error from user repository
    )

    let publisher = authUseCase.authorizeUser(with: testCredentials)
    catchUpAndCheckForError(publisher, expectedError: MockUserRepository.MockErrors.mockedUpdeateUserError)
  }

  func testCreateUser() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: MockUserRepository(user: testUserProfile)
    )

    let publisher = authUseCase.createUser(testUserProfile, credentials: testCredentials)
    let success = try awaitPublisher(publisher)
    XCTAssertEqual(success, true)
  }
  
  func testCreateUserError_AuthGateway() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile, true),
      userRepository: MockUserRepository(user: testUserProfile)
    )

    let publisher = authUseCase.createUser(testUserProfile, credentials: testCredentials)
    catchUpAndCheckForError(publisher, expectedError: MockAuthGateway.MockErrors.mockedCreateUserError)
  }

  func testCreateUserError_AuthGateway_error() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile, true),
      userRepository: MockUserRepository(user: testUserProfile)
    )

    let publisher = authUseCase.confirmAuthorization(receivedCode: "code")
    catchUpAndCheckForError(publisher, expectedError: MockAuthGateway.MockErrors.mockedActivateUserProfile)
  }

  func testCreateUserError_UserRepository_storeUserError() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: MockUserRepository(user: testUserProfile, .mockedStoreUserError)
    )

    let publisher = authUseCase.confirmAuthorization(receivedCode: "code")
    catchUpAndCheckForError(publisher, expectedError: MockUserRepository.MockErrors.mockedStoreUserError)
  }
  
  func testCreateUserError_UserRepository_fetchUserError() throws {
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: MockUserRepository(user: testUserProfile, .mockedFetchCurrentUserError)
    )
  
    let publisher = authUseCase.confirmAuthorization(receivedCode: "code")
    catchUpAndCheckForError(publisher, expectedError: MockUserRepository.MockErrors.mockedFetchCurrentUserError)
  }
  
  func testCreateUserError_UserRepository_storeUserNotSucces() throws {
    let mockUserRepository = MockUserRepository(user: testUserProfile)
    mockUserRepository.mockedSuccessedResult = false
    
    let authUseCase = AuthorizationUseCases(
      authRepository: MockAuthGateway(authorizedUser: testUserProfile),
      userRepository: mockUserRepository
    )

    let publisher = authUseCase.confirmAuthorization(receivedCode: "code")
    catchUpAndCheckForError(publisher, expectedError: AuthorizationUseCasesErrors.savingUserProfileWasNotSuccess)
  }

  // MARK: private API helper
  private func catchUpAndCheckForError<P: Publisher, E: Equatable>(
    _ publisher: P,
    expectedError: E,
    file: StaticString = #filePath,
    line: UInt = #line
  ) {
    do {
      _ = try awaitPublisher(publisher)
      XCTFail("Expected error", file: file, line: line)
    } catch {
      XCTAssertEqual(error as? E, expectedError)
    }
  }
  

  class MockAuthGateway: AuthenticationProtocol {
    
    enum MockErrors: Error {
      case mockedAuthCurrentUserError
      case mockedCreateUserError
      case mockedActivateUserProfile
    }

    private(set) var mockedAuthorizedUser: UserProfileEntity
    let isReturnsErrorTest: Bool
    
    var testAuthoriseCurrentUser = false
    var testCreateUser = false
    
    var testCredentials: UserCredentialEntity?

    init(
      authorizedUser: UserProfileEntity,
      _ isReturnsError: Bool = false
    ) {
      mockedAuthorizedUser = authorizedUser
      isReturnsErrorTest = isReturnsError
    }
    
    func createUser(profile: UserProfileEntity, with credentials: UserCredentialEntity) -> AnyPublisher<Bool, Error> {
      testCredentials = credentials
      mockedAuthorizedUser = profile
      return providesPublisher(true, MockErrors.mockedCreateUserError)
    }
  
    func activateUserProtile(receivedCode: String) -> AnyPublisher<UserProfileEntity, Error> {
      providesPublisher(mockedAuthorizedUser, MockErrors.mockedActivateUserProfile)
    }

    func authorizeCurrentUser(with credentials: UserCredentialEntity) -> AnyPublisher<UserProfileEntity, Error> {
      testCredentials = credentials
      return providesPublisher(mockedAuthorizedUser, MockErrors.mockedAuthCurrentUserError)
    }

    // MARK: private API helper
    private func providesPublisher<T>(_ value: T, _ error: MockErrors) -> AnyPublisher<T, Error> {
      guard !isReturnsErrorTest else { return Fail(error: error).eraseToAnyPublisher() }
      return Just(value).setFailureType(to: Error.self).eraseToAnyPublisher()
    }
  }

  class MockUserRepository: UserRepositoryProtocol {
    enum MockErrors: Error {
      case mockedFetchCurrentUserError
      case mockedStoreUserError
      case mockedUpdeateUserError
      case mockedRemoveUserError
    }

    var mockCurrentUser: UserProfileEntity
    var mockedSuccessedResult = true
    var testReturnedError: MockErrors?
    
    init(
      user: UserProfileEntity = UserProfileEntity(userId: UUID(), name: "Ilon", lastName: "Mask", username: "IlonMask"),
      _ error: MockErrors? = nil
    ) {
      mockCurrentUser = user
      testReturnedError = error
    }

    func fetchCurrentUser() -> AnyPublisher<UserProfileEntity, Error> {
      let error: MockErrors? = testReturnedError == .mockedFetchCurrentUserError ? .mockedFetchCurrentUserError : nil
      return providesPublisher(mockCurrentUser, error: error)
    }

    func storeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error> {
      mockCurrentUser = profile
      let error: MockErrors? = testReturnedError == .mockedStoreUserError ? .mockedStoreUserError : nil
      return providesPublisher(mockedSuccessedResult, error: error)
    }

    func updateUser(_ profile: UserProfileEntity) -> AnyPublisher<UserProfileEntity, Error> {
      mockCurrentUser = profile
      let error: MockErrors? = testReturnedError == .mockedUpdeateUserError ? .mockedUpdeateUserError : nil
      return providesPublisher(mockCurrentUser, error: error)
    }

    func removeUser(_ profile: UserProfileEntity) -> AnyPublisher<Bool, Error> {
      let error: MockErrors? = testReturnedError == .mockedRemoveUserError ? .mockedRemoveUserError : nil
      return providesPublisher(mockedSuccessedResult, error: error)
    }

    private func providesPublisher<T>(_ argument: T, error: MockErrors?) -> AnyPublisher<T, Error> {
      guard let error = testReturnedError else {
        return Just(argument).setFailureType(to: Error.self).eraseToAnyPublisher()
      }
      return Fail(error: error).eraseToAnyPublisher()
    }
  }
}

extension XCTestCase {
  func awaitPublisher<T: Publisher>(
    _ publisher: T,
    timeout: TimeInterval = 5,
    file: StaticString = #file,
    line: UInt = #line
  ) throws -> T.Output {
    var result: Result<T.Output, Error>?
    let expectation = self.expectation(description: "Waiting for result")
    let cancelable = publisher.sink(
      
      receiveCompletion: {
        switch $0 {
        case .failure(let error):
          result = .failure(error)
        case .finished:
          break
        }
        expectation.fulfill()
      },
      receiveValue: { result = .success($0) }
    )

    waitForExpectations(timeout: timeout)
    cancelable.cancel()
    
    return try XCTUnwrap(result, "Awaited Publisher did not produce any output", file: file, line: line).get()
  }
}
