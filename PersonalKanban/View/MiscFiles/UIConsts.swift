//
//  UIConstants.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/17/20.
//

import UIKit

struct UIConsts {

    // misc strimgs

    static let menuButtonImageMame = "sidebar.leading"

    static let titleFieldPlaceholderText = "add a title"

    static let minimumSpacingFromKeyboard: CGFloat = 10

    static let sectionLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)

    // other defaults

    static let defaultBackgroundColor: UIColor = .systemGroupedBackground
    static let defaultLargeTableRowHeight: CGFloat = 70
}

struct SavedLayouts {

    static let defaultTableHeaderHeight: CGFloat = 40

    // general content arrangement

    static let verticalSpacing: CGFloat = 20
    static let shortVerticalSpacing: CGFloat = 10
    static let sectionLabelHeight: CGFloat = 50

    // text view defaults

    static let defaultTextViewHeight: CGFloat = 130
    static let defaultTextViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
}

struct SavedStyles {
    // text input defaults

    static let textInputBorderColor: CGColor = UIColor.systemGray5.cgColor
    static let textInputBorderWidth: CGFloat = 2.5
    static let textInputCornerRadius: CGFloat = 8

    // text field defaults

    static let defaultTextFieldFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)

    // text view defaults

    static let defaultTextViewFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
}

struct NonSytemStyleConstants {
    static let faviconFontSize = 110
    static let websiteURL = "https://personalkanbanapp.hunterbuxton.com"
    static let githubURL = "https:github.com/huntercbuxton/PersonalKanbanApp.git"
}
