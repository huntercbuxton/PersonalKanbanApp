//
//  UITextViewExtension.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import UIKit

public extension UILabel {

    // used to create section header views for EpicTasksList view controller
    convenience init(text: String) {
        self.init()
        heightAnchor.constraint(equalToConstant: SavedLayouts.defaultTableHeaderHeight).isActive = true
        backgroundColor = .systemBackground
        textAlignment = .center
        font = SavedCustomFonts.defaultTableHeaderFont
        textColor = SavedCustomColors.defaultTableHeaderFontColor
        self.text = text
        layer.borderWidth = 0.4
        layer.borderColor =  UIColor.white.cgColor
    }

    // used by the LogView controller
    func setup(in view: UIView, margin: CGFloat) {
         translatesAutoresizingMaskIntoConstraints = false
         view.addSubview(self)
        self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin).isActive = true
        self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin).isActive = true
        self.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
}
