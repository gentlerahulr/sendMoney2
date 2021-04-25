//
//  StringExtension.swift
//  SBC

import Foundation
import UIKit

extension String {
    
    func getHiddenCardNumber() -> String {
        return "••••  ••••  •••• " + self.suffix(4)
    }
    
    func getHiddenAccountNumber() -> String {
        let last3Digits = self.count >= 3 ? String(self.suffix(3)): self
        return "••••••••" + last3Digits
    }
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    func length() -> Int {
        return self.count
    }
    
    func int() -> Int? {
        let num = Int(self)
        if num != nil {
            return num
        } else {
            return nil
        }
    }
    
    func toFloat() -> Float? {
        let num = Float(self)
        if num != nil {
            return num
        } else {
            return nil
        }
    }
    
    func isEmpty() -> Bool {
        
        if self.length() == 0 {
            return true
        }
        return false
    }
    
    func getLastChar() -> String {
        if self == "" {
            return ""
        } else {
            return "\(String(describing: self.last))"
        }
    }
    
    func isLastChatDot() -> Bool {
        
        return (self.getLastChar() == ".")
    }
    
    func isContainDot() -> Bool {
        
        let dot = "."
        
        let range = self.range(of: dot)
        
        if range != nil {
            return true
        } else {
            return false
        }
    }

    func isContainSmallCharector() -> Bool {
        let smallLetterRegEx  = ".*[a-z]+.*"
        let smalltest = NSPredicate(format: "SELF MATCHES %@", smallLetterRegEx)
        let smallResult = smalltest.evaluate(with: self)
        return smallResult
    }
    
    func isContainCapitalCharector() -> Bool {
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format: "SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluate(with: self)
        return capitalresult
    }
    
    func isContainNumber() -> Bool {
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format: "SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluate(with: self)
        return numberresult
    }
    
    func isContainAlphabetsOnly() -> Bool {
        for chr in self {
            if !(chr >= "a" && chr <= "z") && !(chr >= "A" && chr <= "Z") {
                return false
            }
        }
        return true
    }
    
    //is contain white space
    func isContainwhitespace() -> Bool {
        
        let whitespace = CharacterSet.whitespaces
        let range = self.rangeOfCharacter(from: whitespace)
        if range != nil {
            return true
        } else {
            return false
        }
    }
    
    func isContainSpecialCharector() -> Bool {
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format: "SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluate(with: self)
        return specialresult
    }
    
    func isAlphaNumaric() -> Bool {
        return self.isContainNumber() && (self.isContainSmallCharector() || self.isContainCapitalCharector())
    }
    
    func isNumber() -> Bool {
        return !self.isEmpty && self.rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) == nil
    }
    
    func isValidURL() -> Bool {
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        if let match = detector.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count)) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        }
        return false
    }
    
    func isEqual(_ string: String) -> Bool {
        if self == string {
            return true
        }
        return false
    }
    
    func getTextSize(_ font: UIFont, maxWidth: CGFloat? = nil, maxHeight: CGFloat? = nil) -> CGSize {
        let constraintRect = CGSize(width: maxWidth ?? CGFloat.greatestFiniteMagnitude, height: maxHeight ?? CGFloat.greatestFiniteMagnitude)
        let paragraph = NSMutableParagraphStyle()
        paragraph.lineBreakMode = .byWordWrapping
        let boundingBox = self.boundingRect(with: constraintRect, options:
            NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: paragraph], context: nil)
        return boundingBox.size
    }
    
    func isValidString(newString: String, location: Int) -> Bool {
        
        if self.getCharOfIndex(index: location) == newString {
            return false
        } else if self.getCharOfIndex(index: location - 1) == newString {
            return false
        }
        return true
    }
    
    func getCharOfIndex(index: Int) -> String {
        
        if index >= self.length() || index < 0 {
            
            return ""
        }
        
        let nsRange = NSRange(location: index, length: 1)
        let range = self.index(self.startIndex, offsetBy: nsRange.location)..<self.index(self.startIndex, offsetBy: nsRange.location + nsRange.length)
        
        let char = String(self[range])
        return char
    }
    
    func getSpaceCount() -> Int {
        var spaceCount = 0
        for char in self where char == " " {
            spaceCount += 1
        }
        return spaceCount
    }
    
    var htmlToAttributedString: NSAttributedString? {
        guard data(using: .utf8) != nil else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: Data(utf8),
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding: String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    func dataFromHexadecimalString() -> NSData? {
        let trimmedString = self.trimmingCharacters(in: CharacterSet.init(charactersIn: "<>")).replacingOccurrences(of: " ", with: "")
        // make sure the cleaned up string consists solely of hex digits, and that we have even number of them
        let regex = try! NSRegularExpression(pattern: "^[0-9a-f]*$", options: .caseInsensitive)
        let found = regex.firstMatch(in: trimmedString, options: [], range: NSRange(location: 0, length: trimmedString.count))
        if found == nil || found?.range.location == NSNotFound || trimmedString.count % 2 != 0 {
            return nil
        }
        // everything ok, so now let's build NSData
        let data = NSMutableData(capacity: trimmedString.count / 2)
        
        for index in 0 ..< trimmedString.length() {
            let start = String.Index(encodedOffset: index)
            let end = String.Index(encodedOffset: trimmedString.length())
            let byteString = String(trimmedString[start..<end])
            let num = UInt8(byteString.withCString { strtoul($0, nil, 16) })
            data?.append([num] as [UInt8], length: 1)
        }
        return data
    }
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions(rawValue: 0)) else {
            return nil
        }
        
        return String(data: data as Data, encoding: String.Encoding.utf8)
    }
    
    func toBase64() -> String? {
        guard let data = self.data(using: String.Encoding.utf8) else {
            return nil
        }
        
        return data.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
    
    func base64Decoded() -> String? {
        var st = self
        if self.count % 4 <= 2 {
            st += String(repeating: "=", count: (self.count % 4))
        }
        guard let data = Data(base64Encoded: st) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    func grouping(every groupSize: String.IndexDistance, with separator: Character) -> String {
        let cleanedUpCopy = replacingOccurrences(of: String(separator), with: "")
        return String(cleanedUpCopy.enumerated().map {
            $0.offset % groupSize == 0 ? [separator, $0.element] : [$0.element]
        }.joined().dropFirst())
    }
    
    func removingWhitespaces() -> String {
        return components(separatedBy: .whitespaces).joined()
    }
    
    func removingWhiteSpacesWithSpecialCharacters() -> String {
        return removingWhitespaces().components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
    }
    
    func removingPlusCharacter() -> String {
        return replacingOccurrences(of: "+", with: "")
    }
    
    func removingCommanCharacter() -> String {
        return replacingOccurrences(of: ",", with: "")
    }
    
    func removingDashCharacter() -> String {
        return replacingOccurrences(of: "-", with: "")
    }
    
    func replaceDashCharacterTransaction() -> String {
        return replacingOccurrences(of: "_", with: " ")
    }
    
    func removingDashCharacterWithSlash() -> String {
        return replacingOccurrences(of: "-", with: "/")
    }
    
    func dataWithHexString(hex: String) -> Data {
        var hex = hex
        var data = Data()
        while hex.isEmpty {
            let subIndex = hex.index(hex.startIndex, offsetBy: 2)
            let c = String(hex[..<subIndex])
            hex = String(hex[subIndex...])
            var ch: UInt32 = 0
            Scanner(string: c).scanHexInt32(&ch)
            var char = UInt8(ch)
            data.append(&char, count: 1)
        }
        return data
    }
    
    subscript (i: Int) -> Character {
        return self[self.index(self.startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(start, offsetBy: r.upperBound - r.lowerBound)
        return String(self[start..<end])
    }
}

extension String {
    // for localisation
    
    func localized(bundle: Bundle, filename: String = "Localizable") -> String {
        return NSLocalizedString(self, tableName: filename, bundle: bundle, value: "**\(self)**", comment: "")
    }
    //To check text field or String is blank or not
    var isBlank: Bool {
        let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
        return trimmed.isEmpty
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern:
                "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$",
                                                options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: self.count)) != nil
        } catch {
            return false
        }
    }

     //validate PhoneNumber
    var isPhoneNumber: Bool {
        let limit: Int = Config.DEFAULT_MOBILE_LIMIT
        if self.count >= limit && !(self.first == "0") {
            let character  = CharacterSet(charactersIn: "+0123456789 ").inverted
            let inputString = self.components(separatedBy: character)
            let filtered = inputString.joined(separator: "")
            return self == filtered
        }
        return false
    }
    
    var isValidPhoneInputForUpdate: Bool {
        let character  = CharacterSet(charactersIn: "0123456789 ").inverted
        let inputString = self.components(separatedBy: character)
        let filtered = inputString.joined(separator: "")
        return self == filtered
    }
    var isValidPhoneInput: Bool {
        let character  = CharacterSet(charactersIn: "0123456789").inverted
        let inputString = self.components(separatedBy: character)
        let filtered = inputString.joined(separator: "")
        return self == filtered
    }
}
extension String {
    
    func deletingPrefix(_ prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }
        return String(self.dropFirst(prefix.count))
    }
    
    func getCurrencySymbol() -> String {
        let localeGBP = Locale
            .availableIdentifiers
            .lazy
            .map { Locale(identifier: $0) }
            .first { $0.currencyCode == self }
        
        return localeGBP?.currencySymbol ?? self
    }
}

// MARK: - Helper for date format

enum DateFormat: String {
    case ddMMMMyyyyE = "dd MMMM, yyyy, E"
}

extension String {
    func toDate(withDate formate: String) -> Date? {
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = formate
        let date = dateFormate.date(from: self)
        return date
    }

    static func fromDate(
        _ date: Date,
        dateFormat: DateFormat,
        doesRelativeFormatting: Bool = false
    ) -> String {
        if doesRelativeFormatting {
            let relativeFormater = DateFormatter()
            relativeFormater.dateStyle = .medium
            relativeFormater.doesRelativeDateFormatting = true
            let nonRelativeFormatter = DateFormatter()
            nonRelativeFormatter.dateStyle = .medium
            nonRelativeFormatter.doesRelativeDateFormatting = false
            let relativeDate = relativeFormater.string(from: date)
            let nonRelativeDate = nonRelativeFormatter.string(from: date)
            if relativeDate != nonRelativeDate {
                // It is a relative date, i.e. "today" or "yesterday"
                return relativeDate
            }
        }

        let dateFormater = DateFormatter()
        dateFormater.dateFormat = dateFormat.rawValue
        return dateFormater.string(from: date)
    }
}

// MARK: - Helper for showing initial (e.g. "FB" for "Foo Bar")

extension String {
    var initial: String {
        let components = split(separator: " ")
            .map { $0.filter { char in char.isLetter || char.isNumber } }
            .filter { !$0.isEmpty }
        if components.count >= 2 {
            return components.prefix(2).map { $0.prefix(1) }.joined().uppercased()
        } else {
            return String(prefix(2)).uppercased()
        }
    }
}

// MARK: - Helpers for currency

private let currencyFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    formatter.locale = Locale(identifier: "en_SG")
    return formatter
}()

private var currencySymbols: [String: String] {
    [
        "SGD": "S$",
        "USD": "US$",
        "HKD": "HK$"
    ]
}

extension String {
    static func formatCurrency(from amount: Double, currency: String = "SGD") -> Self {
        let formatter = currencyFormatter
        formatter.currencyCode = currency
        formatter.currencySymbol = currencySymbols[currency]
        let sign = amount > 0 ? "+" : "-"
        let amountText = currencyFormatter.string(from: abs(amount) as NSNumber) ?? ""
        return "\(sign) \(amountText)"
    }
    
    static func formatAmountToCurrencyString(amount: Float?) -> Self {
        guard let floatAmount = amount else {
            return K.defaultAmountString
        }
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        let fomatedAmount = numberFormatter.string(from: NSNumber(value: floatAmount))
        return "S$\(fomatedAmount ?? K.defaultAmountString)"
    }
}

enum CurrencyAttributedStyle {
    case primaryBackground, lightBackground

    fileprivate var currencySymbolAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .primaryBackground:
            return [
                .font: UIFont.boldFontWithSize(size: 22),
                .foregroundColor: UIColor.themeDarkBlueTint2
            ]
        case .lightBackground:
            return [
                .font: UIFont.boldFontWithSize(size: 16),
                .foregroundColor: UIColor.themeDarkBlue
            ]
        }
    }

    fileprivate var currencyAmountAttributes: [NSAttributedString.Key: Any] {
        switch self {
        case .primaryBackground:
            return [
                .font: UIFont.boldFontWithSize(size: 38),
                .foregroundColor: UIColor.themeNeonBlue
            ]
        case .lightBackground:
            return [
                .font: UIFont.boldFontWithSize(size: 28),
                .foregroundColor: UIColor.themeDarkBlue
            ]
        }
    }
}

extension NSAttributedString {
    static func currencyFormat(
        from amount: Double,
        currency: String = "SGD",
        showPositiveIndicator: Bool = false,
        style: CurrencyAttributedStyle = .primaryBackground
    ) -> NSAttributedString {
        let resultString = NSMutableAttributedString()
        let sign = showPositiveIndicator ? (amount < 0 ? "- " : "+ ") : ""
        resultString.append(NSAttributedString(
            string: "\(sign)\(currencySymbols[currency] ?? "")",
            attributes: style.currencySymbolAttributes
        ))
        let formatter = currencyFormatter
        formatter.currencySymbol = ""
        resultString.append(NSAttributedString(
            string: currencyFormatter.string(from: abs(amount) as NSNumber) ?? "",
            attributes: style.currencyAmountAttributes
        ))
        return resultString
    }
}

// MARK: - Collections Helper

extension Collection {
    var pairs: [SubSequence] {
        var startIndex = self.startIndex
        let count = self.count
        let n = count/2 + count % 2
        return (0..<n).map { _ in
            let endIndex = index(startIndex, offsetBy: 2, limitedBy: self.endIndex) ?? self.endIndex
            defer { startIndex = endIndex }
            return self[startIndex..<endIndex]
        }
    }
}

extension Collection {
    func distance(to index: Index) -> Int { distance(from: startIndex, to: index) }
}

// MARK: - String insertions

extension StringProtocol where Self: RangeReplaceableCollection {
    mutating func insert<S: StringProtocol>(separator: S, every n: Int) {
        for index in indices.dropFirst().reversed()
            where distance(to: index).isMultiple(of: n) {
                insert(contentsOf: separator, at: index)
        }
    }
    func inserting<S: StringProtocol>(separator: S, every n: Int) -> Self {
        var string = self
        string.insert(separator: separator, every: n)
        return string
    }
}
