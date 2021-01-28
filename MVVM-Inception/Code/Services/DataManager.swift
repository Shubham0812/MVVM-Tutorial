//
//  DataManager.swift
//  MVVM-Inception
//
//  Created by Shubham Singh on 28/01/21.
//

import Foundation

struct DataManager {
    
    // MARK:- variables
    let networkManager: NetworkManager
        
    // MARK:- initializers
    init(networkManager: NetworkManager = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    // MARK:- functions
    func getPosts(offset: Int, limit: Int, onCompletion: @escaping([Post]?, Error?) -> ()) {
        let queries: [String : Any] = ["offset": offset, "limit": limit]
        
        self.networkManager.getPosts(queries: queries) { (res, error) in
            if (error == nil) {
                onCompletion(res, nil)
            }
        }
    }
}
