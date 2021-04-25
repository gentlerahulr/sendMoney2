//
//  APIError.swift
//  SBC
//

import Foundation
import Alamofire

/// This error happens when there is a problem with the api request
///
/// - badRequest: A bad request error
/// - parse: A parsing error
/// - response: A response error
/// - server: A server error
public enum APIError: Swift.Error {
    /// A bad request error
    case badRequest(BadRequestError)
    /// A parsing error
    case parse(ParseError)
    /// A response error
    case response(Error)
    /// A server error
    case server(Error)

    internal init(data: Data?, error: Error?, file: String = #file, line: Int = #line, function: String = #function) {
        if let error = error as? AFError {
            let responseCode = error.responseCode ?? -1
            if (500...599).contains(responseCode) {
                self = .server(error)
            } else if let data = data {
                do {
                    self = .badRequest(try BadRequestError(data: data, responseCode: responseCode))
                } catch {
                    self = .parse(ParseError(error, file: file, line: line, function: function))
                }
            } else {
                self = .response(error)
            }
        } else if let error = error {
            self = .response(error)
        } else {
            fatalError("This line should never happen for any reason")
        }
    }
}

extension APIError {
    /// The underlying error
    public var underlyingError: Error? {
        switch self {
        case .badRequest(let error): return error
        case .parse(let error): return error
        case .response(let error): return error
        case .server(let error): return error
        }
    }
}

extension APIError: Equatable {
    public static func == (lhs: APIError, rhs: APIError) -> Bool {
        switch (lhs, rhs) {
        case (.badRequest(let left), .badRequest(let right)):
            return left == right
        case (.parse(let left), .parse(let right)):
            return left == right
        case (.response, .response):
            return true
        case (.server, .server):
            return true
        default:
            return false
        }
    }
}

// MARK: - Error Booleans

extension APIError {
    /// Returns whether the APIError is a badRequest
    /// When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isBadRequestError: Bool {
        if case .badRequest = self { return true }
        return false
    }

    /// Returns whether the APIError is a parse error
    /// When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isParseError: Bool {
        if case .parse = self { return true }
        return false
    }

    /// Returns whether the APIError is a response error
    /// When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isResponseError: Bool {
        if case .response = self { return true }
        return false
    }

    /// Returns whether the APIError is a server error
    /// When `true`, the `underlyingError` property will
    /// contain the associated value.
    public var isServerError: Bool {
        if case .server = self { return true }
        return false
    }
}

extension APIError: LocalizedError {
    public var localizedDescription: String {
        switch self {
        case .badRequest(let error):
            return error.localizedDescription
        case .parse(let error):
            return "Parse Error \(error.localizedDescription)."
        case .response(let error):
            if let localizedError = error as? LocalizedError {
                return localizedError.localizedDescription
            }
            return error.localizedDescription
        case .server:
            return "Problem in connecting to the server. Please try after some time."
        }
    }
}
