//
//  TopUpAmount+Tableview.swift
//  SBC
//

import Foundation
import UIKit

extension WithdrawAmountViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 1 ? self.numberOfRowsForSavedBeneficiary() : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "AmountCell", for: indexPath) as! AmountCell
            cell.transactionType = .withdraw
            cell.delegate = self
            if let getbalanceAmount = viewModel?.getBalanceAmount {
                cell.balanceAmount = getbalanceAmount
                cell.targetAmount = Float(getbalanceAmount)
            }
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SavedItemCell", for: indexPath) as! SavedItemCell
            cell.delegate = self
            cell.buttonDelete.tag = indexPath.row
            cell.transactionType = .withdraw
            cell.textFieldCVV.text = ""
            cell.bankAccount = (indexPath.row >= (self.viewModel?.savedItems.count ?? 0) ? nil : self.viewModel?.savedItems[indexPath.row])
            
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 35))
        viewHeader.backgroundColor = self.view.backgroundColor
        let labelHeader = UILabel(frame: CGRect(x: 28, y: 19, width: tableView.frame.width - 56, height: 19))
        labelHeader.font = .regularFontWithSize(size: 14)
        labelHeader.textColor = .themeDarkBlueTint1
        labelHeader.text = section == 0 ? "" : (self.numberOfRowsForSavedBeneficiary() == 0 ? "" : localizedStringForKey(key: "SELECT_ACCOUNT"))
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
        if indexPath.section == 1 {
            return indexPath
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCellIndexPath = indexPath
        guard let cell = tableView.cellForRow(at: indexPath) as? SavedItemCell else {
            return
        }
        guard cell.bankAccount != self.viewModel?.selectedSource else {
            self.updateBeneFiciaryList()
            return
        }
        self.viewModel?.selectedSource = cell.bankAccount
        self.updateBeneFiciaryList()
    }
}
