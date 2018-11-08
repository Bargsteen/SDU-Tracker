//
//  RequestHandler.swift
//  ActivityTrackerSDU
//
//  Created by Kasper Dissing Bargsteen on 30/08/2018.
//

import Foundation

class RequestHandler: RequestHandlerProtocol {
    
    private let logger: LoggerProtocol
    
    init(assembler: AssemblerProtocol){
        logger = assembler.resolve()
    }
    
    // We need a completion block which returns an error, if anything fails
    func sendUsage<T:Usage>(usage: T, usageType: UsageType, credentials: Credentials, onSuccess:(() -> Void)?, onError: ((Error?) -> Void)?) {
        
        // Set up URL
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = .server
        urlComponents.path = usageType == .app ? .appPath : .devicePath
        
        let loginString = NSString(format: "%@:%@", credentials.username, credentials.password)
        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
        let base64LoginString = loginData.base64EncodedString(options: [])
        
        guard let url = urlComponents.url else {
            fatalError("Could not create URL from components")
        }
        
        // Set up request
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var headers = request.allHTTPHeaderFields ?? [:]
        headers["Content-Type"] = "application/json"
        headers["Authorization"] = "Basic \(base64LoginString)"
        request.allHTTPHeaderFields = headers
        
        
        // Try to encode the Usage
        let encoder = JSONEncoder()
        
        // Set the encoder to use the correct time format
        encoder.dateEncodingStrategy = .iso8601
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
                
                // No logging needed here, because that is handled in onError. Maybe logDebug?
                // Logging.logInfo("Requests sendUsage failed for \(usage.getIdentifier())")
                onError?(responseError!)
                return
            }
            
            if let urlResponse = response as? HTTPURLResponse {
                if(urlResponse.statusCode != 200){
                    self.logger.logError("Received Error Response: \(urlResponse.debugDescription)")
                    onError?(nil)
                    return
                }
            }
            
            if let data = responseData, let _ = String(data: data, encoding: .utf8) {
                onSuccess?()
            } else {
                onError?(nil)
            }
        }
        task.resume()
    }
}









