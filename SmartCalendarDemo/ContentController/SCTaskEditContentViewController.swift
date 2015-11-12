//
//  SCTaskEditContentViewController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/5/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit
import EventKit

public class SCTaskEditContentViewController: UIViewController{
    
    
	@IBOutlet weak var eventTitle: UITextField!
	@IBOutlet weak var goToModelBtn: UIBarButtonItem!
	@IBOutlet weak var startDate: UIDatePicker!
	@IBOutlet weak var endDate: UIDatePicker!
	
	var selectedDay: DayView!
	var calendarView: SCCalendarView!
	
	let eventStore = EKEventStore();
	let calendar = NSCalendar.currentCalendar()
	
	func createEvent(day: DayView, eventStore: EKEventStore, title: String) {
		let event = EKEvent(eventStore: eventStore)
		event.title = title
		event.startDate = startDate.date;
		event.endDate = endDate.date;
		//event.calendar = eventStore.defaultCalendarForNewEvents
		day.eventList.append(event)
	}
    
    //TODO:
    override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "goToModelViewSegue") {
            let modelViewController = segue.destinationViewController as! SCCalendarModelContentViewController
            modelViewController.selectedDay = self.selectedDay
            //modelViewController.calendarView = self.calendarView
        }
    }

	
	func convertDate(day: NSDate) -> Int {
		let components = calendar.components([.Year, .Month, .Day], fromDate: day)
		let month = components.month
		let day = components.day
		return month*100 + day
	}
	
	@IBAction func testEvent(sender: UIButton) {
		let start = convertDate(startDate.date)
		let end = convertDate(endDate.date)
		if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
			eventStore.requestAccessToEntityType(.Event, completion: {
				granted, error in
				self.createEvent(self.selectedDay, eventStore: self.eventStore, title: self.eventTitle.text!)
			})
		} else {
outerloop:	for weeks in selectedDay.weekView.monthView.weekViews {
				for days in weeks.dayViews {
					let day = convertDate(days.date.getDate()!)
					if (start <= day && day <= end) {
						self.createEvent(days, eventStore: self.eventStore, title: self.eventTitle.text!)
					}
				}
			}
		}
		
	}
	
	
    @IBAction func goToModelView(sender: AnyObject) {
        self.performSegueWithIdentifier("goToModelViewSegue", sender: self)
    }
	
}