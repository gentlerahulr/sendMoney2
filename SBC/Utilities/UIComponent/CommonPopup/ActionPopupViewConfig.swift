import UIKit

enum ActionPopupStyle: Int {
    case alertView = 0
    case bottomSheet = 1
}

class ActionPopupViewConfig {
    struct Text {
        let titleText: String
        let descText: String
        let positiveButtonText: String
        let negativeButtonText: String
    }
    var style: ActionPopupStyle
    var text: Text
    var hideNegativeButton: Bool
    var labelTitleConfig: LabelConfig?
    var labelDescConfig: LabelConfig?
    var buttonPositiveConfig: ButtonConfig?
    var buttonNegativeConfig: ButtonConfig?
    //Configure below properties if we need to use different configuration other than configured in xib file.
    var containerViewConfig: ViewConfig?
    var popupViewConfig: ViewConfig?
    
    init(text: Text, hideNegativeButton: Bool, style: ActionPopupStyle) {
        self.text = text
        self.hideNegativeButton = hideNegativeButton
        self.style = style
    }
    class func getDefaultConfig(text: Text, hideNegtiveButton: Bool, style: ActionPopupStyle) -> ActionPopupViewConfig {
        let actionConfig = ActionPopupViewConfig(text: text, hideNegativeButton: hideNegtiveButton, style: .alertView)
        actionConfig.labelTitleConfig = LabelConfig.getBoldLabelConfig(text: text.titleText, fontSize: 16, textAlignment: .center)
        actionConfig.labelDescConfig = LabelConfig.getRegularLabelConfig(text: text.descText, lineSpacing: 2.5, textAlignment: .center)
        actionConfig.buttonPositiveConfig = ButtonConfig.getBackgroundButtonConfig(titleText: text.positiveButtonText, cornerRadius: 8)
        actionConfig.buttonNegativeConfig = ButtonConfig.getBoldButtonConfig(titleText: text.negativeButtonText, fontSize: 16)
        actionConfig.style = style
        return actionConfig
    }
    
    class func getButtonPositiveBGColorConfig(text: Text, positiveButtonBGColor: UIColor, hideNegativeButton: Bool, style: ActionPopupStyle = .alertView) -> ActionPopupViewConfig {
        let actionConfig = ActionPopupViewConfig.getDefaultConfig(text: text, hideNegtiveButton: hideNegativeButton, style: style)
        actionConfig.buttonPositiveConfig?.backgroundColor = positiveButtonBGColor
        return actionConfig
    }
}
