//
//  MORawRepresentable.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

protocol MORawRepresentable: RawRepresentable {
    associatedtype MORawVal: Equatable
    var moRawVal: MORawVal { get }
    var key: String { get }
    var fetchPredicate: NSPredicate { get }
    func equals(_ moRawVal: MORawVal) -> Bool
}

extension MORawRepresentable {
    var fetchPredicate: NSPredicate { NSPredicate(format: "\(self.key) == \(self.moRawVal)") }
    func equals(_ moRawVal: MORawVal) -> Bool { self.moRawVal == moRawVal }
}


