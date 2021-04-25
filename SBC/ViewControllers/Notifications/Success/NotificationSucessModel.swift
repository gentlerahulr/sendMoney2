import Foundation

struct NotificationSuccessModel {
    let titleText: String
    let successButtonText: String
}

protocol NotificationSuccessVieweModelProtocol {
    var dataModel: NotificationSuccessModel? { get set }
    var labelTitleConfig: LabelConfig { get  }
    var buttonSuccessConfig: ButtonConfig { get }
}
class NotificationSuccessViewModel: NotificationSuccessVieweModelProtocol {
    
    var dataModel: NotificationSuccessModel?
    
    var labelTitleConfig: LabelConfig {
        return LabelConfig.getBoldLabelConfig(text: dataModel?.titleText, textAlignment: .center)
    }
    
    var buttonSuccessConfig: ButtonConfig {
        return ButtonConfig.getBackgroundButtonConfig(titleText: dataModel?.successButtonText, cornerRadius: 8)
    }
    
}
