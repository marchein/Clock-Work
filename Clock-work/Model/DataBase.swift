//
//  DataBase.swift
//  Clockin
//
//  Created by Noam Efergan on 04/05/2020.
//  Copyright © 2020 Noam Efergan. All rights reserved.
//

import UIKit
import RealmSwift



class Data: Object{
    @objc dynamic var hourlyWage:Double = 0.0
    @objc dynamic var petrolMoney:Double = 0.0
    @objc dynamic var contractSelected:Int = 0
    @objc dynamic var extraHours:Int = 0
}

class Times: Object{
    @objc dynamic var start:String = ""
    @objc dynamic var monthlyHours:Int = 0
    @objc dynamic var monthlyMinutes:Int = 0
    @objc dynamic var monthlySalary:Double = 0.0
}

