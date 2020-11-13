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
//
//    public func styleForSectionHeader() {
//        translatesAutoresizingMaskIntoConstraints = false
//        heightAnchor.constraint(equalToConstant: SavedLayouts.defaultTableHeaderHeight).isActive = true
//        backgroundColor = .systemGroupedBackground
//        text = "   "
//    }
}
