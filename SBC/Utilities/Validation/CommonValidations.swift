//Common validations
import Foundation
import UIKit

enum TransactionAmountStatus {
    case valid
    case min_balance_error
    case max_balance_error
}

class CommonValidation {
    static let defaults = UserDefaults.standard
    /**
     Validates Email
     - parameter emailString: the email to be validated
     */
    static func isValidEmail(_ emailString: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailString)
    }
    
    /**
     Validates Password
     - parameter passwordString: the email to be validated
     */
    static func isvalidPassword(_ passwordString: String) -> Bool {
         let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{6,}$")
           return passwordTest.evaluate(with: passwordString)
    }
    
    /**
     Validates TopUp Amount
     - parameter amountString: the amount to be validated
     - parameter targetAmount: the amount to be compared
     */
    static func isValidTransactionAmount(_ amount: Float, targetAmount: Float) -> TransactionAmountStatus {
        if amount < defaults.minWalletAmount {
            return .min_balance_error
        } else if amount > targetAmount {
            return .max_balance_error
        }
        return .valid
    }
    
    /**
     Validates Bank Account number
     - parameter numberString: the ccount number to be validated
     */
    
    static func isValidFullName(_ nameString: String) -> Bool {
        let fullNameRegex = "^((?:[A-Za-z]+ ?){1,3})$"
        let predicate = NSPredicate(format: "SELF MATCHES %@", fullNameRegex)
        return predicate.evaluate(with: nameString) && nameString.length() <= 24 && nameString.getSpaceCount() < 3
    }
    
    static func validatePattern(value: String, regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: value)
    }
    
    static func isValidCardNumber(_ numberString: String) -> Bool {
        
        return numberString.removingWhitespaces().length() == 16
    }
    
    static func isValidInputForCardNumber(_ numberString: String) -> Bool {
        return numberString.removingWhitespaces().length() <= 16 && K.allowedFirstCharacterForCardNumberArray.contains("\(numberString.first ?? Character(""))") 
    }
    
    static func isValidExpiryDate(_ dateString: String) -> Bool {
        
        if dateString.count < 5 {
            return false
        }
        let currentYear = Calendar.current.component(.year, from: Date()) % 100   // This will give you current year (i.e. if 2019 then it will be 19)
        let currentMonth = Calendar.current.component(.month, from: Date()) // This will give you current month (i.e if June then it will be 6)
        
        let enteredYear = Int(dateString.suffix(2)) ?? 0 // get last two digit from entered string as year
        let enteredMonth = Int(dateString.prefix(2)) ?? 0 // get first two digit from entered string as month
        
        if enteredYear > currentYear {
            if (1 ... 12).contains(enteredMonth) {
                return true
            } else {
                return false
            }
        } else if currentYear == enteredYear {
            if enteredMonth >= currentMonth {
                if (1 ... 12).contains(enteredMonth) {
                    return true
                } else {
                    return false
                }
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
}
