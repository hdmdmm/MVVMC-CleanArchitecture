//
//  SecurityQueriesForPassword.swift
//  MVVMC
//
//  Created by Dmitry Kh on 18.09.22.
//

import Foundation
import Security

protocol SecurityPasswordQueriesProtocol {
  func save(password: Data, account: String, service: String) -> EncryptedStorageProtocol
  func fetch(account: String, service: String) -> EncryptedStorageProtocol
  func delete(account: String, service: String) -> EncryptedStorageProtocol
}

struct DefaultSecurityQueriesForPassword: SecurityPasswordQueriesProtocol {  
  func fetch(account: String, service: String) -> EncryptedStorageProtocol {
    DefaultEncryptedStorage(query: [
      kSecClass.asString: kSecClassGenericPassword,
      kSecAttrService.asString: service,
      kSecAttrAccount.asString: account
    ] as CFDictionary)
  }
  
  func delete(account: String, service: String) -> EncryptedStorageProtocol {
    fetch(account: account, service: service)
  }

  func save(password: Data, account: String, service: String) -> EncryptedStorageProtocol {
    DefaultEncryptedStorage(query: [
      kSecClass.asString: kSecClassGenericPassword,
      kSecAttrService.asString: service,
      kSecAttrAccount.asString: account,
      kSecValueData.asString: password
    ] as CFDictionary)
  }
}
