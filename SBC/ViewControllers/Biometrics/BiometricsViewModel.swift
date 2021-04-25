import Foundation
import LocalAuthentication

enum ButtonState {
    case on
    case off
}

struct BiometricsModel {
    var textDesc: String?
    var textTouchId: String?
    var textFaceId: String?
    var btnTouchIdState: ButtonState?
    var btnFaceIdState: ButtonState?
}

protocol BiometricsDataPassingDelegate: AnyObject {
    func performBiometricsSuccessAction()
    func performBiometricsFailureAction(message: String)
}

protocol BiometricsViewModelProtocol: AnyObject {
    var delegate: BiometricsDataPassingDelegate? { get set }
    var lblDescConfig: LabelConfig? { get set }
    var lblTouchIdConfig: LabelConfig? { get set }
    var lblFaceIdConfig: LabelConfig? { get set }
    var btnContinueConfig: ButtonConfig? { get set }
    var isTouchIdAvailable: Bool { get }
    var isFaceIdAvailable: Bool { get }
    func callBiometricsStatus()
}

class BiometricsViewModel: BiometricsViewModelProtocol {
   
    // MARK: - UI Config
    var lblDescConfig: LabelConfig? = LabelConfig.getRegularLabelConfig(text: Text.lblDescText, fontSize: 16, textColor: .white, textAlignment: .center)
    var lblTouchIdConfig: LabelConfig? = LabelConfig.getRegularLabelConfig(text: Text.lblTouchIdText, fontSize: 16, textColor: .white)
    var lblFaceIdConfig: LabelConfig? = LabelConfig.getRegularLabelConfig(text: Text.lblFaceIdText, fontSize: 16, textColor: .white)
    var btnContinueConfig: ButtonConfig? = ButtonConfig.getBackgroundButtonConfig(titleText: Text.btnContinueText, fontSize: 16, textColor: .themeDarkBlue, backgroundColor: .themeNeonBlue, cornerRadius: 8)
    
   // MARK: - Properties
    weak var delegate: BiometricsDataPassingDelegate?
    let walletManager = WalletManager(dataStore: APIStore.instance)
    var isFaceIdAvailable: Bool {
        let currentType = LAContext().biometricType
        return (currentType == LAContext.BiometricType.faceID)
    }
    
    var isTouchIdAvailable: Bool {
        let currentType = LAContext().biometricType
        return (currentType == LAContext.BiometricType.touchID)
    }
    
    struct Text {
        static let lblDescText = localizedStringForKey(key: "biometrics_label_desc")
        static let lblTouchIdText = localizedStringForKey(key: "biometrics_label_touchId")
        static let lblFaceIdText = localizedStringForKey(key: "biometrics_label_faceId")
        static let btnContinueText = localizedStringForKey(key: "biometrics_btn_continue")
    }
    
    func callBiometricsStatus() {
        delegate?.performBiometricsSuccessAction()
    }
}
