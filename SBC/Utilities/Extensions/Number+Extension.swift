//
//  Number+Extension.swift
//  SBC

import Foundation

extension Float {
    
    func getDecimalGroupedAmount() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? K.defaultAmountString
        
    }
}

extension Double {
    
    func getDecimalGroupedAmount() -> String {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.minimumFractionDigits = 2
        return numberFormatter.string(from: NSNumber(value: self)) ?? K.defaultAmountString
        
    }
}
