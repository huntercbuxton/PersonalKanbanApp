//
//  MainDisplayRequestHandler.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import Foundation
import UIKit
import  CoreData

struct ContentRequestHandler {

    private let persistenceManager: PersistenceManager
    weak var contentViewDelegateRef: MainVC?
    weak var presenterRef: MainVC?
    weak var updateDelegateRef: CoreDataDisplayDelegate?

    func getDefaultMainVCDisplay() -> SlidingContentsVC {
        return mainMenuRequest(.inProgress)
    }

    func mainMenuRequest(_ option: MainMenuPages) -> SlidingContentsVC {
        switch option {
        case .epics: return EpicsTable(sliderDelegate: contentViewDelegateRef, persistenceManager: persistenceManager)
        default:
            let folder = TaskFolder.pageDic[option]
            return FRCTaskLists(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, folder: folder!)
        }
    }

    func composeBtnRequest(currentPage: MainMenuPages, updateDelegate: CoreDataDisplayDelegate) -> UIViewController {
        switch currentPage {
        case .inProgress: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultFolder: .inProgress)
        case .toDo: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultFolder: .toDo)
        case .epics: return AddEditEpicVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate)
        case .backlog: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultFolder: .backlog)
        case .finished: return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultFolder: .finished)
        case .archived: return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultFolder: .archived)
        }
    }

    init(persistenceManager: PersistenceManager, delegateRef: MainVC) {
        self.persistenceManager = persistenceManager
        self.contentViewDelegateRef = delegateRef
    }
}
