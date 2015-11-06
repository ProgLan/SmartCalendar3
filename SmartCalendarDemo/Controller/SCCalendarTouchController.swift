//
//  SCCalendarTouchController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public final class SCCalendarTouchController {
    private unowned let calendarView: CalendarView
    
    // MARK: - Properties
    public var coordinator: Coordinator {
        get {
            return calendarView.coordinator
        }
    }
    
    /// Init.
    public init(calendarView: CalendarView) {
        self.calendarView = calendarView
    }
}

// MARK: - Events receive

extension SCCalendarTouchController {
    public func receiveTouchLocation(location: CGPoint, inMonthView monthView: SCCalendarMonthView, withSelectionType selectionType: SCSelectionType) {
        //        let weekViews = monthView.weekViews
        if let dayView = ownerTouchLocation(location, onMonthView: monthView) where dayView.userInteractionEnabled {
            receiveTouchOnDayView(dayView, withSelectionType: selectionType)
        }
    }
    
    public func receiveTouchLocation(location: CGPoint, inWeekView weekView: SCCalendarWeekView, withSelectionType selectionType: SCSelectionType) {
        //        let monthView = weekView.monthView
        //        let index = weekView.index
        //        let weekViews = monthView.weekViews
        
        if let dayView = ownerTouchLocation(location, onWeekView: weekView) where dayView.userInteractionEnabled {
            receiveTouchOnDayView(dayView, withSelectionType: selectionType)
        }
    }
    
    public func receiveTouchOnDayView(dayView: SCCalendarDayView) {
        coordinator.performDayViewSingleSelection(dayView)
    }
}

// MARK: - Events management

private extension SCCalendarTouchController {
    func receiveTouchOnDayView(dayView: SCCalendarDayView, withSelectionType selectionType: SCSelectionType) {
        if let calendarView = dayView.weekView.monthView.calendarView {
            switch selectionType {
            case .Single:
                coordinator.performDayViewSingleSelection(dayView)
                calendarView.didSelectDayView(dayView)
                
            case .Range(.Started):
                print("Received start of range selection.")
            case .Range(.Changed):
                print("Received change of range selection.")
            case .Range(.Ended):
                print("Received end of range selection.")
            }
        }
    }
    
    func monthViewLocation(location: CGPoint, doesBelongToDayView dayView: SCCalendarDayView) -> Bool {
        var dayViewFrame = dayView.frame
        let weekIndex = dayView.weekView.index
        let appearance = dayView.calendarView.appearance
        
        if weekIndex > 0 {
            dayViewFrame.origin.y += dayViewFrame.height
            dayViewFrame.origin.y *= CGFloat(dayView.weekView.index)
        }
        
        if dayView != dayView.weekView.dayViews!.first! {
            dayViewFrame.origin.y += appearance.spaceBetweenWeekViews! * CGFloat(weekIndex)
        }
        
        if location.x >= dayViewFrame.origin.x && location.x <= CGRectGetMaxX(dayViewFrame) && location.y >= dayViewFrame.origin.y && location.y <= CGRectGetMaxY(dayViewFrame) {
            return true
        } else {
            return false
        }
    }
    
    func weekViewLocation(location: CGPoint, doesBelongToDayView dayView: SCCalendarDayView) -> Bool {
        let dayViewFrame = dayView.frame
        if location.x >= dayViewFrame.origin.x && location.x <= CGRectGetMaxX(dayViewFrame) && location.y >= dayViewFrame.origin.y && location.y <= CGRectGetMaxY(dayViewFrame) {
            return true
        } else {
            return false
        }
    }
    
    func ownerTouchLocation(location: CGPoint, onMonthView monthView: SCCalendarMonthView) -> DayView? {
        var owner: DayView?
        let weekViews = monthView.weekViews
        
        for weekView in weekViews {
            for dayView in weekView.dayViews! {
                if self.monthViewLocation(location, doesBelongToDayView: dayView) {
                    owner = dayView
                    return owner
                }
            }
        }
        
        
        return owner
    }
    
    func ownerTouchLocation(location: CGPoint, onWeekView weekView: SCCalendarWeekView) -> DayView? {
        var owner: DayView?
        let dayViews = weekView.dayViews
        for dayView in dayViews {
            if weekViewLocation(location, doesBelongToDayView: dayView) {
                owner = dayView
                return owner
            }
        }
        
        return owner
    }
}