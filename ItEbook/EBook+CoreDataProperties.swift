//
//  EBook+CoreDataProperties.swift
//  ItEbook
//
//  Created by 高永效 on 15/11/2.
//  Copyright © 2015年 高永效. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension EBook {

    @NSManaged var author: String?
    @NSManaged var bookCover: NSData?
    @NSManaged var brief: String?
    @NSManaged var pages: String?
    @NSManaged var publishDate: String?
    @NSManaged var publisher: String?
    @NSManaged var subTitle: String?
    @NSManaged var title: String?
    @NSManaged var isbn: String?

}
