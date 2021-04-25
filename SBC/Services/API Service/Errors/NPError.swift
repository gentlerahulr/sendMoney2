//
//  NPError.swift
//  SBC
//

import Foundation

/// This is the error response that will come from the API
/// which contains the status, message, and possibly, inputs.
public struct NPError: Swift.Error {
    public let errors: String
}

extension NPError: LocalizedError {
    /// Describes an error that provides localized messages describing why
    /// an error occurred and provides more information about the error.
    public var localizedDescription: String {
        return self.errors
    }
}

extension NPError: Decodable {
    internal enum CodingKeys: String, CodingKey {
        case errors
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.errors = try container.decode(String.self, forKey: .errors)
    }

    public init(data: Data, responseCode: Int) throws {
        let badRequest: NPError = try JSONDecoder().decode(NPError.self, from: data)
        self.errors = badRequest.errors
    }
}

extension NPError: Equatable {}
