//
//  Epic+CoreDataClass.swift
//  PersonalKanban
//
//  Created by Hunter Buxton on 10/20/20.
//
//

import Foundation
import CoreData

@objc(Epic)
public class Epic: NSManagedObject {

    var tasksList: [Task] {
        get { return self.tasks?.array as? [Task] ?? [] }
          set { tasks = NSOrderedSet(array: newValue) }
      }

}
