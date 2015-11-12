//
//  SCCalendarDayView.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit
import EventKit

public typealias ModelContentViewController = SCCalendarModelContentViewController

public final class SCCalendarDayView: UIView {
    public var ModelContentViewController: SCCalendarModelContentViewController!

    
    // MARK: - Public properties
    public let weekdayIndex: Int!
    public weak var weekView: SCCalendarWeekView!
    
    public var date: SCDate!
    public var dayLabel: UILabel!
    
    public var circleView: SCAuxiliaryView?
    public var topMarker: CALayer?
    public var dotMarkers = [SCAuxiliaryView?]()
    
    public var isOut = false
    public var isCurrentDay = false
	
	public var eventList = [EKEvent]()
    
    //TODO workload = Sum(time of all events in this day view's event list)
    public var workLoad:CGFloat!
    //TODO the time the new event distributed into this day
    public var additionWorkLoad:CGFloat!
    
    
    //TODO: if this day has been selected by a task
    public var isSelected = false
    
    
    
    
    public weak var monthView: SCCalendarMonthView! {
        get {
            var monthView: MonthView!
            if let weekView = weekView, let activeMonthView = weekView.monthView {
                monthView = activeMonthView
            }
            
            return monthView
        }
    }
    
    public weak var calendarView: SCCalendarView! {
        get {
            var calendarView: SCCalendarView!
            if let weekView = weekView, let activeCalendarView = weekView.calendarView {
                calendarView = activeCalendarView
            }
            
            return calendarView
        }
    }
    
    public override var frame: CGRect {
        didSet {
            if oldValue != frame {
                circleView?.setNeedsDisplay()
                topMarkerSetup()
                preliminarySetup()
                supplementarySetup()
            }
        }
    }
    
    public override var hidden: Bool {
        didSet {
            userInteractionEnabled = hidden ? false : true
        }
    }
    
    // MARK: - Initialization
    
    public init(weekView: SCCalendarWeekView, weekdayIndex: Int) {
        self.weekView = weekView
        self.weekdayIndex = weekdayIndex
        //TODO, change random workload to daily workload
        self.workLoad = CGFloat(Float(arc4random()) / Float(UINT32_MAX))
        
        
        if let size = weekView.calendarView.dayViewSize {
            let hSpace = weekView.calendarView.appearance.spaceBetweenDayViews!
            let x = (CGFloat(weekdayIndex - 1) * (size.width + hSpace)) + (hSpace/2)
            super.init(frame: CGRectMake(x, 0, size.width, size.height))
        } else {
            super.init(frame: CGRectZero)
        }
        
        date = dateWithWeekView(weekView, andWeekIndex: weekdayIndex)
        
        labelSetup()
        setupDotMarker()
        topMarkerSetup()
        
        if (frame.width > 0) {
            preliminarySetup()
            supplementarySetup()
        }
        
        if !calendarView.shouldShowWeekdaysOut && isOut {
            hidden = true
        }
        
        //var temp = ModelContentViewController
        
        //TODO, check if the selected array is nil
//        if(ModelContentViewController != nil){
//            
//            for var i = 0; i < ModelContentViewController.selectedDates.count; ++i{
//                let selectDate: NSDate = ModelContentViewController.selectedDates[i]
//                
//                if(selectDate.isEqualToDate(self.date.getDate()!)){
//                    self.isSelected = true
//                }
//            }
//        
//        }
        
    }
    
    
    
    
    
    public func dateWithWeekView(weekView: SCCalendarWeekView, andWeekIndex index: Int) -> SCDate {
        func hasDayAtWeekdayIndex(weekdayIndex: Int, weekdaysDictionary: [Int : [Int]]) -> Bool {
            for key in weekdaysDictionary.keys {
                if key == weekdayIndex {
                    return true
                }
            }
            
            return false
        }
        
        
        var day: Int!
        let weekdaysIn = weekView.weekdaysIn
        
        if let weekdaysOut = weekView.weekdaysOut {
            if hasDayAtWeekdayIndex(weekdayIndex, weekdaysDictionary: weekdaysOut) {
                isOut = true
                day = weekdaysOut[weekdayIndex]![0]
            } else if hasDayAtWeekdayIndex(weekdayIndex, weekdaysDictionary: weekdaysIn!) {
                day = weekdaysIn![weekdayIndex]![0]
            }
        } else {
            day = weekdaysIn![weekdayIndex]![0]
        }
        
        if day == monthView.currentDay && !isOut {
            let dateRange = Manager.dateRange(monthView.date)
            let currentDateRange = Manager.dateRange(NSDate())
            
            if dateRange.month == currentDateRange.month && dateRange.year == currentDateRange.year {
                isCurrentDay = true
            }
        }
        
        
        let dateRange = Manager.dateRange(monthView.date)
        let year = dateRange.year
        let week = weekView.index + 1
        var month = dateRange.month
        
        if isOut {
            day > 20 ? month-- : month++
        }
        
        return SCDate(day: day, month: month, week: week, year: year)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

// MARK: - Subviews setup

extension SCCalendarDayView {
    public func labelSetup() {
        let appearance = calendarView.appearance
        
        dayLabel = UILabel()
        dayLabel!.text = String(date.day)
        dayLabel!.textAlignment = NSTextAlignment.Center
        dayLabel!.frame = bounds
        
        var font = appearance.dayLabelWeekdayFont
        var color: UIColor?
        
        if isOut {
            color = appearance.dayLabelWeekdayOutTextColor
        } else if isCurrentDay {
            let coordinator = calendarView.coordinator
            if coordinator.selectedDayView == nil && calendarView.shouldAutoSelectDayOnMonthChange {
                let touchController = calendarView.touchController
                touchController.receiveTouchOnDayView(self)
                calendarView.didSelectDayView(self)
            } else {
                color = appearance.dayLabelPresentWeekdayTextColor
                if appearance.dayLabelPresentWeekdayInitallyBold! {
                    font = appearance.dayLabelPresentWeekdayBoldFont
                } else {
                    font = appearance.dayLabelPresentWeekdayFont
                }
            }
            
        } else {
            color = appearance.dayLabelWeekdayInTextColor
        }
        
        if color != nil && font != nil {
            dayLabel!.textColor = color!
            dayLabel!.font = font
        }
        
        addSubview(dayLabel!)
    }
    
    public func preliminarySetup() {
        if let delegate = calendarView.delegate, shouldShow = delegate.preliminaryView?(shouldDisplayOnDayView: self) where shouldShow {
            if let preView = delegate.preliminaryView?(viewOnDayView: self) {
                insertSubview(preView, atIndex: 0)
                preView.layer.zPosition = CGFloat(-MAXFLOAT)
            }
        }
    }
    
    public func supplementarySetup() {
        if let delegate = calendarView.delegate, shouldShow = delegate.supplementaryView?(shouldDisplayOnDayView: self) where shouldShow {
            if let supView = delegate.supplementaryView?(viewOnDayView: self) {
                insertSubview(supView, atIndex: 0)
            }
        }
    }
    
    // TODO: Make this widget customizable
    public func topMarkerSetup() {
        safeExecuteBlock({
            func createMarker() {
                let height = CGFloat(0.5)
                let layer = CALayer()
                layer.borderColor = UIColor.grayColor().CGColor
                layer.borderWidth = height
                layer.frame = CGRectMake(0, 1, CGRectGetWidth(self.frame), height)
                
                self.topMarker = layer
                self.layer.addSublayer(self.topMarker!)
            }
            
            if let delegate = self.calendarView.delegate {
                if self.topMarker != nil {
                    self.topMarker?.removeFromSuperlayer()
                    self.topMarker = nil
                }
                
                if let shouldDisplay = delegate.topMarker?(shouldDisplayOnDayView: self) where shouldDisplay {
                    createMarker()
                }
            } else {
                if self.topMarker == nil {
                    createMarker()
                } else {
                    self.topMarker?.removeFromSuperlayer()
                    self.topMarker = nil
                    createMarker()
                }
            }
            }, collapsingOnNil: false, withObjects: weekView, weekView.monthView, weekView.monthView)
    }
    
    public func setupDotMarker() {
        for (index, dotMarker) in dotMarkers.enumerate() {
            dotMarker!.removeFromSuperview()
            dotMarkers[index] = nil
        }
        
        if let delegate = calendarView.delegate {
            //display rect in all dates
            if self.isSelected == true {
                
                var (width, height): (CGFloat, CGFloat) = (13, 13)
                if let size = delegate.dotMarker?(sizeOnDayView: self) {
                    (width, height) = (size,size)
                }
                //TODO: change all colors into grey
                //let colors = isOut ? [.grayColor()] : delegate.dotMarker?(colorOnDayView: self)
                let colors = isOut ? [.grayColor()] : delegate.dotMarker?(colorOnDayView: self)
            
                var yOffset = bounds.height / 5
                if let y = delegate.dotMarker?(moveOffsetOnDayView: self) {
                    yOffset = y
                }
                let y = CGRectGetMidY(frame) + yOffset
                let markerFrame = CGRectMake(0, 0, width, height)
                
                if (colors!.count > 3) {
                    assert(false, "Only 3 dot markers allowed per day")
                }
            
            
                for (index, color) in (colors!).enumerate() {
                    var x: CGFloat = 0
                    switch(colors!.count) {
                    case 1:
                        x = frame.width / 2
                    case 2:
                        x = frame.width * CGFloat(2+index)/5.00 // frame.width * (2/5, 3/5)
                    case 3:
                        x = frame.width * CGFloat(2+index)/6.00 // frame.width * (1/3, 1/2, 2/3)
                    default:
                        break
                    }
                    
                    //original workload
                    let dotMarker = SCAuxiliaryView(dayView: self, rect: markerFrame,
                        //TODO, change from circle to Rect
                        shape: .Rect, additionalYCoordinator: 0)
                    dotMarker.fillColor = color
                    dotMarker.center = CGPointMake(x, y)
                    insertSubview(dotMarker, atIndex: 0)
                    
                    dotMarker.setNeedsDisplay()
                    dotMarkers.append(dotMarker)
                    
                    
                    //additional workload
                    let dotMarker2 = SCAuxiliaryView(dayView: self, rect: markerFrame,
                        //TODO, change from circle to Rect
                        //TODO:addtionalYCoordinator is the time of new event distributed into today
                        shape: .Rect, additionalYCoordinator: 5)
                    dotMarker2.fillColor = color
                    dotMarker2.center = CGPointMake(x, y)
                    insertSubview(dotMarker2, atIndex: 0)
                    
                    dotMarker.setNeedsDisplay()
                    dotMarkers.append(dotMarker2)

                }
                
                let coordinator = calendarView.coordinator
                if self == coordinator.selectedDayView {
                    moveDotMarkerBack(false, coloring: false)
                }
            }
        }
    }
}

// MARK: - Dot marker movement

extension SCCalendarDayView {
    public func moveDotMarkerBack(unwinded: Bool, var coloring: Bool) {
        for dotMarker in dotMarkers {
            
            if let calendarView = calendarView, let dotMarker = dotMarker {
                var shouldMove = true
                if let delegate = calendarView.delegate, let move = delegate.dotMarker?(shouldMoveOnHighlightingOnDayView: self) where !move {
                    shouldMove = move
                }
                
                func colorMarker() {
                    if let delegate = calendarView.delegate {
                        let appearance = calendarView.appearance
                        var color: UIColor?
                        if unwinded {
                            if let myColor = delegate.dotMarker?(colorOnDayView: self) {
                                color = (isOut) ? appearance.dayLabelWeekdayOutTextColor : myColor.first
                            }
                        } else {
                            color = appearance.dotMarkerColor
                        }
                        
                        dotMarker.fillColor = color
                        dotMarker.setNeedsDisplay()
                    }
                    
                }
                
                func moveMarker() {
                    var transform: CGAffineTransform!
                    if let circleView = circleView {
                        let point = pointAtAngle(CGFloat(-90).toRadians(), withinCircleView: circleView)
                        let spaceBetweenDotAndCircle = CGFloat(1)
                        let offset = point.y - dotMarker.frame.origin.y - dotMarker.bounds.height/2 + spaceBetweenDotAndCircle
                        transform = unwinded ? CGAffineTransformIdentity : CGAffineTransformMakeTranslation(0, offset)
                        
                        if dotMarker.center.y + offset > CGRectGetMaxY(frame) {
                            coloring = true
                        }
                    } else {
                        transform = CGAffineTransformIdentity
                    }
                    
                    if !coloring {
                        UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                            dotMarker.transform = transform
                            }, completion: { _ in
                                
                        })
                    } else {
                        moveDotMarkerBack(unwinded, coloring: coloring)
                    }
                }
                
                if shouldMove && !coloring {
                    moveMarker()
                } else {
                    colorMarker()
                }
            }
        }
    }
}


// MARK: - Circle geometry

extension CGFloat {
    public func toRadians() -> CGFloat {
        return CGFloat(self) * CGFloat(M_PI / 180)
    }
    
    public func toDegrees() -> CGFloat {
        return CGFloat(180/M_PI) * self
    }
}

extension SCCalendarDayView {
    public func pointAtAngle(angle: CGFloat, withinCircleView circleView: UIView) -> CGPoint {
        let radius = circleView.bounds.width / 2
        let xDistance = radius * cos(angle)
        let yDistance = radius * sin(angle)
        
        let center = circleView.center
        let x = floor(cos(angle)) < 0 ? center.x - xDistance : center.x + xDistance
        let y = center.y - yDistance
        
        let result = CGPointMake(x, y)
        
        return result
    }
    
    public func moveView(view: UIView, onCircleView circleView: UIView, fromAngle angle: CGFloat, toAngle endAngle: CGFloat, straight: Bool) {
        //        let condition = angle > endAngle ? angle > endAngle : angle < endAngle
        if straight && angle < endAngle || !straight && angle > endAngle {
            UIView.animateWithDuration(pow(10, -1000), delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                let angle = angle.toRadians()
                view.center = self.pointAtAngle(angle, withinCircleView: circleView)
                }) { _ in
                    let speed = CGFloat(750).toRadians()
                    let newAngle = straight ? angle + speed : angle - speed
                    self.moveView(view, onCircleView: circleView, fromAngle: newAngle, toAngle: endAngle, straight: straight)
            }
        }
    }
}

// MARK: - Day label state management

extension SCCalendarDayView {
    public func setSelectedWithType(type: SelectionType) {
        let appearance = calendarView.appearance
        var backgroundColor: UIColor!
        var backgroundAlpha: CGFloat!
        var shape: SCShape!
        
        switch type {
        case .Single:
            shape = .Circle
            if isCurrentDay {
                dayLabel?.textColor = appearance.dayLabelPresentWeekdaySelectedTextColor!
                dayLabel?.font = appearance.dayLabelPresentWeekdaySelectedFont
                backgroundColor = appearance.dayLabelPresentWeekdaySelectedBackgroundColor
                backgroundAlpha = appearance.dayLabelPresentWeekdaySelectedBackgroundAlpha
            } else {
                dayLabel?.textColor = appearance.dayLabelWeekdaySelectedTextColor
                dayLabel?.font = appearance.dayLabelWeekdaySelectedFont
                backgroundColor = appearance.dayLabelWeekdaySelectedBackgroundColor
                backgroundAlpha = appearance.dayLabelWeekdaySelectedBackgroundAlpha
            }
            
        case .Range:
            shape = .Rect
            if isCurrentDay {
                dayLabel?.textColor = appearance.dayLabelPresentWeekdayHighlightedTextColor!
                dayLabel?.font = appearance.dayLabelPresentWeekdayHighlightedFont
                backgroundColor = appearance.dayLabelPresentWeekdayHighlightedBackgroundColor
                backgroundAlpha = appearance.dayLabelPresentWeekdayHighlightedBackgroundAlpha
            } else {
                dayLabel?.textColor = appearance.dayLabelWeekdayHighlightedTextColor
                dayLabel?.font = appearance.dayLabelWeekdayHighlightedFont
                backgroundColor = appearance.dayLabelWeekdayHighlightedBackgroundColor
                backgroundAlpha = appearance.dayLabelWeekdayHighlightedBackgroundAlpha
            }
        }
        
        if let circleView = circleView where circleView.frame != dayLabel.bounds {
            circleView.frame = dayLabel.bounds
        } else {
            circleView = SCAuxiliaryView(dayView: self, rect: dayLabel.bounds, shape: shape, additionalYCoordinator:0)
        }
        
        circleView!.fillColor = backgroundColor
        circleView!.alpha = backgroundAlpha
        circleView!.setNeedsDisplay()
        insertSubview(circleView!, atIndex: 0)
        
        moveDotMarkerBack(false, coloring: false)
    }
    
    public func setDeselectedWithClearing(clearing: Bool) {
        if let calendarView = calendarView, let appearance = calendarView.appearance {
            var color: UIColor?
            if isOut {
                color = appearance.dayLabelWeekdayOutTextColor
            } else if isCurrentDay {
                color = appearance.dayLabelPresentWeekdayTextColor
            } else {
                color = appearance.dayLabelWeekdayInTextColor
            }
            
            var font: UIFont?
            if isCurrentDay {
                if appearance.dayLabelPresentWeekdayInitallyBold! {
                    font = appearance.dayLabelPresentWeekdayBoldFont
                } else {
                    font = appearance.dayLabelWeekdayFont
                }
            } else {
                font = appearance.dayLabelWeekdayFont
            }
            
            dayLabel?.textColor = color
            dayLabel?.font = font
            
            moveDotMarkerBack(true, coloring: false)
            
            if clearing {
                circleView?.removeFromSuperview()
            }
        }
    }
}


// MARK: - Content reload

extension SCCalendarDayView {
    public func reloadContent() {
        setupDotMarker()
        dayLabel?.frame = bounds
        
        let shouldShowDaysOut = calendarView.shouldShowWeekdaysOut!
        if !shouldShowDaysOut {
            if isOut {
                hidden = true
            }
        } else {
            if isOut {
                hidden = false
            }
        }
        
        if circleView != nil {
            setSelectedWithType(.Single)
        }
    }
}

// MARK: - Safe execution

extension SCCalendarDayView {
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