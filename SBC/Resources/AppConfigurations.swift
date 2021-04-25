//
//  AppConfigurations.swift
//  SBC
//

import Foundation

var appConfig: ColorResponceDTO? {
    return AppConfigurations().config
}

class AppConfigurations {
    static let sharedIntance = AppConfigurations()
    var config: ColorResponceDTO?
    init() {
        setConfig()
    }
    private func setConfig() {
        JsonHelper.getJsonData(fileName: "config.json") { (result: Result<ColorResponceDTO, Error>)  in
            switch result {
            case .success(let model):
                self.config = model
            case .failure:
                self.config = nil
            }
        }
    }
}
