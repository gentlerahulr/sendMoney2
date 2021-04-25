//
//  TopUpQRCodeViewController.swift
//  SBC
//

import UIKit

class TopUpQRCodeViewController: BaseViewController {
    
    var viewModel: TopUpQRCodeViewModelProtocol?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var topConstraints: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func setupViewModel() {
        viewModel  = TopUpQRCodeViewModel()
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
}

// MARK: - Setup Methods
extension TopUpQRCodeViewController {
    func setupViews() {
        
    }
}

// MARK: - Action Methods
extension TopUpQRCodeViewController {
    @objc func refenceCodeInfoButtonPressed(sender: UIButton) {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        cell.toolTipMessageLabel.isHidden = false
        cell.toolTipBackgroundImageView.isHidden = false
    }
    
    @objc func uenCopyButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        copied(content: cell.uenValueLabel.text ?? "")
        AlertViewAdapter.shared.show(localizedStringForKey(key: "top.up.uen.copy.message"), state: .success)
    }
    
    @objc func amountCopyButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        copied(content: cell.amountLabel.text ?? "")
        AlertViewAdapter.shared.show(localizedStringForKey(key: "top.up.amount.copy.message"), state: .success)
    }
    
    @objc func refenceCodeCopyButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        copied(content: cell.referanceCodeLabel.text ?? "")
        AlertViewAdapter.shared.show(localizedStringForKey(key: "top.up.reference.code.copy.message"), state: .success)
        
    }
    
    @objc func downloadQRCodeButtonPressed() {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        if let img = cell.QRCodeImageView.image {
            DispatchQueue.main.async { [self] in
                UIImageWriteToSavedPhotosAlbum(img, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            }
        }
    }
    
    @objc func backToWalletButtonPressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            AlertViewAdapter.shared.show(localizedStringForKey(key: "Image_SAVE_FAILED"), state: .failure)
        } else {
            AlertViewAdapter.shared.show(localizedStringForKey(key: "Image_SAVED"), state: .success)
            
        }
    }
}

// MARK: - Custom Methods
extension TopUpQRCodeViewController {
    
}

// MARK: - TableView Delegate and Datasource Methods
extension TopUpQRCodeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("TopUpQRCodeTableViewCell", owner: self, options: nil)?.first as! TopUpQRCodeTableViewCell
        if let paymentArr = viewModel?.topUPQrResponse?.paymentMethods, paymentArr.count > 1 {
            cell.uenValueLabel.text = paymentArr[2].uen
            if let image = paymentArr[1].qrCode {
                
                cell.setData(QRCodeString: image)
            } else {
                cell.imageView?.image = UIImage(named: "placeholderQRCode")
            }
        } else {
            AlertViewAdapter.shared.show(localizedStringForKey(key: "top.up.QRFailed.error.message"), state: .failure)
        }
        let amount = viewModel?.topUPQrResponse?.destinationAmount
        let formatedAmount = String(format: "%.2f", amount ?? "")
        cell.amountLabel.text = "$\(formatedAmount)"
        cell.referanceCodeLabel.text = viewModel?.topUPQrResponse?.systemReferenceNumber
        cell.uenCopyButton.addTarget(self, action: #selector(uenCopyButtonPressed), for: .touchUpInside)
        cell.referenceCodeToolTipButton.addTarget(self, action: #selector(refenceCodeInfoButtonPressed(sender:)), for: .touchUpInside)
        cell.referenceCodeCopyButton.addTarget(self, action: #selector(refenceCodeCopyButtonPressed), for: .touchUpInside)
        cell.amountCopyButton.addTarget(self, action: #selector(amountCopyButtonPressed), for: .touchUpInside)
        cell.downloadQRcodeButton.addTarget(self, action: #selector(downloadQRCodeButtonPressed), for: .touchUpInside)
        cell.backToWalletButton.addTarget(self, action: #selector(backToWalletButtonPressed), for: .touchUpInside)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: IndexPath.init(row: 0, section: 0)) as? TopUpQRCodeTableViewCell else {return}
        cell.toolTipMessageLabel.isHidden = true
        cell.toolTipBackgroundImageView.isHidden = true
    }
}
