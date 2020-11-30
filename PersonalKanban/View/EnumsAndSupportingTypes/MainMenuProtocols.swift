//
//  MainMenuProtocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/19/20.
//

import Foundation

protocol SlidingContentsVC: AnyObject {
    func refreshDisplay()
    var sliderDelegate: SlidingViewDelegate? { get set }
}

extension SlidingContentsVC {
    func refreshDisplay() { }
}
