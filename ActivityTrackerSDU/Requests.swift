//
//  DataTypes.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

func sendUsages<T:Encodable>(usages: [T], usageType: UsageType, credentials: Credentials, completion:((Error?) -> Void)?) {
    usages.forEach { usage in
        sendUsage(usage: usage, usageType: usageType, credentials: credentials, completion: completion)
    }
}

// We need a completion block which returns an error, if anything fails
func sendUsage<T:Encodable>(usage: T, usageType: UsageType, credentials: Credentials, completion:((Error?) -> Void)?) {
    
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
    
    
    // Try to encode the Activity
    let encoder = JSONEncoder()
    do {
        let jsonData = try encoder.encode(usage)
        request.httpBody = jsonData
        //print("jsonData: ", String(data:request.httpBody!, encoding: .utf8) ?? "no body data")
    } catch {
        completion?(error)
    }
    
    
    // Perform request and catch error. Print result/error
    let config = URLSessionConfiguration.default
    let session = URLSession(configuration: config)
    let task = session.dataTask(with: request) { (responseData, response, responseError) in
        guard responseError == nil else {
            completion?(responseError!)
            return
        }
        
//        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
//            //print("response: ", utf8Representation)
//        } else {
//            //print("no readable data received in response")
//        }
    }
    task.resume()
}




