import XCTest
@testable import ONZ

class StringExtensionTests: XCTestCase {

}

// MARK: - Test String.formatCurrency

extension StringExtensionTests {
    func test_formatCurrency_withPositiveValue_shouldShowValidFormatWithPlusSign() {
        // Given
        let value = 19.99
        let expected = "+ S$19.99"

        // When
        let result = String.formatCurrency(from: value)

        // Then
        XCTAssertEqual(expected, result)
    }

    func test_formatCurrency_withNegativeValue_shouldShowValidFormatWithMinusSign() {
        // Given
        let value = -20.01
        let expected = "- S$20.01"

        // When
        let result = String.formatCurrency(from: value)

        // Then
        XCTAssertEqual(expected, result)
    }
}

// MARK: - Test String.fromDate

extension StringExtensionTests {
    func test_fromDate_withToday_shouldShowToday() {
        // Given
        let date = Date()
        let expected = "Today"

        // When
        let result = String.fromDate(date, dateFormat: .ddMMMMyyyyE, doesRelativeFormatting: true)

        // Then
        XCTAssertEqual(expected, result)
    }

    func test_fromDate_withYesterday_shouldShowToday() {
        // Given
        let date = Date(timeIntervalSinceNow: -60 * 60 * 24)
        let expected = "Yesterday"

        // When
        let result = String.fromDate(date, dateFormat: .ddMMMMyyyyE, doesRelativeFormatting: true)

        // Then
        XCTAssertEqual(expected, result)
    }

    func test_fromDate_olderDate_shouldShowCorrectFormat() {
        // Given
        guard let date = Calendar.current.date(from: DateComponents(year: 2020, month: 10, day: 12)) else {
            fatalError("Invalid date")
        }
        let expected = "12 October, 2020, Mon"

        // When
        let result = String.fromDate(date, dateFormat: .ddMMMMyyyyE, doesRelativeFormatting: true)

        // Then
        XCTAssertEqual(expected, result)
    }
}

// MARK: - Test String.initial

extension StringExtensionTests {
    func test_initial_with2Words_shouldShowValidResult() {
        // Given
        let value = "Grab Delivery"
        let expected = "GD"

        // When
        let result = value.initial

        XCTAssertEqual(expected, result)
    }

    func test_initial_with1Words_shouldShowValidResult() {
        // Given
        let value = "Apple"
        let expected = "AP"

        // When
        let result = value.initial

        XCTAssertEqual(expected, result)
    }

    func test_initial_withNonAlabets_shouldShowValidResult() {
        // Given
        let value = "PAYPAL *Wish"
        let expected = "PW"

        // When
        let result = value.initial

        XCTAssertEqual(expected, result)
    }
}
