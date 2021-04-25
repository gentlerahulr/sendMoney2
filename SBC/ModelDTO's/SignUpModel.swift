//
//  SignUpModel.swift
//  SBC
//

import Foundation

class SignUpRequest: Codable {
    
    var email: String?
    var password: String?
    var name: String?
    var registrationType: String?
    var facebookId: String?
    var appleId: String?
    var registartionType: String?
}

struct SignUpResponse: Decodable {
    let userHashId: String
}
