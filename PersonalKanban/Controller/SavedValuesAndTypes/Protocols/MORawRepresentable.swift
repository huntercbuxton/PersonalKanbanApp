//
//  MORawRepresentable.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 11/16/20.
//

import Foundation

protocol MORawRepresentable: RawRepresentable {
    associatedtype MOValue: Equatable

    var moValue: MOValue { get }
    var moPropertyKey: String { get }
    var fetchPredicate: NSPredicate { get }
    var string: String { get }

    static var caseDefault: MOValue { get }

    init()
    init?(moValue: MOValue)
    init(_ moValue: MOValue?)
}

extension MORawRepresentable {
    var string: String { String(describing: self) }
    var fetchPredicate: NSPredicate { NSPredicate(format: "\(self.moPropertyKey) == \(self.moValue)") }
}

extension MORawRepresentable where MOValue == Int64, RawValue == Int {
    var moValue: MOValue { MOValue(self.rawValue) }

    init() {
        self.init(Self.caseDefault)
    }
    init?(moValue: MOValue) {
        self.init(rawValue: Int(moValue))
    }
    init(_ moValue: MOValue?) {
        self.init(moValue: moValue ?? Self.caseDefault)!
    }
}


