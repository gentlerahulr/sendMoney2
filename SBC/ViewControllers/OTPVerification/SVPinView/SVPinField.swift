import UIKit

class SVPinField: UITextField {
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(UIResponderStandardEditActions.copy(_:)) ||
            action == #selector(UIResponderStandardEditActions.cut(_:)) ||
            action == #selector(UIResponderStandardEditActions.select(_:)) ||
            action == #selector(UIResponderStandardEditActions.selectAll(_:)) ||
            action == #selector(UIResponderStandardEditActions.delete(_:)) {
            
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
    
    override func deleteBackward() {
        
        let isBackSpace = { () -> Bool in
            let char = self.text!.cString(using: String.Encoding.utf8)!
            return strcmp(char, "\\b") == -92
        }
                // Move cursor from the beginning (set in shouldChangeCharIn:) to the end for deleting
        selectedTextRange = textRange(from: endOfDocument, to: beginningOfDocument)
        
        if isBackSpace(), let nextResponder = self.superview?.superview?.superview?.superview?.viewWithTag(self.tag - 1) as? UITextField {
            nextResponder.becomeFirstResponder()
            if self.text?.isEmpty ?? false {
                 nextResponder.text = ""
            }
        }
         super.deleteBackward()
    }
}
