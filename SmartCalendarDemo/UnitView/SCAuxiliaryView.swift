//
//  SCAuxiliaryView.swift
//  SmartCalendar
//
//  Created by Lan Zhang on 11/4/15.
//  Copyright © 2015 Lan Zhang. All rights reserved.
//

import UIKit

public final class SCAuxiliaryView: UIView {
    public var shape: SCShape!
    public var test: CGFloat!
//    public var xcoordinate: CGFloat!
    public var additionalYCoordinator: CGFloat!
    
    //test = CGFloat(Float(arc4random()) / Float(UINT32_MAX));
    
    public var strokeColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var fillColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public let defaultFillColor = UIColor.colorFromCode(0xe74c3c)
    
    private var radius: CGFloat {
        get {
            return (min(frame.height, frame.width) - 10) / 2
        }
    }
    
    public unowned let dayView: DayView
    
    public init(dayView: DayView, rect: CGRect, shape: SCShape, additionalYCoordinator: CGFloat) {
        self.dayView = dayView
        self.shape = shape
        super.init(frame: rect)
        self.additionalYCoordinator = additionalYCoordinator
//        self.xcoordinate = xcoordinate
//        self.ycoordinate = ycoordinate
        strokeColor = UIColor.clearColor()
        fillColor = UIColor.colorFromCode(0xe74c3c)
        
        layer.cornerRadius = 5
        backgroundColor = .clearColor()
    }
    
    public override func didMoveToSuperview() {
        setNeedsDisplay()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //TODO, pass in rect height
//    public override func drawRect(rect: CGRect, workLoad: CGFloat) {
//        var path: UIBezierPath!
//        
//        if let shape = shape {
//            switch shape {
//            case .RightFlag: path = rightFlagPath()
//            case .LeftFlag: path = leftFlagPath()
//            case .Circle: path = circlePath()
//            case .Rect: path = rectPath(workLoad)
//            }
//        }
//        
//        strokeColor.setStroke()
//        fillColor.setFill()
//        
//        if let path = path {
//            path.lineWidth = 1
//            path.stroke()
//            path.fill()
//        }
//    }
    
    //TODO, pass in rect height
    public override func drawRect(rect: CGRect) {
        var path: UIBezierPath!
        //var path2:UIBezierPath!
        //let workLoad: CGFloat!
        
        //TODO
        //workLoad = self.dayView.workLoad
        //workLoad = CGFloat(arc4random());
        
        //draw origin workload
        if let shape = shape {
            switch shape {
            case .RightFlag: path = rightFlagPath()
            case .LeftFlag: path = leftFlagPath()
            case .Circle: path = circlePath()
            case .Rect: path = rectPath((self.dayView.workLoad!), xcoordinate: (0 - dayView.calendarView.appearance.spaceBetweenDayViews!), ycoordinate:(bounds.height / 3 - radius))
            }
        }
        
        strokeColor.setStroke()
        fillColor.setFill()
        
        if let path = path {
            path.lineWidth = 1
            path.stroke()
            path.fill()
        }
        
        //TODO
        //draw addtional workLoad
        
    }

    
    deinit {
        //println("[CVCalendar Recovery]: AuxiliaryView is deinited.")
    }
}

extension SCAuxiliaryView {
    public func updateFrame(frame: CGRect) {
        self.frame = frame
        setNeedsDisplay()
    }
}

extension SCAuxiliaryView {
    func circlePath() -> UIBezierPath {
        let arcCenter = CGPointMake(frame.width / 2, frame.height / 2)
        let startAngle = CGFloat(0)
        let endAngle = CGFloat(M_PI * 2.0)
        let clockwise = true
        
        let path = UIBezierPath(arcCenter: arcCenter, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
        
        return path
        
    }
    
    func rightFlagPath() -> UIBezierPath {
        //        let appearance = dayView.calendarView.appearance
        //        let offset = appearance.spaceBetweenDayViews!
        
        let flag = UIBezierPath()
        flag.moveToPoint(CGPointMake(bounds.width / 2, bounds.height / 2 - radius))
        flag.addLineToPoint(CGPointMake(bounds.width, bounds.height / 2 - radius))
        flag.addLineToPoint(CGPointMake(bounds.width, bounds.height / 2 + radius ))
        flag.addLineToPoint(CGPointMake(bounds.width / 2, bounds.height / 2 + radius))
        
        let path = CGPathCreateMutable()
        CGPathAddPath(path, nil, circlePath().CGPath)
        CGPathAddPath(path, nil, flag.CGPath)
        
        return UIBezierPath(CGPath: path)
    }
    
    func leftFlagPath() -> UIBezierPath {
        let flag = UIBezierPath()
        flag.moveToPoint(CGPointMake(bounds.width / 2, bounds.height / 2 + radius))
        flag.addLineToPoint(CGPointMake(0, bounds.height / 2 + radius))
        flag.addLineToPoint(CGPointMake(0, bounds.height / 2 - radius))
        flag.addLineToPoint(CGPointMake(bounds.width / 2, bounds.height / 2 - radius))
        
        let path = CGPathCreateMutable()
        CGPathAddPath(path, nil, circlePath().CGPath)
        CGPathAddPath(path, nil, flag.CGPath)
        
        return UIBezierPath(CGPath: path)
    }
    
    //TODO, add parameter when draw rectPath
    func rectPath(workLoad: CGFloat, xcoordinate: CGFloat, ycoordinate: CGFloat) -> UIBezierPath {
        //        let midX = bounds.width / 2
        let midY = bounds.height / 3
        
        let appearance = dayView.calendarView.appearance
        let offset = appearance.spaceBetweenDayViews!
        
        print("offset = \(offset)")
        
        let path = UIBezierPath(rect: CGRectMake(xcoordinate, ycoordinate + self.additionalYCoordinator, bounds.width + offset / 2, workLoad))
        //let path = UIBezierPath(rect: CGRectMake(0 - offset, midY - radius, bounds.width + offset / 2, radius*2))
        
        return path
    }
    


    
//    //TODO, add parameter when draw rectPath
//    func rectPath(workLoad: CGFloat) -> UIBezierPath {
//        //        let midX = bounds.width / 2
//        let midY = bounds.height / 2
//        
//        let appearance = dayView.calendarView.appearance
//        let offset = appearance.spaceBetweenDayViews!
//        
//        print("offset = \(offset)")
//        
//        let path = UIBezierPath(rect: CGRectMake(0 - offset, midY - radius, bounds.width + offset / 2, radius * 2))
//        
//        return path
//    }
}