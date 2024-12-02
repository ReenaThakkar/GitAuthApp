//
//  RepositoryEntity+CoreDataProperties.swift
//  Reena_7Span_Practical
//
//  Created by Reena on 12/2/24.
//
//

import Foundation
import CoreData


extension RepositoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RepositoryEntity> {
        return NSFetchRequest<RepositoryEntity>(entityName: "RepositoryEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var name: String?
    @NSManaged public var descriptionText: String?
    @NSManaged public var stars: Int64
    @NSManaged public var forks: Int64
    @NSManaged public var lastUpdated: Date?

}

extension RepositoryEntity : Identifiable {

}
