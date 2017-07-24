//
//  ToDo+CoreDataProperties.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/06.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import Foundation
import CoreData


extension ToDo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDo> {
        return NSFetchRequest<ToDo>(entityName: "ToDo")
    }

    @NSManaged public var todotitle: String?
    @NSManaged public var tododeta: NSDate?

}
