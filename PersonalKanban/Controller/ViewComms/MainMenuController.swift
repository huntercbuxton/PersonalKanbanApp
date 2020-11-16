//
//  MainMenuController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

protocol MenuInteractionsResponder {
    func detectedSelection(_ option: MainMenuPages)
}

protocol MainMenuControllerDelegate: SlidingViewDelegate {
    var title: String? { get set }
    func updateDisplay(for option: MainMenuPages)
}

public class MainMenuController: MenuInteractionsResponder {

    weak var controllerDelegate: MainMenuControllerDelegate?

    var initialSelection: MainMenuPages = .inProgress

    func detectedSelection(_ option: MainMenuPages) {
        print("called \(#function) in MainMenuController!! with argument opetion = \(option.toString)")
        controllerDelegate?.hideMenu()
        guard selection != option else { return }
        self.selection = option
        self.controllerDelegate?.updateDisplay(for: option)
    }

    lazy var selection: MainMenuPages = .inProgress {
        didSet {
            print("selection property in the displayController is now \(selection)")
            self.title = selection.toString
            controllerDelegate?.title = title
        }
    }

    lazy var title: String = selection.toString

}
