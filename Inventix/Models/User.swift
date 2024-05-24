//
//  User.swift
//  Inventix
//
//  Created by Khanh Chung on 4/6/24.
//

import Foundation

struct User: Codable {
    var username: String
    var token: String
    var firstName: String
    var lastName: String
    var email: String
}
