import Foundation

struct NotificationModel {
    let imageName: String
    let title: String
    let desc: String
    let contact: String
    let btnTitle: String
    var backgroundColor: String?
    
}

protocol NotificationDataPassingDelegate: AnyObject {
}

protocol NotificationViewModelProtocol: AnyObject {
    var delegate: NotificationDataPassingDelegate? { get set }
    var dataModel: NotificationModel? { get set }
    var lblTitleConfig: LabelConfig { get }
    var lblDescConfig: LabelConfig { get }
    var lblContactConfig: LabelConfig { get }
    var btnNotificationHandlerConfig: ButtonConfig { get }
}

class NotificationViewModel: NotificationViewModelProtocol {
    weak var delegate: NotificationDataPassingDelegate?
    var dataModel: NotificationModel?
    
    // MARK: - UI Config
    var lblTitleConfig: LabelConfig {
        return LabelConfig.getBoldLabelConfig(text: dataModel?.title, textAlignment: .center)
    }
    
    var lblDescConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: dataModel?.desc, textAlignment: .center)
    }
    
    var lblContactConfig: LabelConfig {
        return LabelConfig.getRegularLabelConfig(text: dataModel?.contact, textAlignment: .center)
    }
    
    var btnNotificationHandlerConfig: ButtonConfig {
        return ButtonConfig.getBackgroundButtonConfig(titleText: dataModel?.btnTitle, fontSize: 16, textColor: .white, backgroundColor: .themeDarkBlue, cornerRadius: 8)
    }
}
