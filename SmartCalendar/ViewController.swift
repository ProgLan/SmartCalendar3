//
//  ViewController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/2/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit
import EventKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    // MARK: - Properties
    @IBOutlet weak var calendarView: SCCalendarView!
    @IBOutlet weak var menuView: SCCalendarMenuView!
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var addEventBtn: UIBarButtonItem!
	@IBOutlet weak var tableView: UITableView!
	
    var shouldShowDaysOut = true
    var animationFinished = true
	
	var selectedDay: DayView!
	var eventListForTheDay = [EKEvent]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
        monthLabel.text = SCDate(date: NSDate()).globalDescription

    }
	
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
		
        calendarView.commitCalendarViewUpdate()
        menuView.commitMenuViewUpdate()
    }
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
		if (segue.identifier == "goToTaskEditViewSegue") {
			let addEventViewController = segue.destinationViewController as! SCTaskEditContentViewController
			addEventViewController.selectedDay = self.selectedDay
			
		}
	}
    
    @IBAction func goToTaskEditView(sender: AnyObject) {
        self.performSegueWithIdentifier("goToTaskEditViewSegue", sender: self)
    }
	
	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return eventListForTheDay.count
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCellWithIdentifier("EventTableViewCell", forIndexPath: indexPath)
		
		let event = eventListForTheDay[indexPath.row]
		cell.textLabel!.text = event.title
		print(event.title)
		
		return cell
	}
	
}




// MARK: - CVCalendarViewDelegate & CVCalendarMenuViewDelegate

extension ViewController: SCCalendarViewDelegate, SCCalendarMenuViewDelegate {
    
    /// Required method to implement!
    func presentationMode() -> CalendarMode {
        return .MonthView
    }
    
    /// Required method to implement!
    func firstWeekday() -> Weekday {
        return .Sunday
    }
    
    
    // MARK: Optional methods
    
    func shouldShowWeekdaysOut() -> Bool {
        return shouldShowDaysOut
    }
    
    func shouldAnimateResizing() -> Bool {
        return true // Default value is true
    }
    
    func didSelectDayView(dayView: SCCalendarDayView, animationDidFinish: Bool) {
        print("\(dayView.date.commonDescription) is selected!")
		print(dayView.date.getDate())
		selectedDay = dayView
		eventListForTheDay = selectedDay.eventList
		tableView.reloadData()
    }
    
    func presentedDateUpdated(date: SCDate) {
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
    
    func topMarker(shouldDisplayOnDayView dayView: SCCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(shouldShowOnDayView dayView: SCCalendarDayView) -> Bool {
        let day = dayView.date.day
        let randomDay = Int(arc4random_uniform(31))
        if day == randomDay {
            return true
        }
        
        return false
    }
    
    func dotMarker(colorOnDayView dayView: SCCalendarDayView) -> [UIColor] {
        
        let red = CGFloat(255)
        let green = CGFloat(255)
        let blue = CGFloat(255)
        
        let color = UIColor(red: red, green: green, blue: blue, alpha: 1)
        
        let numberOfDots = 1
        switch(numberOfDots) {
//        case 2:
//            return [color, color,color]
//        case 3:
//            return [color, color, color]
        default:
            return [color, color, color] // return 1 dot
        }
    }
    
    func dotMarker(shouldMoveOnHighlightingOnDayView dayView: SCCalendarDayView) -> Bool {
        return true
    }
    
    func dotMarker(sizeOnDayView dayView: DayView) -> CGFloat {
        return 13
    }
    
    
    func weekdaySymbolType() -> WeekdaySymbolType {
        return .Short
    }
    
}

// MARK: - CVCalendarViewDelegate

//extension ViewController: CVCalendarViewDelegate {
//func preliminaryView(viewOnDayView dayView: DayView) -> UIView {
//let circleView = CVAuxiliaryView(dayView: dayView, rect: dayView.bounds, shape: CVShape.Circle)
//circleView.fillColor = .colorFromCode(0xCCCCCC)
//return circleView
//}
//
//func preliminaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//if (dayView.isCurrentDay) {
//return true
//}
//return false
//}
//
//func supplementaryView(viewOnDayView dayView: DayView) -> UIView {
//let π = M_PI
//
//let ringSpacing: CGFloat = 3.0
//let ringInsetWidth: CGFloat = 1.0
//let ringVerticalOffset: CGFloat = 1.0
//var ringLayer: CAShapeLayer!
//let ringLineWidth: CGFloat = 4.0
//let ringLineColour: UIColor = .blueColor()
//
//let newView = UIView(frame: dayView.bounds)
//
//let diameter: CGFloat = (newView.bounds.width) - ringSpacing
//let radius: CGFloat = diameter / 2.0
//
//let rect = CGRectMake(newView.frame.midX-radius, newView.frame.midY-radius-ringVerticalOffset, diameter, diameter)
//
//ringLayer = CAShapeLayer()
//newView.layer.addSublayer(ringLayer)
//
//ringLayer.fillColor = nil
//ringLayer.lineWidth = ringLineWidth
//ringLayer.strokeColor = ringLineColour.CGColor
//
//let ringLineWidthInset: CGFloat = CGFloat(ringLineWidth/2.0) + ringInsetWidth
//let ringRect: CGRect = CGRectInset(rect, ringLineWidthInset, ringLineWidthInset)
//let centrePoint: CGPoint = CGPointMake(ringRect.midX, ringRect.midY)
//let startAngle: CGFloat = CGFloat(-π/2.0)
//let endAngle: CGFloat = CGFloat(π * 2.0) + startAngle
//let ringPath: UIBezierPath = UIBezierPath(arcCenter: centrePoint, radius: ringRect.width/2.0, startAngle: startAngle, endAngle: endAngle, clockwise: true)
//
//ringLayer.path = ringPath.CGPath
//ringLayer.frame = newView.layer.bounds
//
//return newView
//}
//
//func supplementaryView(shouldDisplayOnDayView dayView: DayView) -> Bool {
//if (Int(arc4random_uniform(3)) == 1) {
//return true
//}
//
//return false
//}
//}


// MARK: - CVCalendarViewAppearanceDelegate

extension ViewController: SCCalendarViewAppearanceDelegate {
    func dayLabelPresentWeekdayInitallyBold() -> Bool {
        return false
    }
    
    func spaceBetweenDayViews() -> CGFloat {
        return 2
    }
}

// MARK: - IB Actions

extension ViewController {
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

extension ViewController {
    func toggleMonthViewWithMonthOffset(offset: Int) {
        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(NSDate()) // from today
        
        components.month += offset
        
        let resultDate = calendar.dateFromComponents(components)!
        
        self.calendarView.toggleViewWithDate(resultDate)
    }
    
    func didShowNextMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
    
    func didShowPreviousMonthView(date: NSDate)
    {
        //        let calendar = NSCalendar.currentCalendar()
        //        let calendarManager = calendarView.manager
        let components = Manager.componentsForDate(date) // from today
        
        print("Showing Month: \(components.month)")
    }
    
}


