//
//  SCCalendarModelContentViewController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/5/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit
import Foundation

public final class SCCalendarModelContentViewController: UIViewController{

    @IBOutlet weak var backToRootView: UIBarButtonItem!

    @IBOutlet weak var calendarView: SCCalendarView!
    
    @IBOutlet weak var menuView: SCCalendarMenuView!
    
    @IBOutlet weak var monthLabel: UILabel!
    
    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    
    @IBOutlet weak var modelView: SCCalendarModelView!
    
    
    
    var shouldShowDaysOut = true
    
    
    var animationFinished = true
    
    //TODO, test if the selected dates have passed into selectedDates array
    var selectedDates = [NSDate]()
    
    var selectedDay: DayView!
    
    var currentMonthDays = [NSDate]()
    
//    @IBAction func testBtn(sender: AnyObject) {
//        let sd: NSDateComponents = NSDateComponents()
//        let ed: NSDateComponents = NSDateComponents()
//        let cd: NSDate = NSDate()
//        let recognizer: UIPanGestureRecognizer = self.panRecognizer
//        let location: CGPoint = recognizer.locationInView(recognizer.view)
//        
//        sd.year = 2015
//        sd.month = 11
//        sd.day = 15
//        
//        ed.year = 2015
//        ed.month = 11
//        ed.day = 18
//        
//        drawWorkLoadGraph(location, recognizerState: recognizer.state, startDate: sd, endDate: ed, currentDate: cd)
//        
//        
//        
//        for var i = 0; i < self.selectedDates.count; ++i {
//            
//            print("date: ",self.selectedDates[i])
//            
//        }
//        
//       
//        
//    }
    
    
    
    
    // MARK: - Life cycle
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        //TODO, inital selected day
        print("selected day's day: ", self.selectedDay.date.day)
        
        monthLabel.text = SCDate(date: NSDate()).globalDescription
        
        //TODO TEST
        let sd: NSDateComponents = NSDateComponents()
        let ed: NSDateComponents = NSDateComponents()
        let cd: NSDate = NSDate()
        let recognizer: UIPanGestureRecognizer = self.panRecognizer
        let location: CGPoint = recognizer.locationInView(recognizer.view)
        
        sd.year = 2015
        sd.month = 11
        sd.day = 15
        
        ed.year = 2015
        ed.month = 11
        ed.day = 18
        
        //self.selectedDay.date.setDate(cd)
        
        drawWorkLoadGraph(location, recognizerState: recognizer.state, startDate: sd, endDate: ed, currentDate: cd)
        
        
        
        for var i = 0; i < self.selectedDates.count; ++i {
            
            print("date: ",self.selectedDates[i])
            
        }
		
        //TODO
//        for weeks in selectedDay.weekView.monthView.weekViews{
//            for day in weeks.dayViews{
//                for selectedDate in self.selectedDates{
//                    if((day.date.getDate()?.isEqualToDate(selectedDate)) != nil){
//                        day.isSelected = true
//                    }
//                }
//            }
//        }
		
        
        //find this calendar view's all dates
        //compare it to the selectedDate
        //if is in the selectedDate, then make it selected == true
        print(self.calendarView)
        
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }

    
    @IBAction func backToRootView(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    
    @IBAction func displayGestureForPanRecognizer(recognizer:UIPanGestureRecognizer){
        
        let location: CGPoint = recognizer.locationInView(recognizer.view)
        //print(location.x + location.y)
        //self.drawWorkLoadGraph(location, recognizerState: recognizer.state)
        
        let modelVW: CGRect = self.modelView.frame
        
        if((location.x > 0 && (location.x < modelVW.size.width) && (location.y < modelVW.size.height) && (location.y > 0)))
        {
            modelView.drawCircle(panRecognizer.locationInView(panRecognizer.view))
            
            print("lcoaiton x : ", location.x)
            print("location y : ", location.y)
            print("modelView x : ", modelVW.origin.x)
            print("modelView y : ", modelVW.origin.y)
            print("modelView size heigh : ", modelVW.size.height)
            print("modelView size width : ", modelVW.size.width)
            print("outside")
            
            
            
            
        }
        
    
    }
    
}

extension SCCalendarModelContentViewController{
    public func drawWorkLoadGraph(location: CGPoint, recognizerState: UIGestureRecognizerState, startDate: NSDateComponents, endDate: NSDateComponents, currentDate: NSDate){
        //print("panned")
    
        //startdate component
        //startDay
        //enddate component
        //endday
        //numDatesSelected = endDay - startDay + 1
        //currentDate
        
        let startDay: NSInteger = startDate.day
        let endDay: NSInteger = endDate.day
        let numDatesSelected: NSInteger = endDay - startDay + 1
        
        
        self.selectedDates = self.populateSelectedDates(currentDate, numDatesSelected: numDatesSelected)
        
//        var numHoursAvailable: CGFloat = CGFloat(numDatesSelected) * 8.0
//        //two weeks of workload is maximum
//        let maxHours = CGFloat(8.0 * 14.0)
//        let maxY = self.modelView.frame.height
//        let minY = 0.0
//        let yRange = CGFloat(maxY) - CGFloat(minY)
//        
//        let workload = self.calculateWorkLoad(location, maxY: maxY, yRange: yRange, maxHours:maxHours)
//        
//        let transformingScale = workload / numHoursAvailable
//        
//        
//        let xStart = 0.0
//        let xEnd = self.modelView.frame.width
//        let yStart = maxY
//        let xRange = CGFloat(xEnd) - CGFloat(xStart)
//        
//        var bezierLocation = location
//        bezierLocation.y = CGFloat(minY)
//        
//        let tickInterval = CGFloat(xRange) / CGFloat(numDatesSelected)
//        
//        let origin: CGPoint = CGPointMake(CGFloat(xStart), yStart)
//        let endpt: CGPoint = CGPointMake(xEnd, yStart)
//        let midpt1: CGPoint = self.midPointForPoints(origin, p2: bezierLocation)
//        let midpt2: CGPoint = self.midPointForPoints(bezierLocation, p2: endpt)
//        
//        let ctrlpt1: CGPoint = CGPointMake(midpt1.x, midpt1.y + 50)
//        let ctrlpt2: CGPoint = CGPointMake(midpt2.x, midpt2.y + 50)
        
        
        
        //path.moveToPoint(origin)
        
        
        
        
        
    }
    
    
    public func midPointForPoints(var p1: CGPoint, var p2: CGPoint) -> CGPoint{
        return CGPointMake((p1.x + p2.x)/2, (p1.y + p2.y)/2)
    }
    
    
    //MARK: add a series of day to an array
    public func populateSelectedDates(var currentDate: NSDate, numDatesSelected: NSInteger) -> [NSDate]{
    
        
        var selectedDatesArray = [NSDate]()
        
        
        for var i = 0; i < numDatesSelected; ++i {
            
            selectedDatesArray.append(currentDate)
            let aDayDiff: NSDateComponents = NSDateComponents()
            aDayDiff.day = 1
            var aDayAfter: NSDate = NSDate()
            aDayAfter = NSCalendar.currentCalendar().dateByAddingComponents(aDayDiff, toDate: currentDate, options: NSCalendarOptions(rawValue: 0))!
        
            currentDate = aDayAfter
        
        }
        
        
        return selectedDatesArray
    }
    
    //TODO:
    public func calculateWorkLoad(location: CGPoint, maxY: CGFloat, yRange: CGFloat, maxHours: CGFloat) -> CGFloat{
        //let location: CGPoint = recognizer.locationInView(recognizer.view)
        let workload: CGFloat
        
        if(location.y > maxY){
            workload = 0.0
            return workload
        }
        
        workload = (maxY - location.y) / yRange * maxHours
        
        return workload
    }
    
    
    
    

}
    

// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension SCCalendarModelContentViewController: SCCalendarViewDelegate, SCCalendarMenuViewDelegate {
    
    /// Required method to implement!
    public func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    public func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    // MARK: Optional methods
    
    public func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    public func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func printHelloWorld(){
        print("hello world\n")
    }
    
    public func didSelectDayView(dayView: SCCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
    }
    
    public func presentedDateUpdated(date: SCDate) {
        if monthLabel.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = monthLabel.textColor
            updatedMonthLabel.font = monthLabel.font
            updatedMonthLabel.textAlignment = .Center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = self.monthLabel.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransformMakeTranslation(0, offset)
            updatedMonthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
            
            UIView.animateWithDuration(0.35, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.animationFinished = false
                self.monthLabel.transform = CGAffineTransformMakeTranslation(0, -offset)
                self.monthLabel.transform = CGAffineTransformMakeScale(1, 0.1)
                self.monthLabel.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransformIdentity
                
                }) { _ in
                    
                    self.animationFinished = true
                    self.monthLabel.frame = updatedMonthLabel.frame
                    self.monthLabel.text = updatedMonthLabel.text
                    self.monthLabel.transform = CGAffineTransformIdentity
                    self.monthLabel.alpha = 1
                    updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: self.monthLabel)
        }
    }
    
    public func topMarker(shouldDisplayOnDayView dayView: SCCalendarDayView) -> Bool {
        return true
    }
    
    public func dotMarker(shouldShowOnDayView dayView: SCCalendarDayView) -> Bool {
//        let day = dayView.date.day
//        let randomDay = Int(arc4random_uniform(31))
        return true
    }
    
    public func dotMarker(colorOnDayView dayView: SCCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(255)
        let green = CGFloat(0)
        let blue = CGFloat(0)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = Int(1)
        switch(numberOfDots) {
//        case 2:
//            return [color, color]
//        case 3:
//            return [color, color, color]
        default:
            return [color] // return 1 dot
        }
    }
    
    public func dotMarker(shouldMoveOnHighlightingOnDayView dayView: SCCalendarDayView) -> Bool {
        return true
    }
    
    public func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    public func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
}


// MARK: - CVCalendarViewAppearanceDelegate

extension SCCalendarModelContentViewController: SCCalendarViewAppearanceDelegate {
    public func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    public func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension SCCalendarModelContentViewController {
    @IBAction func switchChanged(sender: UISwitch) {
        if sender.on {
            calendarView.changeDaysOutShowingState(false)
            shouldShowDaysOut = true
        } else {
            calendarView.changeDaysOutShowingState(true)
            shouldShowDaysOut = false
        }
    }
    
    @IBAction func todayMonthView() {
        calendarView.toggleCurrentDayView()
    }
    
    /// Switch to WeekView mode.
    @IBAction func toWeekView(sender: AnyObject) {
        calendarView.changeMode(.WeekView)
    }
    
    /// Switch to MonthView mode.
    @IBAction func toMonthView(sender: AnyObject) {
        calendarView.changeMode(.MonthView)
    }
    
    @IBAction func loadPrevious(sender: AnyObject) {
        calendarView.loadPreviousView()
    }
    
    
    @IBAction func loadNext(sender: AnyObject) {
        calendarView.loadNextView()
    }
    
    
}

// MARK: - Convenience API Demo

extension SCCalendarModelContentViewController {
    public func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    public func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    public func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}


//MARK: -Calendar Graph

extension SCCalendarModelContentViewController {


}
