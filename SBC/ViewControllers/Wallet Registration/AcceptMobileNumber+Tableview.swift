//
//  WalletRegistartionExtension+Tableview.swift
//  SBC
//

import Foundation
import UIKit

extension AcceptMobileNumberViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrayOfCells.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellType = self.viewModel.arrayOfCells[indexPath.row]
        
        switch cellType {
            
        case .cellTittle:
            let cell =  tableView.dequeueReusableCell(withIdentifier: "TittleCell", for: indexPath) as! TittleWithDescriptionTableViewCell
            cell.configureAcceptMobileNumberCell(title: viewModel.acceptMobileNumberModel?.title ?? "", desc: viewModel.acceptMobileNumberModel?.desc ?? "")
            return cell
            
        case .cellMobileNo:
            let cell = tableView.dequeueReusableCell(withIdentifier: "mobileCell", for: indexPath) as! TextfieldTableViewCell
            cell.backgroundColor = UIColor.clear
            cell.contentView.backgroundColor = .clear
            var config = TextfieldTableViewCellConfig()
            if viewModel.acceptMobileNumberModel?.title == localizedStringForKey(key: "forgot.pin.title") || viewModel.acceptMobileNumberModel?.title == K.EMPTY {
                config.placeHolder = localizedStringForKey(key: "YOUR_MOBILE_NUMBER")
            } else {
                config.placeHolder = localizedStringForKey(key: "MOBILE_NUMBER")
            }
           
            config.backgroundColor = UIColor.clear
            config.insets = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
            cell.configureCell(config: config)
            self.addActionsForMobileField(txtMobileNumber: cell.textfield)
            cell.contentView.backgroundColor = .clear
            txtMobile = cell.textfield
            txtMobile?.textfield.clearsOnBeginEditing = false
            cell.textfield.textfield.keyboardType = UIKeyboardType.numberPad
            cell.textfield.textfield.borderStyle = .none
            switch self.viewModel.validationStateMobile {
            case .valid:
                break
            case .inValid(let error):
                txtMobile.setState(state: CustomTextfieldView.FieldState.error)
                txtMobile.configureError(error: error)
                break
            }
            cell.selectionStyle = UITableViewCell.SelectionStyle.none
            return cell
            
        case .cellProceddBtn:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCell", for: indexPath) as? ButtonTableViewCell  else {
                fatalError("The dequeued cell is not an instance of ButtonTableViewCell.")
            }
            if self.btnNext == nil {
                self.btnNext = cell.btnAction
                self.btnNext.isEnabled = false
            }
            
            if self.btnNext.isEnabled {
                let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 30, left: 20, bottom: 10, right: 20),
                                                                 buttonBackgroundColor: .themeDarkBlue, buttonTextColor: UIColor.white,
                                                                 buttonFont: AppManager.appStyle.font(for: .primaryActionButton),
                                                                 borderColor: UIColor.clear, borderWidth: 0, cornerRadius: 8.0,
                                                                 enabledButton: true)
                cell.configureViewModel(model: vmForButton)
            } else {
                let vmForButton = ButtonTableViewCellConfig.init(inset: UIEdgeInsets.init(top: 30, left: 20, bottom: 10, right: 20),
                                                                 buttonBackgroundColor: .themeDarkBlueTint2,
                                                                 buttonTextColor: .themeDarkBlueTint1,
                                                                 buttonFont: .boldFontWithSize(size: 16), borderColor: UIColor.clear,
                                                                 borderWidth: 0, cornerRadius: 8.0, enabledButton: false)
                cell.configureViewModel(model: vmForButton)
                cell.btnAction.isEnabled = false
            }
            
            let title = viewModel.acceptMobileNumberModel?.buttonText
            cell.btnAction.titleLabel?.text = title
            cell.btnAction.addTarget(self, action: #selector(didTappedNextButtonAction(_ :)), for: UIControl.Event.touchUpInside)
            cell.configure(title: title)
            cell.selectionStyle = .none
            cell.contentView.backgroundColor = UIColor.clear
            return cell
        default:
            return UITableViewCell()
        }
        
    }
}
