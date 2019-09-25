//
//  NetworkController.swift
//  GoodGame
//
//  Created by David Sadler on 9/24/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

class NetworkController{
    
    enum HTTPMethod: String {
        case get = "GET"
        case put = "PUT"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
    }
    
    static func performRequest(for url: URL, httpMethod: HTTPMethod,
                               urlParameters: [String: String]? = nil,
                               body: Data? = nil,
                               completion: ((Data?, Error?) -> Void)? = nil) {
        let requestURL = self.url(byAdding: urlParameters, to: url)
        var request = URLRequest(url: requestURL)
        request.httpMethod = httpMethod.rawValue
        request.httpBody = body
        request.setValue(Keys.ApiKey, forHTTPHeaderField: "user-key")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        let dataTask = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
            print(data ?? "data nil")
            print(urlResponse ?? "response nil")
            print(error ?? "error nil")
            completion?(data, error)
        }
        dataTask.resume()
    }
    
    static func url(byAdding parameters: [String: String]?, to url: URL) -> URL {
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = parameters?.compactMap {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = components?.url else {
            fatalError("URL optional is nil")
        }
        return url
    }
}

