//
//  MainMenuController.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit

protocol MenuInteractionsResponder {
    mutating func detectedSelection(_ option: MainMenuOptions)
}

protocol MainMenuControllerDelegate: SlidingViewDelegate {
    func setTitle(_ newTitle: String?)
    func updateDisplay(for option: MainMenuOptions)
}

public class MainMenuController: MenuInteractionsResponder {

    weak var controllerDelegate: MainMenuControllerDelegate?

    var initialSelection: MainMenuOptions = .inProgress
    
    func detectedSelection(_ option: MainMenuOptions) {
        print("called \(#function) in MainMenuController!! with argument opetion = \(option.pageTitle)")
        controllerDelegate?.hideMenu()
        guard selection != option else { return }
        self.selection = option
        self.controllerDelegate?.updateDisplay(for: option)
    }

    lazy var selection: MainMenuOptions = .inProgress {
        didSet {
            print("selection property in the displayController is now \(selection)")
            self.title = selection.pageTitle
            controllerDelegate?.setTitle(title)
        }
    }

    lazy var title: String = selection.pageTitle

}
