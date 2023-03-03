//
//  Memo+CoreDataProperties.swift
//  RxMemo
//
//  Created by Hiroki Minami on 2023-03-03.
//
//

import Foundation
import CoreData


extension Memo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Memo> {
        return NSFetchRequest<Memo>(entityName: "Memo")
    }

    @NSManaged public var content: String?
    @NSManaged public var insertDate: Date?
    @NSManaged public var identity: String?

}

extension Memo : Identifiable {

}
