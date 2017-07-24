//
//  GoodGLife+CoreDataProperties.swift
//  goodGlife
//
//  Created by togashi yoshiki on 2017/07/09.
//  Copyright © 2017年 Yoshiki Togashi. All rights reserved.
//

import Foundation
import CoreData


extension GoodGLife {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GoodGLife> {
        return NSFetchRequest<GoodGLife>(entityName: "GoodGLife")
    }

    @NSManaged public var title: String?
    @NSManaged public var deta: NSDate?

}
