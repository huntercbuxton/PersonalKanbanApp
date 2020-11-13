//
//  CustomUIColorsFromHex.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/10/20.
//

import UIKit


struct SavedCustomColors {
    static let logoBackground = CustomColor.logoBackground.convertToUIColor()
    static let logoText = CustomColor.logoText.convertToUIColor()
    // font styles to mimic the default for a UITableView Header: https://ianmcdowell.net/blog/uitableview-default-fonts/
    static let defaultTableHeaderFontColor: UIColor = UIColor(red: 0.42, green: 0.42, blue: 0.44, alpha: 1.0)

}

enum CustomColor: String {
    case logoBackground = "#55ff55ff"
    case logoText = "#0000ffff"

    func convertToUIColor() -> UIColor {
        return UIColor(hex: self.rawValue)!
    }
}
