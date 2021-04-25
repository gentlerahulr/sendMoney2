//
//  BankAccountViewModel.swift
//  SBC
//

import Foundation

protocol BankAccountPassingDelegate: AnyObject {
    func addBeneficiarySucces(response: AddBenificiaryResponse)
    func failure(message: String)
    func transfermoneySucces(response: TransferMoneyResponse)
    func transfermoneyfailure(message: String)
    func showBankNameListResponse(response: SearchBankResponse)
    func showBankNameListFailure(message: String)
    func exchangeRateSucces(response: ExchangeRateResponse)
}

protocol BankAccountViewModelProtocol {
    var delegate: BankAccountPassingDelegate? { get set }
    var request: WithdrawRequest? { get set }
    var bankList: [Bank] { get set }
    var accountTypeList: [String] { get }
    var selectedBank: Bank? { get set }
    var beneDetailValidator: BeneDetailValidator { get set }
    func getBankNameList() -> [String]
    func performSearchBank(by searchString: String?)
    func performAddBenificiary(request: AddBenificiaryRequest)
    func getExchangeRate()
    func transferMoney(request: TransferMoneyRequest)
    var addBenificiaryResponse: AddBenificiaryResponse? { get set }
    var exchangeRateResponse: ExchangeRateResponse? { get set }
    func callValidateSchema()
}

struct ValidationBeneSchemaKeys {
    static let name = "beneficiary_name"
    static let account_type = "beneficiary_bank_account_type"
    static let account_number = "beneficiary_account_number"
    static let bank_name = "beneficiary_bank_name"
}

class BankAccountViewModel: BankAccountViewModelProtocol {
    var exchangeRateResponse: ExchangeRateResponse?
    var addBenificiaryResponse: AddBenificiaryResponse?

    var bankList: [Bank] = []
    var request: WithdrawRequest?
    
    var beneDetailValidator: BeneDetailValidator = BeneDetailValidator()
    weak var delegate: BankAccountPassingDelegate?
    var withdrawManager = WithDrawManager(dataStore: APIStore.instance)
    
    var validationBeneSchema: ValidationBeneSchema?
    var selectedBank: Bank?
    private var validationSchemaProperties: [String: ValidationBeneSchemaProperty]? {
        return validationBeneSchema?.data.first?.properties
    }
    var accountTypeList: [String] {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.account_type]
        return property?.propertyEnum ?? []
    }
    
    func getBankNameList() -> [String] {
        self.bankList.map { (bank) -> String in
            return bank.bankName
        }
    }
    
    func performSearchBank(by searchString: String?) {
        let request = SearchBankRequest(search_value: searchString ?? "")
    
        withdrawManager.performSeachBank(request: request) { (result) in
            switch result {
            case .success(let response):
                self.bankList.removeAll()
                self.bankList = response.data
                self.delegate?.showBankNameListResponse(response: response)
            case .failure (let error):
                self.bankList.removeAll()
                self.delegate?.showBankNameListFailure(message: error.localizedDescription)
                print(error)
            }
        }
    }
    
    func performAddBenificiary(request: AddBenificiaryRequest) {
        CommonUtil.sharedInstance.showLoader()
        withdrawManager.performAddBenificiary(request: request) { (result) in
            switch result {
            case .success(let response):
                self.addBenificiaryResponse = response
                self.delegate?.addBeneficiarySucces(response: response)
            case .failure (let error):
                CommonUtil.sharedInstance.removeLoader()
                self.delegate?.failure(message: error.localizedDescription)
                print(error)
            }
        }
    }
    
    func getExchangeRate() {
        withdrawManager.perfromExchangeRate(comletion: { result in
            switch result {
            case .success(let response):
                self.exchangeRateResponse = response
                self.delegate?.exchangeRateSucces(response: response)
            case .failure (let error):
                CommonUtil.sharedInstance.removeLoader()
                self.delegate?.failure(message: error.localizedDescription)
                print(error)
            }
        })
    }
    
    func transferMoney(request: TransferMoneyRequest) {
        withdrawManager.performTransferMoney(request: request) { (result) in
            CommonUtil.sharedInstance.removeLoader()
            switch result {
            case .success(let response):
                self.delegate?.transfermoneySucces(response: response)
            case .failure (let error):
                CommonUtil.sharedInstance.removeLoader()
                self.delegate?.transfermoneyfailure(message: error.localizedDescription)
                print(error)
            }
        }
    }
    
    func callValidateSchema() {
        withdrawManager.performValidateSchema { (result: Result<ValidationBeneSchema, APIError>) in
            switch result {
            case .success(let response):
                self.validationBeneSchema = response
                self.beneDetailValidator.validationBeneSchema = response
            case .failure( let error):
                self.delegate?.failure(message: error.localizedDescription)
            }
        }
    }
}

struct BeneDetailValidator {
    var validationBeneSchema: ValidationBeneSchema?
    
    private var validationSchemaProperties: [String: ValidationBeneSchemaProperty]? {
        return validationBeneSchema?.data.first?.properties
    }
    
    var accountNumberRegex: String {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.account_number]
        return property?.pattern ?? "^\\d{1,34}$"
    }
    
    var beneNameRegex: String {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.name]
        return property?.pattern ?? "^[A-Za-z0-9-?:().,'+\\s\\/]{1,140}$"
    }
    
    var accountNumberErrorMessage: String {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.account_number]
        return property?.errorMessage ?? ""
    }
    
    var beneNameErrorMessage: String {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.name]
        return property?.errorMessage ?? ""
    }
    
    var bankNameErrorMessage: String {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.bank_name]
        return property?.errorMessage ?? ""
    }
    
    func isValidAccountNumber(value: String) -> Bool {
        return CommonValidation.validatePattern(value: value, regex: accountNumberRegex)
    }
    
    func isValidBeneFullName(value: String) -> Bool {
        return CommonValidation.validatePattern(value: value, regex: beneNameRegex)
    }
    
    func isValidBankName(value: String) -> Bool {
        let property = validationSchemaProperties?[ValidationBeneSchemaKeys.bank_name]
        let length = property?.maxLength ?? 255
        return value.length() < length
    }
}
