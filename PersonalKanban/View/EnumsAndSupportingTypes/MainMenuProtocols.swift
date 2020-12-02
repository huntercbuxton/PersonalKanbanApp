//
//  MainMenuProtocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

// only the root parent controller (MainVC instance) conforms to this.
protocol SlidingViewDelegate: AnyObject {
    func toggleMenuVisibility()
    func hideMenu()
    func showMenu()
}

protocol SlidingContentsVC: AnyObject {
    var sliderDelegate: SlidingViewDelegate? { get set }
}
