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
	
	func createEvent(day: DayView, eventStore: EKEventStore, title: String) {
		let event = EKEvent(eventStore: eventStore)
		event.title = title
		event.startDate = NSDate();
		event.endDate = NSDate();
		//event.calendar = eventStore.defaultCalendarForNewEvents
		day.eventList.append(event)
		
	}

	@IBAction func testEvent(sender: UIButton) {
		if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
			eventStore.requestAccessToEntityType(.Event, completion: {
				granted, error in
				self.createEvent(self.selectedDay, eventStore: self.eventStore, title: self.eventTitle.text!)
			})
		} else {
			for weeks in selectedDay.weekView.monthView.weekViews {
				for days in weeks.dayViews {
					self.createEvent(days, eventStore: self.eventStore, title: self.eventTitle.text!)
				}
			}
//			self.createEvent(self.selectedDay, eventStore: self.eventStore, title: self.eventTitle.text!)
		}
		
	}
	
//	override public func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//		if (segue.identifier == "goToModelViewSegue") {
//			let testViewController = segue.destinationViewController as! TestViewController
//			testViewController.calendarView = self.calendarView
//		}
//	}
	
    @IBAction func goToModelView(sender: AnyObject) {
        self.performSegueWithIdentifier("goToModelViewSegue", sender: self)
    }
	
}