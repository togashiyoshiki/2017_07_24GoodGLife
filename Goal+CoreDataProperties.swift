//
//  Goal+CoreDataProperties.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/06.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var goaltitle: String?
    @NSManaged public var goaldetail: String?
    @NSManaged public var goaldeta: NSDate?

}
