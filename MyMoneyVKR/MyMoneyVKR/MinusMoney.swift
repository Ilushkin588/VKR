//
//  MinusMoney.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 29.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import RealmSwift

class MinusMoney: Object {
    dynamic var name = ""
    dynamic var amount = ""
    dynamic var createdAt = NSDate()
}
