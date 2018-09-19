//
//  Security.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

struct Credentials {
    var username: String
    var password: String
}

enum KeychainError: Error {
    case noPassword
    case unexpectedPasswordData
    case unhandledError(status: OSStatus)
}

func saveCredentialsToKeychain(credentials: Credentials) throws {
    let account = credentials.username
    let password = credentials.password.data(using: .utf8)!
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrAccount as String: account,
                                kSecAttrServer as String: String.server,
                                kSecValueData as String: password]
    
    let status = SecItemAdd(query as CFDictionary, nil)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
    
    
}

func loadCredentialsFromKeychain() -> Credentials? {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: String.server,
                                kSecMatchLimit as String: kSecMatchLimitOne,
                                kSecReturnAttributes as String: true,
                                kSecReturnData as String: true]
    
    var item: CFTypeRef?
    let status = SecItemCopyMatching(query as CFDictionary, &item)
    guard status != errSecItemNotFound else { return nil }
    guard status == errSecSuccess else { return nil }
    
    guard let existingItem = item as? [String : Any],
        let passwordData = existingItem[kSecValueData as String] as? Data,
        let password = String(data: passwordData, encoding: String.Encoding.utf8),
        let account = existingItem[kSecAttrAccount as String] as? String
        else {
            return nil
    }
    return Credentials(username: account, password: password)
}

func deleteCredentialsFromKeychain() throws {
    let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                kSecAttrServer as String: String.server]
    
    
    let status = SecItemDelete(query as CFDictionary)
    guard status == errSecSuccess else { throw KeychainError.unhandledError(status: status)}
}

private func saveCredentialsToCredentialsStoragePermanently(_ credentials: Credentials) {
    let userCredential = URLCredential(user: credentials.username,
                                       password: credentials.password,
                                       persistence: .permanent)
    let protectionSpace = URLProtectionSpace.init(host: .server,
                                                  port: 80,
                                                  protocol: "https",
                                                  realm: nil,
                                                  authenticationMethod: nil)
    URLCredentialStorage.shared.setDefaultCredential(userCredential, for: protectionSpace)
}


