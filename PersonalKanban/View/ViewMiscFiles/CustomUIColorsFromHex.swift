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
}

enum CustomColor: String {
    case logoBackground = "#55ff55ff"
    case logoText = "#0000ffff"

    func convertToUIColor() -> UIColor {
        return UIColor(hex: self.rawValue)!
    }
}
