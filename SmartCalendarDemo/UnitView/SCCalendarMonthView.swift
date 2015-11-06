//
//  SCCalendarMonthView.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public final class SCCalendarMonthView: UIView {
    // MARK: - Non public properties
    private var interactiveView: UIView!
    
    public override var frame: CGRect {
        didSet {
            if let calendarView = calendarView {
                if calendarView.calendarMode == CalendarMode.MonthView {
                    updateInteractiveView()
                }
            }
        }
    }
    
    private var touchController: SCCalendarTouchController {
        return calendarView.touchController
    }
    
    // MARK: - Public properties
    
    public weak var calendarView: SCCalendarView!
    public var date: NSDate!
    public var numberOfWeeks: Int!
    public var weekViews: [SCCalendarWeekView]!
    
    public var weeksIn: [[Int : [Int]]]?
    public var weeksOut: [[Int : [Int]]]?
    public var currentDay: Int?
    
    public var potentialSize: CGSize {
        get {
            return CGSizeMake(bounds.width, CGFloat(weekViews.count) * weekViews[0].bounds.height + calendarView.appearance.spaceBetweenWeekViews! * CGFloat(weekViews.count))
        }
    }
    
    // MARK: - Initialization
    
    public init(calendarView: SCCalendarView, date: NSDate) {
        super.init(frame: CGRectZero)
        self.calendarView = calendarView
        self.date = date
        commonInit()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func mapDayViews(body: (DayView) -> Void) {
        for weekView in self.weekViews {
            for dayView in weekView.dayViews {
                body(dayView)
            }
        }
    }
}

// MARK: - Creation and destruction

extension SCCalendarMonthView {
    public func commonInit() {
        let calendarManager = calendarView.manager
        safeExecuteBlock({
            self.numberOfWeeks = calendarManager.monthDateRange(self.date).countOfWeeks
            self.weeksIn = calendarManager.weeksWithWeekdaysForMonthDate(self.date).weeksIn
            self.weeksOut = calendarManager.weeksWithWeekdaysForMonthDate(self.date).weeksOut
            self.currentDay = Manager.dateRange(NSDate()).day
            }, collapsingOnNil: true, withObjects: date)
    }
}

// MARK: Content reload

extension SCCalendarMonthView {
    public func reloadViewsWithRect(frame: CGRect) {
        self.frame = frame
        
        safeExecuteBlock({
            for (index, weekView) in self.weekViews.enumerate() {
                if let size = self.calendarView.weekViewSize {
                    weekView.frame = CGRectMake(0, size.height * CGFloat(index), size.width, size.height)
                    weekView.reloadDayViews()
                }
            }
            }, collapsingOnNil: true, withObjects: weekViews)
    }
}

// MARK: - Content fill & update

extension SCCalendarMonthView {
    public func updateAppearance(frame: CGRect) {
        self.frame = frame
        createWeekViews()
    }
    
    public func createWeekViews() {
        weekViews = [SCCalendarWeekView]()
        
        safeExecuteBlock({
            for i in 0..<self.numberOfWeeks! {
                let weekView = SCCalendarWeekView(monthView: self, index: i)
                
                self.safeExecuteBlock({
                    self.weekViews!.append(weekView)
                    }, collapsingOnNil: true, withObjects: self.weekViews)
                
                self.addSubview(weekView)
            }
            }, collapsingOnNil: true, withObjects: numberOfWeeks)
    }
}

// MARK: - Interactive view management & update

extension SCCalendarMonthView {
    public func updateInteractiveView() {
        safeExecuteBlock({
            let mode = self.calendarView!.calendarMode!
            if mode == .MonthView {
                if let interactiveView = self.interactiveView {
                    interactiveView.frame = self.bounds
                    interactiveView.removeFromSuperview()
                    self.addSubview(interactiveView)
                } else {
                    self.interactiveView = UIView(frame: self.bounds)
                    self.interactiveView.backgroundColor = .clearColor()
                    
                    let tapRecognizer = UITapGestureRecognizer(target: self, action: "didTouchInteractiveView:")
                    let pressRecognizer = UILongPressGestureRecognizer(target: self, action: "didPressInteractiveView:")
                    pressRecognizer.minimumPressDuration = 0.3
                    
                    self.interactiveView.addGestureRecognizer(pressRecognizer)
                    self.interactiveView.addGestureRecognizer(tapRecognizer)
                    
                    self.addSubview(self.interactiveView)
                }
            }
            
            }, collapsingOnNil: false, withObjects: calendarView)
    }
    
    public func didPressInteractiveView(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.locationInView(self.interactiveView)
        let state: UIGestureRecognizerState = recognizer.state
        
        switch state {
        case .Began:
            touchController.receiveTouchLocation(location, inMonthView: self, withSelectionType: .Range(.Started))
        case .Changed:
            touchController.receiveTouchLocation(location, inMonthView: self, withSelectionType: .Range(.Changed))
        case .Ended:
            touchController.receiveTouchLocation(location, inMonthView: self, withSelectionType: .Range(.Ended))
            
        default: break
        }
    }
    
    public func didTouchInteractiveView(recognizer: UITapGestureRecognizer) {
        let location = recognizer.locationInView(self.interactiveView)
        touchController.receiveTouchLocation(location, inMonthView: self, withSelectionType: .Single)
    }
}

// MARK: - Safe execution

extension SCCalendarMonthView {
    public func safeExecuteBlock(block: Void -> Void, collapsingOnNil collapsing: Bool, withObjects objects: AnyObject?...) {
        for object in objects {
            if object == nil {
                if collapsing {
                    fatalError("Object { \(object) } must not be nil!")
                } else {
                    return
                }
            }
        }
        
        block()
    }
}