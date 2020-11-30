//
//  MainMenuProtocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

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
