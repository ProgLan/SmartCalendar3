//
//  SCCalendarDayViewControlCoordinator.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public final class SCCalendarDayViewControlCoordinator {
    // MARK: - Non public properties
    private var selectionSet = Set<DayView>()
    private unowned let calendarView: CalendarView
    
    // MARK: - Public properties
    public weak var selectedDayView: SCCalendarDayView?
    public var animator: SCCalendarViewAnimator! {
        get {
            return calendarView.animator
        }
    }
    
    // MARK: - initialization
    public init(calendarView: CalendarView) {
        self.calendarView = calendarView
    }
}

// MARK: - Animator side callback

extension SCCalendarDayViewControlCoordinator {
    public func selectionPerformedOnDayView(dayView: DayView) {
        // TODO:
    }
    
    public func deselectionPerformedOnDayView(dayView: DayView) {
        if dayView != selectedDayView {
            selectionSet.remove(dayView)
            dayView.setDeselectedWithClearing(true)
        }
    }
    
    public func dequeueDayView(dayView: DayView) {
        selectionSet.remove(dayView)
    }
    
    public func flush() {
        selectedDayView = nil
        selectionSet.removeAll()
    }
}

// MARK: - Animator reference

private extension SCCalendarDayViewControlCoordinator {
    func presentSelectionOnDayView(dayView: DayView) {
        animator.animateSelectionOnDayView(dayView)
        //animator?.animateSelection(dayView, withControlCoordinator: self)
    }
    
    func presentDeselectionOnDayView(dayView: DayView) {
        animator.animateDeselectionOnDayView(dayView)
        //animator?.animateDeselection(dayView, withControlCoordinator: self)
    }
}

// MARK: - Coordinator's control actions

extension SCCalendarDayViewControlCoordinator {
    public func performDayViewSingleSelection(dayView: DayView) {
        selectionSet.insert(dayView)
        
        if selectionSet.count > 1 {
            //            let count = selectionSet.count-1
            for dayViewInQueue in selectionSet {
                if dayView != dayViewInQueue {
                    if dayView.calendarView != nil {
                        presentDeselectionOnDayView(dayViewInQueue)
                    }
                    
                }
                
            }
        }
        
        if let _ = animator {
            if selectedDayView != dayView {
                selectedDayView = dayView
                presentSelectionOnDayView(dayView)
            }
        }
    }
    
    public func performDayViewRangeSelection(dayView: DayView) {
        print("Day view range selection found")
    }
}