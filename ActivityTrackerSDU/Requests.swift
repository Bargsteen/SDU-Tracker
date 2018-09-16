//
//  DataTypes.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

func sendUsages<T:Encodable>(usages: [T], usageType: UsageType, credentials: Credentials, onSuccess:(() -> Void)?, onError: ((Error?) -> Void)?) {
    usages.forEach { usage in
        sendUsage(usage: usage, usageType: usageType, credentials: credentials, onSuccess: onSuccess, onError: onError)
    }
}

// We need a completion block which returns an error, if anything fails
func sendUsage<T:Encodable>(usage: T, usageType: UsageType, credentials: Credentials, onSuccess:(() -> Void)?, onError: ((Error?) -> Void)?) {
    
    // Set up URL
    var urlComponents = URLComponents()
    urlComponents.scheme = "https"
    urlComponents.host = .server
    urlComponents.path = usageType == .app ? .appPath : .devicePath
    
    urlComponents.user = credentials.username
    urlComponents.password = credentials.password
    
    guard let url = urlComponents.url else { fatalError("Could not create URL from components")}
    
    // Set up request
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["Content-Type"] = "application/json"
    request.allHTTPHeaderFields = headers
    
    
    // Try to encode the Usage
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(usage)
        request.httpBody = jsonData
    } catch {
        onError?(error)
    }
    
    
    // Perform request and catch error.
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            onError?(responseError!)
            return
        }
        if let data = responseData, let _ = String(data: data, encoding: .utf8) {
            onSuccess?()
        } else {
            // TODO: Log warning
        }
    }
    task.resume()
}




