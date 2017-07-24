//
//  Calender+CoreDataProperties.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/12.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import Foundation
import CoreData


extension Calender {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calender> {
        return NSFetchRequest<Calender>(entityName: "Calender")
    }

    @NSManaged public var deta: NSDate?
    @NSManaged public var targetdeta: String?
    @NSManaged public var title: String?
    @NSManaged public var detail: String?

}
