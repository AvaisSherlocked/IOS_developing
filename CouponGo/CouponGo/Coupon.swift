//
//  Coupon.swift
//  CouponGo
//
//  Created by Tieyong Yu on 3/18/19.
//  Copyright © 2019 CouponGo. All rights reserved.
//

import Foundation

class Coupon{
    var businessName: String
    var businessID: String
    var usage: String
    var expire: Date
    var type: Int
    
    public static let functionality = ["10% off for all food", "1 free sides each visit", "20$ off for your first order"]
    
    init(name: String, id: String, type: Int, description: String) {
        self.businessName = name
        self.businessID = id
        self.type = type
        self.usage = description
        self.expire = Calendar.current.date(byAdding: .month, value: Int.random(in: 0 ..< 3), to: Date())!
    }
    
    // hash the Coupon object into a string
    func hashToString() -> String {
        return "\(businessName)*\(businessID)*\(usage)*\(expire.description)*\(type + 1)"
    }
}


