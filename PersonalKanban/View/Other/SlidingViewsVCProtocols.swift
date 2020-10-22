//
//  Protocols.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/18/20.
//

import Foundation
import UIKit

// only the root parent controller conforms to this.
protocol SlidingViewDelegate: AnyObject {
    func toggleMenuVisibility()
    func hideMenu()
    func showMenu()
}
