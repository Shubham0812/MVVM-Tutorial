//
//  Post.swift
//  MVVM-Inception
//
//  Created by Shubham Singh on 28/01/21.
//

import Foundation

struct Post: Codable {
    let userId: Int
    let id: Int
    let title: String
    let body: String
}
