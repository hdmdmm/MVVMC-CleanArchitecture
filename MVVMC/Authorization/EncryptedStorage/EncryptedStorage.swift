//
//  EncryptedStorage.swift
//  MVVMC
//
//  Created by Dmitry Kh on 15.09.22.
//

import Foundation
import Security
import CryptoKit

enum EncryptStorageErrors: Error {
  case setterError(String)
  case getterError(String)
  case deleteError(String)
}

protocol EncryptedStorageProtocol {
  func extractSecValue<T>() -> Result<T?, EncryptStorageErrors>
  func putSecValue() -> Result<Bool, EncryptStorageErrors>
  func deleteSecValue() -> Result<Bool, EncryptStorageErrors>
}

struct DefaultEncryptedStorage: EncryptedStorageProtocol {
  let query: CFDictionary
  
  func extractSecValue<T>() -> Result<T?, EncryptStorageErrors> {
    var extractedValue: AnyObject?
    let status = SecItemCopyMatching(query, &extractedValue)
    
    guard status == errSecItemNotFound || status == errSecSuccess
    else {
      let message = SecCopyErrorMessageString(status, nil) as? String
      return .failure( .setterError ( message.unwrapped(with: status) ) )
    }

    guard status == errSecItemNotFound else {
      return .success(nil)
    }

    return .success(extractedValue as? T)
  }

  func putSecValue() -> Result<Bool, EncryptStorageErrors> {
    let status = SecItemAdd(query, nil)

    guard status == errSecDuplicateItem || status == errSecSuccess
    else {
      let message = SecCopyErrorMessageString(status, nil) as? String
      return .failure( .setterError ( message.unwrapped(with: status) ) )
    }

    return .success(true)
  }

  func deleteSecValue() -> Result<Bool, EncryptStorageErrors> {
    let status = SecItemDelete(query)
    
    guard status == errSecItemNotFound || status == errSecSuccess
    else {
      let message = SecCopyErrorMessageString(status, nil) as? String
      return .failure( .deleteError( message.unwrapped(with: status) ) )
    }
    return .success(true)
  }
}

extension CFString {
  var asString: String { self as String }
}

private extension Optional where Wrapped == String {
  func unwrapped(with status: OSStatus) -> String {
    self ?? "Description was not provided for status:\(status)"
  }
}
