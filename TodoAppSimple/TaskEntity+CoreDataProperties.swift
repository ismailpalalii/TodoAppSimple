//
//  TaskEntity+CoreDataProperties.swift
//  TodoAppSimple
//
//  Created by ismail palali on 17.03.2022.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var name: String?
    @NSManaged public var isdone: Bool

}

extension TaskEntity : Identifiable {

}
