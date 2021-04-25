import UIKit

class CommonAlertHandler {
    
    class func showErrorResponseAlert(for message: String) {
        let titleAndMessage: (title: String?, message: String?) = getTiitleAndMessage(for: message)
        guard let errorMessage = titleAndMessage.message else {
            AlertViewAdapter.shared.show(message, state: .failure)
            return
        }
        AlertViewAdapter.shared.show(errorMessage, state: .failure)
    }
    
    class func getTiitleAndMessage(for message: String) -> (title: String?, message: String?) {
        var title: String?
        var desc: String?
        if message.contains("A server with the specified hostname could not be found") {
            title = localizedStringForKey(key: "alert.server.error.title")
            desc = localizedStringForKey(key: "alert.server.error.desc")
        } else if message.contains("Internet connection appears to be offline") {
            title = localizedStringForKey(key: "alert.offline.title")
            desc = localizedStringForKey(key: "alert.offline.desc")
        } else if message.contains("The request timed out") {
            title = localizedStringForKey(key: "alert.timeout.title")
            desc = localizedStringForKey(key: "alert.timeout.desc")
        } else if message.contains("Email must not be empty") {
            title = localizedStringForKey(key: "alert.error.social.data.title")
            desc = localizedStringForKey(key: "alert.error.social.data.desc")
        }
        return (title: title, message: desc)
    }
}
