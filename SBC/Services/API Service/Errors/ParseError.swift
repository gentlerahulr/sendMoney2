//
//  ParseError.swift
//  SBC
//

import Foundation

/// `ParseError` is the error type returned when
/// there is a problem with data parsing of an api response
public struct ParseError: Swift.Error {
    public let error: Error?
    public let file: String
    public let line: Int
    public let function: String

    public init(_ error: Error?, file: String = #file, line: Int = #line, function: String = #function) {
        self.error = error
        self.file = file
        self.line = line
        self.function = function
    }
}

extension ParseError: LocalizedError {
    public var localizedDescription: String {
        return "Something went wrong"
    }
}

extension ParseError: Equatable {
    public static func == (_: ParseError, _: ParseError) -> Bool {
        return true
    }
}
