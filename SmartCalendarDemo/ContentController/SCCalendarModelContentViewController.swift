//
//  SCCalendarModelContentViewController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/5/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public final class SCCalendarModelContentViewController: UIViewController {

    @IBOutlet weak var backToRootView: UIBarButtonItem!

    @IBAction func backToRootView(sender: AnyObject) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
}