//
//  DataTypes.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

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
        
        if let data = responseData, let utf8Representation = String(data: data, encoding: .utf8) {
            //print("response: ", utf8Representation)
        } else {
            //print("no readable data received in response")
        }
    }
    task.resume()
}

struct AppUsage: Codable {
    let participantIdentifier : String
    let timeStamp: String
    let userCount: Int
    let deviceModelName: String
    
    let package: String
    let duration: UInt
    
    
    init(participantIdentifier: String, timeStamp: Date, userCount: Int, deviceModelName: String, package: String, duration: UInt) {
        self.participantIdentifier = participantIdentifier
        self.timeStamp = timeStamp.description
        self.userCount = userCount
        self.deviceModelName = deviceModelName
        self.package = package
        self.duration = duration
    }
    
    
    // Map from "Swifty" property names to actual JSON property names
    enum CodingKeys: String, CodingKey {
        case participantIdentifier = "participant_identifier"
        case timeStamp = "date"
        case userCount = "user_count"
        case deviceModelName = "device_model_name"
        case package
        case duration
    }
}

struct DeviceUsage: Codable {
    let participantIdentifier : String
    let eventType: Int
    let timeStamp: String
    let userCount: Int
    let deviceModelName: String
    
    init(participantIdentifier: String, eventType: EventType, timeStamp: Date, userCount: Int, deviceModelName: String) {
        self.participantIdentifier = participantIdentifier
        self.eventType = eventType.rawValue
        self.timeStamp = timeStamp.description
        self.userCount = userCount
        self.deviceModelName = deviceModelName
    }
    
    
    // Map from "Swifty" property names to actual JSON property names
    enum CodingKeys: String, CodingKey {
        case participantIdentifier = "participant_identifier"
        case eventType = "event_type"
        case timeStamp = "timestamp"
        case userCount = "user_count"
        case deviceModelName = "device_model_name"
    }
}

enum EventType: Int {
    case started = 1, ended
}

enum Result<Value> {
    case success(Value)
    case failure(Error)
}

enum UsageType {
    case app
    case device
}


