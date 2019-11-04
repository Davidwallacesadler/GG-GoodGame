//
//  Date.swift
//  GoodGame
//
//  Created by David Sadler on 11/1/19.
//  Copyright © 2019 David Sadler. All rights reserved.
//

import Foundation

extension Date {
    func dayMonthYearValue() -> String {
           let formatter = DateFormatter()
           formatter.timeStyle = .none
           formatter.dateStyle = .short
           return formatter.string(from: self)
       }
}
