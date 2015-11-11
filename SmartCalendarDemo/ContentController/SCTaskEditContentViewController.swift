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
	
	var selectedDay: DayView!
	
	let eventStore = EKEventStore();
	
	func createEvent(eventStore: EKEventStore, title: String) {
		let event = EKEvent(eventStore: eventStore)
		event.title = title
		event.startDate = NSDate();
		event.endDate = NSDate();
		//event.calendar = eventStore.defaultCalendarForNewEvents
		selectedDay.eventList.append(event)
		
	}

	@IBAction func testEvent(sender: UIButton) {
		if (EKEventStore.authorizationStatusForEntityType(.Event) != EKAuthorizationStatus.Authorized) {
			eventStore.requestAccessToEntityType(.Event, completion: {
				granted, error in
				self.createEvent(self.eventStore, title: self.eventTitle.text!)
			})
		} else {
			self.createEvent(self.eventStore, title: self.eventTitle.text!)
		}
		
	}
	
    @IBAction func goToModelView(sender: AnyObject) {
        self.performSegueWithIdentifier("goToModelViewSegue", sender: self)
    }
	
}