//
//  PlusMoney.swift
//  MyMoneyVKR
//
//  Created by IlyaDenisov on 28.03.17.
//  Copyright © 2017 Denisov's. All rights reserved.
//

import RealmSwift

class PlusMoney: Object{
    dynamic var name = ""
    dynamic var amount = ""
    dynamic var createdAT = NSDate()
}
