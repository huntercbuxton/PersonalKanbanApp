//
//  CustomFontImportStuff.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/10/20.
//

import UIKit

struct SavedCustomFonts {
    static let logoFont: UIFont = FontStyle.alataReg.convertToUIFont()

    // font styles to mimic the default for a UITableView Header: https://ianmcdowell.net/blog/uitableview-default-fonts/
    static let defaultTableHeaderFont: UIFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
}

enum FontStyle: String {
    case alataReg = "Alata-Regular"

    func convertToUIFont(size: CGFloat = 20) -> UIFont {
        return UIFont(fontStyle: self, size: size)!
    }
}

// https://zonneveld.dev/adding-custom-fonts-to-your-ios-app/
extension UIFont {
    convenience init?(fontStyle: FontStyle, size: CGFloat) {
        self.init(name: fontStyle.rawValue, size: size)
    }
}
