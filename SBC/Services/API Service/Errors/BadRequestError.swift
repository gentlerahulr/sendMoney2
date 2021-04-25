//
//  BadRequestError.swift
//  SBC
//

import Foundation

/// This is the error response that will come from the API
/// which contains the status, message, and possibly, inputs.
public struct BadRequestError: Swift.Error {
    /// The api's return message
    public let title: String
    /// This will contain a value if this request error
    public let errors: [[String: String]]
//    public let error: String
    public let code: String
}

extension BadRequestError: LocalizedError {
    /// Describes an error that provides localized messages describing why
    /// an error occurred and provides more information about the error.
    public var localizedDescription: String {
        return self.title
    }
}

extension BadRequestError: Decodable {
    internal enum CodingKeys: String, CodingKey {
        case title, code, errors
    }

    /// The default initializer for the Decodable protocol
    ///
    /// - Parameter decoder: A decoder
    /// - Throws: DecodingError
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errors = try container.decode(Array.self, forKey: .errors)
        if !self.errors.isEmpty {
            self.title =  self.errors[0]["title"] ?? ""
            self.code = self.errors[0]["code"] ?? ""
        } else {
            self.title = try container.decode(String.self, forKey: .title)
            self.code = try container.decode(String.self, forKey: .code)
        }
    }

    public init(data: Data, responseCode: Int) throws {
        let badRequest: BadRequestError = try JSONDecoder().decode(BadRequestError.self, from: data)
        self.title = badRequest.title
        self.code = badRequest.code
        self.errors = badRequest.errors
    }
}

extension BadRequestError: Equatable {}
