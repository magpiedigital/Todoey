//
//  Item.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-10.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    let parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
