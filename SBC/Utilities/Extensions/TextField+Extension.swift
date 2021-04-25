//
//  TextFieldExtension.swift
//  SBC
//

import Foundation
import UIKit

extension UITextField {
    
    // MARK: Card number formatting
    open func reformatAsCardNumber() {
        // In order to make the cursor end up positioned correctly, we need to
        // explicitly reposition it after we inject spaces into the text.
        // targetCursorPosition keeps track of where the cursor needs to end up as
        // we modify the string, and at the end we set the cursor position to it.
        guard let selectedRange = self.selectedTextRange, let textString = self.text else { return }
        var targetCursorPosition = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        
        let cardNumberWithoutSpaces = removeNonDigits(textString, cursorPosition: &targetCursorPosition)
        
        /*
        if cardNumberWithoutSpaces.count > 19 {
            // If the user is trying to enter more than maxCreditCardNumberLength digits, we prevent
            // their change, leaving the text field in its previous state.
            self.text = cardNumberWithoutSpaces[0..<19]
            self.selectedTextRange = previousSelection
            return
        }
        */
        
        let cardNumberWithSpaces = insertSpacesEveryFourDigits(cardNumberWithoutSpaces, cursorPosition: &targetCursorPosition)
        
        // update text and cursor appropiately
        self.text = cardNumberWithSpaces
        if let targetPosition = self.position(from: self.beginningOfDocument, offset: targetCursorPosition) {
            self.selectedTextRange = self.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    /**
     Removes non-digits from the string, decrementing `cursorPosition` as
     appropriate so that, for instance, if we pass in `@"1111 1123 1111"`
     and a cursor position of `8`, the cursor position will be changed to
     `7` (keeping it between the '2' and the '3' after the spaces are removed).
     */
    
    open func removeNonDigits(_ string: String, cursorPosition: inout Int) -> String {
        let originalCursorPosition = cursorPosition
        var digitsOnlyString = ""
        for i in 0..<string.count {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if "0"..."9" ~= characterToAdd {
                digitsOnlyString.append(characterToAdd)
            } else {
                if i < originalCursorPosition {
                    cursorPosition -= 1
                }
            }
        }
        
        return digitsOnlyString
        
    }
    
    /**
     Inserts spaces into the string to format it as a credit card number,
     incrementing `cursorPosition` as appropriate so that, for instance, if we
     pass in `@"111111231111"` and a cursor position of `7`, the cursor position
     will be changed to `8` (keeping it between the '2' and the '3' after the
     spaces are added).
     */
    open func insertSpacesEveryFourDigits(_ string: String, cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        for i in 0..<string.count {
            if (i>0) && ((i % 4) == 0) {
                stringWithAddedSpaces += " "
                if i < cursorPositionInSpacelessString {
                    cursorPosition += " ".count
                }
            }
            stringWithAddedSpaces.append(string[string.index(string.startIndex, offsetBy: i)])
        }
        
        return stringWithAddedSpaces
    }
    
    // MARK: Expiration date formatting
    open func reformatAsExpiration() {
        guard let string = self.text else { return }
        let cleanString = string.replacingOccurrences(of: "/", with: "", options: .literal, range: nil)
        if cleanString.count < 2 {
            self.text = cleanString
        }
        if string.count > 2 && !string.contains("/") {
            let monthString = cleanString[Range(0...1)]
            var yearString: String
            if cleanString.count == 3 {
                yearString = cleanString[2]
            } else {
                yearString = cleanString[Range(2...3)]
            }
            self.text = monthString + "/" + yearString
            return
        }
        
        if string.count == 2 && !string.contains("/") {
            self.text = string.appending("/")
        }
    }
    
    // MARK: CVV formatting
    open func reformatAsCVV() {
        guard let string = self.text else { return }
        if string.count > 3 {
            self.text = string[0..<3]
        }
    }
    
    open func reformateAsFloatAmount(maximumFractionDigits: Int, onEndEditing: Bool) -> Float {
        
        let string = self.removeCommas()
        
        if string.contains(".") {
            let groupsByZero = string.split(separator: ".")

            if groupsByZero.count > 1 {

                if let count = groupsByZero.last?.count, count > maximumFractionDigits {
                    
                    let firstDigits = NSNumber(value: (string as NSString).floatValue)
                    let numberFormatter = NumberFormatter()
                    numberFormatter.numberStyle = .decimal
                    numberFormatter.maximumFractionDigits = maximumFractionDigits
                    if onEndEditing {
                        numberFormatter.minimumFractionDigits = 2
                    }
                    
                    if let formattedNumber = numberFormatter.string(from: firstDigits) {
                        
                        self.text = firstDigits != 0 ? ( formattedNumber.contains(".") ? formattedNumber : "\(formattedNumber).00" ) : K.defaultAmountString
                    }
                }
            } else {
                let firstDigits = NSNumber(value: (string as NSString).integerValue)
                let numberFormatter = NumberFormatter()
                numberFormatter.numberStyle = .decimal
                if onEndEditing {
                    numberFormatter.minimumFractionDigits = 2
                }
                
                let formattedNumber = numberFormatter.string(from: firstDigits)
                
                self.text = onEndEditing ? formattedNumber : ( formattedNumber == "0" ? "0." : "\(formattedNumber ?? "").")
            }
            
        } else {

            let firstDigits = NSNumber(value: (string as NSString).integerValue)
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if onEndEditing {
                numberFormatter.minimumFractionDigits = 2
            }
            
            let formattedNumber = numberFormatter.string(from: firstDigits)
            
            if onEndEditing == false && string == "" {
                self.text = string
            } else {
                self.text = firstDigits == 0 ? (string == "" ? K.defaultAmountString : string) : formattedNumber
            }
        }
        
        return (self.removeCommas() as NSString).floatValue
    }
    
    open func removeCommas() -> String {
        return (self.text ?? "").replacingOccurrences(of: ",", with: "")
    }
    
    func getText() -> String {
        return self.text ?? ""
    }
}
