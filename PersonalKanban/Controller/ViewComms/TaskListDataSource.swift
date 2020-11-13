//
//  TaskListDataSource.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/11/20.
//

import UIKit
import CoreData


struct TasksListDataSource: TaskTableDataSource {

    let dao: PersistenceManager

    let sectionsFetchRequestInfo: [FetchRequestInfo<Task>]

    func getData() -> [[Task]] {
        return dao.performFetches(with: sectionsFetchRequestInfo)
    }

    func getSectionHeaders() -> [UILabel?] {
        return Array(repeating: nil, count: sectionsFetchRequestInfo.count)
    }

    func getSectionFooters() -> [UILabel?] {
        return Array(repeating: nil, count: sectionsFetchRequestInfo.count)
    }

    func getTableViewFooter() -> UIView? {
        return nil
    }

    init(dao: PersistenceManager, fetchRequestInfo: [FetchRequestInfo<Task>]) {
        self.dao = dao
        self.sectionsFetchRequestInfo = fetchRequestInfo
    }
}

//
//struct EpicFetchRequestDefaults {}
//
//struct NotesFetchRequestDefaults {}

