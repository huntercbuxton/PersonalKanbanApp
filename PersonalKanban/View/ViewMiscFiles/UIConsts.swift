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

    // text input defaults

    static let textInputBorderColor: CGColor = UIColor.systemGray5.cgColor
    static let textInputBorderWidth: CGFloat = 2.5
    static let textInputCornerRadius: CGFloat = 8

    // text field defaults

    static let defaultTextFieldFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    static let titleFieldPlaceholderText = "add a title"

    // text view defaults

    static let defaultTextViewFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    static let defaultTextViewHeight: CGFloat = 200
    static let defaultTextViewInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let readOnlyTextViewMaxHeight: CGFloat = 350

    // table view defaults

    static let defaultTableHeaderHeight: CGFloat = 40
    // font styles to mimic the default for a UITableView Header: https://ianmcdowell.net/blog/uitableview-default-fonts/
    static let defaultTableHeaderFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
    static let defaultTableHeaderFontColor: UIColor = UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)

    // input error label
    static let inputErrorLabelFont: UIFont = UIFont.preferredFont(forTextStyle: .subheadline)
    static let inputErrorLabelFontColor: UIColor = .systemRed
    static let inputErrorLabelTopMarginWhenVisible: CGFloat = 5
    static let inputErrorLabelBottomMarginWhenVisible: CGFloat = 15
    static let inputErrorLabelHeightWhenHidden: CGFloat = 10
    static let inputErrorLabelTopMarginWhenHidden: CGFloat = 0

    // log/notes displays

    static let defaultTimeStampFont: UIFont = UIFont.preferredFont(forTextStyle: .caption1)
    static let defaultLogEntryFont: UIFont = UIFont.preferredFont(forTextStyle: .body)
    static let logEntryVerticalSpacing: CGFloat = 10
    static let logzEntrySectionVerticalSpacing: CGFloat = 10
    static let logEntryInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    // keyboard to input field spacing
    static let minimumSpacingFromKeyboard: CGFloat = 10


    // general content arrangement
    static let verticalSpacing: CGFloat = 20
    static let shortVerticalSpacing: CGFloat = 10
    static let sectionLabelHeight: CGFloat = 50

    // other defaults

    static let defaultBackgroundColor: UIColor = .systemGroupedBackground
    static let defaultLargeTableRowHeight: CGFloat = 70
    static let defaultMainMenuFont: UIFont = UIFont.preferredFont(forTextStyle: .headline)
    static let activityIndicatorFontColor: UIColor = .systemRed
    static let urgentTaskFontColor: UIColor = .systemOrange
    static let highlighterColor: UIColor = .systemYellow
    static let unsavedDataFontColor: UIColor = .systemBlue

}

struct LayoutConsts {

}

struct NonSytemStyleConstants {

    static let logoBackgroundColorHexStr = "#55ff55"
    static let logoTextColorHexStr = "#0000ff"
    static let logoFontFamilyName = "Alata"
    static let logoFontName = "Alata-Regular"
    static let faviconFontSize = 110
    static let websiteURL = "https://personalkanbanapp.hunterbuxton.com"
    static let githubURL = "https:github.com/huntercbuxton/PersonalKanbanApp.git"
    static let logoBackgroundUIColor: UIColor = UIColor(hex: NonSytemStyleConstants.logoBackgroundColorHexStr)!
    static let logoTextUIColor: UIColor = UIColor(hex: NonSytemStyleConstants.logoTextColorHexStr)!
    static let logoFont: UIFont? = UIFont(fontStyle: .alataReg, size: 20)

}

enum FontStyle: String {
    case alataReg = "Alata-Regular"
}

// https://zonneveld.dev/adding-custom-fonts-to-your-ios-app/

extension UIFont {
    convenience init?(fontStyle: FontStyle, size: CGFloat) {
        self.init(name: fontStyle.rawValue, size: size)
    }
}
