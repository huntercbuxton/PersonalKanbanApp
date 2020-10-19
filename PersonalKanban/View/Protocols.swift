//
//  Protocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import Foundation
import UIKit

// only the root parent controller conforms to this.
public protocol ViewSlidingDelegate: AnyObject {
    func toggleMenuVisibility()
    func hideMenu()
    func showMenu()
}

// the root parent view will alsp conform to this to know when the content should be changed
public protocol SlidingViewsMenuSelectionDelegate: AnyObject {
    func menuSelection(_ selected: MenuOptions)
    func menuSelectionChange(_ selected: MenuOptions)
}

// the menu has a reference to the root view to cue when the menu needs to be retracted
public protocol ContentPositionControllable {
    var sliderDelegate: ViewSlidingDelegate { get set }
}

// the mene view controller (SliderOneVC) controlls the Menu.
public protocol MenuController {
    var menuSelectionDelegate: SlidingViewsMenuSelectionDelegate? { get set }
    var lastSelection: MenuOptions? { get set }
}
