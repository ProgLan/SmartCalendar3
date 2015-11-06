//
//  SCScrollDirection.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import Foundation

public enum SCScrollDirection {
    case None
    case Right
    case Left
    
    var description: String {
        get {
            switch self {
            case .Left: return "Left"
            case .Right: return "Right"
            case .None: return "None"
            }
        }
    }
}