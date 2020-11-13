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

    func mainMenuRequest(_ option: MainMenuOptions) -> SlidingContentsVC {
        switch option {
        case .inProgress:
            let dataSource = TasksListDataSource(dao: persistenceManager, fetchRequestInfo: [TaskFetchRequestDefaults.inProgressTable])
            return TasksListDisplayVC(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, dataSource: dataSource)
        case .toDo:
            let dataSource = TasksListDataSource(dao: persistenceManager, fetchRequestInfo: [TaskFetchRequestDefaults.toDoTable])
            return TasksListDisplayVC(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, dataSource: dataSource)
        case .backlog:
            let dataSource = TasksListDataSource(dao: persistenceManager, fetchRequestInfo: [TaskFetchRequestDefaults.backlogTable])
            return TasksListDisplayVC(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, dataSource: dataSource)
        case .finished:
            let dataSource = TasksListDataSource(dao: persistenceManager, fetchRequestInfo: [TaskFetchRequestDefaults.finishedTable])
            return TasksListDisplayVC(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, dataSource: dataSource)
        case .epics:
            return  EpicsTable(sliderDelegate: contentViewDelegateRef, persistenceManager: persistenceManager)
        case .archived:
            let dataSource = TasksListDataSource(dao: persistenceManager, fetchRequestInfo: [TaskFetchRequestDefaults.archivedTable])
            return TasksListDisplayVC(persistenceManager: persistenceManager, sliderDelegate: contentViewDelegateRef, dataSource: dataSource)
        }
    }

    func composeBtnRequest(currentPage: MainMenuOptions, updateDelegate: CoreDataDisplayDelegate) -> UIViewController {
        print("in function \(#function) the currentPage argument was \(currentPage)")
        switch currentPage {
        case .inProgress:
            return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultPosition: .inProgress)
        case .toDo:
            return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultPosition: WorkflowPosition.toDo)
        case .epics:
            return AddEditEpicVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate)
        case .backlog:
            return AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultPosition: .backlog)
        case .finished:
            return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultPosition: .finished)
        case .archived:
            return  AddEditTaskVC(persistenceManager: persistenceManager, useState: .create, updateDelegate: updateDelegate, defaultPosition: .backlog)
        }
    }

    init(persistenceManager: PersistenceManager, delegateRef: MainVC) {
        self.persistenceManager = persistenceManager
        self.contentViewDelegateRef = delegateRef
    }
}
