import UIKit

func parse(keyboardNotification notification: Notification) -> (CGFloat, TimeInterval, UIViewAnimationOptions)? {
    print("n = \(notification.name)")
    
    guard let info = notification.userInfo else {
        return nil
    }
    
    guard let height = (info[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height else {
        return nil
    }
    
    guard let duration = info[UIKeyboardAnimationDurationUserInfoKey] as? TimeInterval else {
        return nil
    }
    
    guard let curveRaw = info[UIKeyboardAnimationCurveUserInfoKey] as? Int else {
        return nil
    }
    
    let curve = UIViewAnimationOptions(rawValue: UInt(curveRaw) << 16)
    
    return (height, duration, curve)
}
