//
//  SCTaskEditContentViewController.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/5/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public class SCTaskEditContentViewController: UIViewController{
    
    
    @IBOutlet weak var goToModelBtn: UIBarButtonItem!
    


    
    @IBAction func goToModelView(sender: AnyObject) {
        self.performSegueWithIdentifier("goToModelViewSegue", sender: self)
    }
    
}