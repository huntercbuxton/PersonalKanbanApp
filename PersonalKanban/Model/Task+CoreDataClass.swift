//
//  Task+CoreDataClass.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

@objc(Task)
public class Task: NSManagedObject {

    var notesList: [Note] {
        get { return self.taskNotes?.array as! [Note] }
        set { taskNotes = NSOrderedSet(array: newValue) }
    }

    var storyPointsEnum: StoryPoints {
        get {
            guard let converted = StoryPoints(from: self.storypoints) else { fatalError("the value of \(self.storypoints) failed to initialize the enumerated type") }
            return converted
        }
        set {
            self.storypoints = Int64(newValue.rawValue)
        }
    }

    var workflowStatusEnum: WorkflowPosition {
        get {
            guard let converted = WorkflowPosition(rawValue: Int(self.workflowStatus)) else {fatalError("the value of \(self.workflowStatus) failed to initialize the enumerated type") }
            print("workflowStatusEnum.get returned \(converted)")
            return converted
        }
        set {
            self.workflowStatus = Int64(newValue.rawValue)
        }
    }
}

enum StoryPoints: Int, RawRepresentable, CaseIterable {
    case unassigned = 0
    case two = 1
    case four = 2
    case eight = 3
    case sixteen = 4

    init?(from value: Int64) {
        self.init(rawValue: Int(value))
    }

    var displayTitle: String { String(describing: self) }
}
