//
//  Daily+CoreDataProperties.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/06.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import Foundation
import CoreData


extension Daily {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Daily> {
        return NSFetchRequest<Daily>(entityName: "Daily")
    }

    @NSManaged public var dailyDetail: String?
    @NSManaged public var dailyTitle: String?
    @NSManaged public var deilyDeta: NSDate?
    @NSManaged public var dailyImage: String?

}
