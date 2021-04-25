//
//  TopUpQRCodeViewModel.swift
//  SBC
//

import Foundation
import UIKit

protocol TopUpQRCodeViewModelProtocol {
    var topUPQrResponse: TopUpRequestResponse? {get set}
}

class TopUpQRCodeViewModel: TopUpQRCodeViewModelProtocol {
    var topUPQrResponse: TopUpRequestResponse?
}
