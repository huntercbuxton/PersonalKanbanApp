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

    func getDefaultMainVCDisplay() -> SlidingContentsVC {
        return mainMenuRequest(.inProgress)
    }

    func mainMenuRequest(_ option: MainMenuPages) -> SlidingContentsVC {
        switch option {
        case .epics:
            return EpicsPageContent(persistence: persistenceManager, sliderDelegate: contentViewDelegateRef)
        //EpicsTable(sliderDelegate: contentViewDelegateRef, persistenceManager: persistenceManager)
        default:
            let folder = TaskFolder.pageDic[option]
            return TasksPageContent(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, folder: folder!)
        }
    }

    func composeBtnRequest(currentPage: MainMenuPages) -> UIViewController {
        switch currentPage {
        case .toDo: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, defaultFolder: .toDo)
        case .epics: return AddEditEpicVC(persistenceManager: persistenceManager, useState: .create)
        case .inProgress: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, defaultFolder: .inProgress)
        case .backlog: return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, defaultFolder: .backlog)
        case .finished: return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, defaultFolder: .finished)
        case .archived: return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, defaultFolder: .archived)
        }
    }

    init(persistenceManager: PersistenceManager, delegateRef: MainVC) {
        self.persistenceManager = persistenceManager
        self.contentViewDelegateRef = delegateRef
    }
}
