//
//  WithdrawViewModel.swift
//  SBC
//

import Foundation
import UIKit

struct WithdrawRequest {
    let amount: Float
    let source: Beneficiary?
}

protocol WithdrawPassingDelegate: AnyObject {
    func showSavedBeneficiary(response: SavedBeneficiaryResponse)
}

protocol WithdrawViewModelProtocol {
    var delegate: WithdrawPassingDelegate? { get set }
    var getBalanceAmount: Double? { get set }
    var amount: Float { get set }
    var formattedAmount: String? { get set }
    var selectedSource: Beneficiary? { get set }
    var savedItems: [Beneficiary] { get set }
    var suggestedAmount: [String] { get set }
    var withdrawRequest: WithdrawRequest { get }
    
    func fetchSavedBeneficiaryList()
}

class WithdrawViewModel: WithdrawViewModelProtocol {
    
    var withdrawRequest: WithdrawRequest {
        return WithdrawRequest(amount: self.amount, source: self.selectedSource)
    }
    
    var getBalanceAmount: Double?
    
    var amount: Float = 0.0
    
    var formattedAmount: String?
    
    var selectedSource: Beneficiary?
    
    var savedItems: [Beneficiary] = []
    
    var suggestedAmount: [String] = []
    
    weak var delegate: WithdrawPassingDelegate?
 
    var withdrawManager = WithDrawManager(dataStore: APIStore.instance)
    
    func fetchSavedBeneficiaryList() {
        withdrawManager.performGetBenifiCiaryList { (result) in
            switch result {
            case .success(let response):
                self.savedItems.removeAll()
                self.savedItems = response
                
            case .failure (let error):
                self.savedItems.removeAll()
            }
            
            self.delegate?.showSavedBeneficiary(response: self.savedItems)
        }
    }

    func removeSavedItem(item: Beneficiary) {
        
    }
    
    func fetchAmountSuggestion() {
        
    }

}
