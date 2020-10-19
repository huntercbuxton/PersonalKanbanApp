//
//  MainMenuData.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

struct MainMenuData<T: MenuOptionRepresentable>: MenuRepresentable {
    typealias OptionT = T
    var options: [T]
    var defaultSelection: T
    var currentSelection: T?
}
