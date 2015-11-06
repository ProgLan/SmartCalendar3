//
//  SCCalendarMenuViewDelegate.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import Foundation
import UIKit

@objc
public protocol SCCalendarMenuViewDelegate {
    optional func firstWeekday() -> Weekday
    optional func dayOfWeekTextColor() -> UIColor
    optional func dayOfWeekTextUppercase() -> Bool
    optional func dayOfWeekFont() -> UIFont
    optional func weekdaySymbolType() -> WeekdaySymbolType
}