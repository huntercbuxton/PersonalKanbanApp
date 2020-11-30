//
//  MainMenuProtocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

protocol MenuOptionRepresentable: CaseIterable, Hashable {}

protocol MenuRepresentable {
    associatedtype OptionT
    var options: [OptionT] { get set }
    var defaultSelection: OptionT { get set }
    var currentSelection: OptionT? { get set }
}

protocol MenuController {
    associatedtype SelectionT
    associatedtype MenuT: MenuRepresentable where MenuT.OptionT == SelectionT
    var menu: MenuT { get set }
    func select(option: SelectionT)
    func reset()
    func refresh()
}

protocol SlidingContentsVC: CoreDataDisplayDelegate {
    func refreshDisplay()
    var sliderDelegate: SlidingViewDelegate? { get set }
}

extension SlidingContentsVC {
    func refreshDisplay() { }
}

protocol CoreDataDisplayDelegate: AnyObject {
    func updateCoreData()
}

extension CoreDataDisplayDelegate {
    func updateCoreData() { print("warning: this is the default implementation in the protocol extension of CoreDataDisplayDelegate. this functio \(#function) has no body") }
}
