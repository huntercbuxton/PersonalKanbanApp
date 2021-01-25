//
//  MiscellaneousUIKitExtensions.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/22/20.
//

import UIKit

extension UIView {
    convenience init(background color: UIColor) {
        self.init()
        self.backgroundColor = color
    }
}

// code to dismiss keyboard whenever the view is tapped. used by AddEditTaskVC and AddEditEpicVC
// call 'dismissKeyboard()' at the end of viewDidLoad() to use this solution.
extension UIViewController {
    func dismissKeyboard() {
       let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action: #selector(dismissKeyboardTouchOutside))
       tap.cancelsTouchesInView = false
       view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboardTouchOutside() {
       view.endEditing(true)
    }
}
