//
//  TopUpViewModel.swift
//  SBC
//

import Foundation
import UIKit

struct TopUpRequest {
    let amount: Float
    let source: BankCard?
    let method: TopUpMethod
}

protocol TopUpPassingDelegate: AnyObject {
    func showSavedCards(response: SavedCardResponse)
}

protocol TopUpViewModelProtocol {
    var delegate: TopUpPassingDelegate? { get set }
    var getBalanceAmount: Double? { get set }
    var amount: Float { get set }
    var formattedAmount: String? { get set }
    var selectedMethod: TopUpMethod { get set }
    var selectedSource: BankCard? { get set }
    var savedItems: [BankCard] { get set }
    var suggestedAmount: [String] { get set }
    var securityCode: Int? { get set }
    var topupRequest: TopUpRequest { get }
    
    func fetchSavedCards()
}

class TopUpViewModel: TopUpViewModelProtocol {
    
    var topupRequest: TopUpRequest {
        return TopUpRequest(amount: self.amount, source: self.selectedSource, method: self.selectedMethod)
    }
    
    var getBalanceAmount: Double?
    
    var amount: Float = 0.0
    
    var formattedAmount: String?
    
    var selectedMethod: TopUpMethod = .pay_now
    
    var securityCode: Int?
    
    var selectedSource: BankCard?
    
    var savedItems: [BankCard] = []
    
    var suggestedAmount: [String] = []
    
    weak var delegate: TopUpPassingDelegate?
 
    var topupManager = TopUpManager(dataStore: APIStore.instance)
    
    func fetchSavedCards() {
        
        topupManager.performGetSavedCardList(customerHASHID: CommonUtil.customerHashID) { (result) in
            
            switch result {
            case .success(let response):
                self.savedItems.removeAll()
                self.savedItems = response
                
            case .failure (let error):
                self.savedItems.removeAll()
            }
            self.delegate?.showSavedCards(response: self.savedItems)
        }
    }

    func removeSavedItem(item: BankCard) {
        
    }
    
    func fetchAmountSuggestion() {
        
    }

}
