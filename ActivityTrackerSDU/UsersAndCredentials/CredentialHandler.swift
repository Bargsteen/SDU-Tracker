//
//  CredentialHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

public class CredentialHandler {
    enum KeychainError: Error {
        case noPassword
        case unexpectedPasswordData
        case unhandledError(status: OSStatus)
    }

    static func saveCredentialsToKeychain(credentials: Credentials) throws {
        let account = credentials.username
        let password = credentials.password.data(using: .utf8)!
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrAccount as String: account,
                                    kSecAttrServer as String: String.server,
                                    kSecValueData as String: password]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == errSecSuccess else {
            Logging.logError("Credential creation error: \(status)")
            throw KeychainError.unhandledError(status: status)
        }
        
        
    }

    static func loadCredentialsFromKeychain() -> Credentials? {
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

    // Only used for development
    static func deleteCredentialsFromKeychain() throws {
        let query: [String: Any] = [kSecClass as String: kSecClassInternetPassword,
                                    kSecAttrServer as String: String.server]
        
        
        let status = SecItemDelete(query as CFDictionary)
        guard status == errSecSuccess else {
            Logging.logError("Credential deletion error: \(status)")
            throw KeychainError.unhandledError(status: status)
            
        }
    }

    static func ensureCredentialsAreSet() {
        let credentials = loadCredentialsFromKeychain()
        if credentials == nil {
            CredentialsWindow().showWindow(nil)
        }
    }
}

// Nice to have without the CredentialHandler prefix
struct Credentials {
    var username: String
    var password: String
}
