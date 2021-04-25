//
//  Enum.swift
//  SBC
//

import Foundation

enum NetworkStatus: Int {
    
    case NotReachable = 0
    case ReachableViaWiFi
    case ReachableViaWWAN
}

enum ValidationState: Equatable {
    
    case valid
    case inValid(String)
}

func == (lhs: ValidationState, rhs: ValidationState) -> Bool {
    
    switch (lhs, rhs) {
    case (.valid, .valid):
        return true
    case (let .inValid(b), let .inValid(a)) :
        return a == b
    default:
        return false
    }
}

enum UserLanguage: Int {
    
    case ENGLISH = 0
    case OTHER
}
