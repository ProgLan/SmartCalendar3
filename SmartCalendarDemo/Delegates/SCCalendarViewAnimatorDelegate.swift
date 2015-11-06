//
//  SCCalendarViewAnimatorDelegate.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

@objc
public protocol SCCalendarViewAnimatorDelegate {
    func selectionAnimation() -> ((DayView, ((Bool) -> ())) -> ())
    func deselectionAnimation() -> ((DayView, ((Bool) -> ())) -> ())
}