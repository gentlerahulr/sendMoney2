//
//  TopUpAmount+Tableview.swift
//  SBC
//

import Foundation
import UIKit

extension TopUpAmountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 2 ? self.numberOfRowsForSavedCards() : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath) as! AmountCell
            cell.transactionType = .topup
            cell.delegate = self
            cell.targetAmount = UserDefaults.standard.maxWalletAmount
            if let getbalanceAmount = viewModel?.getBalanceAmount {
                cell.balanceAmount = getbalanceAmount
            }
            return cell
            
        } else if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TopUpMethodCell", for: indexPath) as! TopUpMethodCell
            cell.delegate = self
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedItemCell", for: indexPath) as! SavedItemCell
            cell.delegate = self
            cell.buttonDelete.tag = indexPath.row
            cell.transactionType = .topup
            cell.textFieldCVV.text = ""
            let card = (indexPath.row >= (self.viewModel?.savedItems.count ?? 0) ? nil : self.viewModel?.savedItems[indexPath.row])
            cell.bankCard = card
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        viewHeader.backgroundColor = self.view.backgroundColor
        let labelHeader = UILabel(frame: CGRect(x: 28, y: 19, width: tableView.frame.width - 56, height: 19))
        labelHeader.font = .regularFontWithSize(size: 14)
        labelHeader.textColor = .themeDarkBlueTint1
        labelHeader.text = section == 0 ? "" : (section == 1 ? localizedStringForKey(key: "TOP_METHOD") : (self.numberOfRowsForSavedCards() == 0 ? "" : localizedStringForKey(key: "SELECT_CARD")))
        viewHeader.addSubview(labelHeader)
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 44
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if selectedCellIndexPath != indexPath, indexPath.section == 2, let cell = tableView.cellForRow(at: indexPath) as? SavedItemCell {
            cell.textFieldCVV.text = ""
            cell.labelErrorCVV.isHidden = true
            self.viewModel?.securityCode = nil
            updateNextButton()
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) as? SavedItemCell else {
            return
        }
        guard cell.bankCard != self.viewModel?.selectedSource else {
            self.updateCardList()
            return
        }
        self.viewModel?.selectedSource = cell.bankCard
        self.updateCardList()
    }
}
