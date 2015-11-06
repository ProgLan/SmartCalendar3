//
//  SCCalendarViewDelegate.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

@objc
public protocol SCCalendarViewDelegate {
    func presentationMode() -> CalendarMode
    func firstWeekday() -> Weekday
    //optional func printHelloWorld()

    
    /**
    Determines whether resizing should cause related views' animation.
    */
    optional func shouldAnimateResizing() -> Bool
    
    optional func shouldScrollOnOutDayViewSelection() -> Bool
    optional func shouldAutoSelectDayOnWeekChange() -> Bool
    optional func shouldAutoSelectDayOnMonthChange() -> Bool
    optional func shouldShowWeekdaysOut() -> Bool
    optional func didSelectDayView(dayView: DayView, animationDidFinish: Bool)
    optional func presentedDateUpdated(date: Date)
    optional func topMarker(shouldDisplayOnDayView dayView: DayView) -> Bool
    optional func dotMarker(shouldMoveOnHighlightingOnDayView dayView: DayView) -> Bool
    optional func dotMarker(shouldShowOnDayView dayView: DayView) -> Bool
    optional func dotMarker(colorOnDayView dayView: DayView) -> [UIColor]
    optional func dotMarker(moveOffsetOnDayView dayView: DayView) -> CGFloat
    optional func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat
    
    optional func preliminaryView(viewOnDayView dayView: DayView) -> UIView
    optional func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    
    optional func supplementaryView(viewOnDayView dayView: DayView) -> UIView
    optional func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool
    
    optional func didShowNextMonthView(date: NSDate)
    optional func didShowPreviousMonthView(date: NSDate)
    
    
}