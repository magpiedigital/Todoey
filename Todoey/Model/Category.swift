//
//  Category.swift
//  Todoey
//
//  Created by Hamish Johnson on 2018-01-10.
//  Copyright © 2018 Hamish Johnson. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
