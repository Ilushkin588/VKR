//
//  PlusMoney.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 28.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import RealmSwift

class PlusMoney: Object{
    dynamic var id = ""
    dynamic var type = ""
    dynamic var name = ""
    dynamic var amount = 0
    dynamic var category = ""
    dynamic var createdAT = NSDate()
    
    override static func primaryKey() -> String?{
        return "id"
    }
}
