//
//  NetworkManager.swift
//  MVVM-Inception
//
//  Created by Shubham Singh on 28/01/21.
//

import Foundation
import Alamofire


fileprivate enum APIs: URLRequestConvertible {
    
    case getAPI(path: String, data: [String: Any])
    
    static let baseURL = URL(string: "https://jsonplaceholder.typicode.com/")!
    static let reachability = NetworkReachabilityManager()!
    
    // specifying the endpoints for each API
    var path: String {
        switch self {
        case .getAPI(let path, _):
            return path
        }
    }
    
    // specifying the methods for each API
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
    
    // If the API requires body or queryString encoding, it can be specified here
    var encoding : URLEncoding {
        switch self {
        case .getAPI(_, _):
            return .queryString
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        var request = URLRequest(url: Self.baseURL.appendingPathComponent(path))
        
        if (path.contains("auth/login")) {
            request = URLRequest(url: URL(string: path)!)
        }
        
        request.httpMethod = method.rawValue
        var parameters = Parameters()
        
        switch self {
        case .getAPI(_, let queries):
            for (k,v) in queries {
                parameters[k] = v
            }
        }
        
        // encoding the request with the encoding specified above if any
        request = try encoding.encode(request, with: parameters)
        request.timeoutInterval = 20
        return request
    }
    
    //MARK:- functions for calling the API's
    static func makeGetRequest<T: Codable>(path: String, queries: [String: Any], onCompletion: @escaping(T?, Error?) -> ()) {
        if (reachability.isReachable) {
            Alamofire.request(Self.getAPI(path: path, data: queries)).validate().responseString { json in
                do {
                    let jsonDecoder = JSONDecoder()
                    if let result = json.data {
                        let response = try jsonDecoder.decode(T.self, from: result)
                        onCompletion(response, nil)
                    }
                } catch {
                    print("Error", error)
                }
            }
        }
    }
}

struct NetworkManager {
    func getPosts(queries: [String: Any], onCompletion: @escaping ([Post]?, Error?) -> ()) {
        APIs.makeGetRequest(path: "posts", queries: queries) { (res: [Post]?, error) in
            onCompletion(res, error)
        }
    }
}
