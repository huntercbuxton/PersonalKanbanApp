//
//  DAOErrors.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/12/20.
//

import Foundation

enum DaoErrors {
    case fetchError
    case saveError
    case loadingPersistentContainerFailed
    case unexpectedFetchResult
    case badPropertyValue
    case typeCastFailed
    case requestTimedOut
}
