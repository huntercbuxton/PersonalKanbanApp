//
//  MainMenuProtocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

// the root parent view will alsp conform to this to know when the content should be changed
protocol MenuSelectionDelegate: AnyObject {
    associatedtype IdT: Hashable
    func upateSelection(from oldSelection: IdT?, to newSelection: IdT)
}

protocol MenuOptionRepresentable: CaseIterable, Hashable {
    func toString() -> String
}

protocol MenuRepresentable {
    associatedtype OptionT
    var options: [OptionT] { get set }
    var defaultSelection: OptionT { get set }
    var currentSelection: OptionT? { get set }
}

protocol MenuController {
    associatedtype SelectionT
    associatedtype MenuT: MenuRepresentable where MenuT.OptionT == SelectionT
    associatedtype DelegateT: MenuSelectionDelegate where DelegateT.IdT == SelectionT
    var menu: MenuT { get set }
    var selectionDelegate: DelegateT? { get set }
    func select(option: SelectionT)
    func reset()
    func refresh()
}
