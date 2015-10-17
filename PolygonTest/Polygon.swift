//
//  Polygon.swift
//  PolygonTest
//
//  Created by Skaiste Butkute on 13/10/2015.
//  Copyright © 2015 Maahes. All rights reserved.
//

import UIKit

@IBDesignable class Polygon: UIView {

    @IBInspectable var inverted: Bool = false {
        didSet {
                setNeedsDisplay()
        }
    }
    @IBInspectable var selectedPoint: Int = 0 {
        didSet {
            selectedPoint = selectedPoint % pointArray.count
            selectedPoint = (selectedPoint < 0) ? -selectedPoint : selectedPoint
            setNeedsDisplay()
        }
    }
    @IBInspectable var fillColor: UIColor = UIColor.greenColor()
    @IBInspectable var pointColor: UIColor = UIColor.greenColor()
    
    var pointArray: [CGPoint] = [CGPoint(x: 37.5, y: 112.5),
        CGPoint(x: 75.0, y: 37.5),
        CGPoint(x: 150, y: 112.5),
        CGPoint(x: 187.5, y: 37.5),
        CGPoint(x: 225.0, y: 75.0),
        CGPoint(x: 262.5, y: 75.0),
        CGPoint(x: 187.5, y: 187.5),
        CGPoint(x: 262.5, y: 225.0),
        CGPoint(x: 225.0, y: 262.5),
        CGPoint(x: 112.5, y: 225.0),
        CGPoint(x: 75.0, y: 262.5),
        CGPoint(x: 37.5, y: 187.5),
        CGPoint(x: 75.0, y: 150.0)] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    let selectedPointRadius: CGFloat = 20.0
    
    // for touches
    var selectedIsTouched: Bool = false
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        
        let width = rect.width
        let height = rect.height
        
        let points = pointArray
        
        // Filling the polygon if it is not inverted
        if !inverted {
            let path = UIBezierPath()
            
            for p in points {
                if p == points[0] {
                    path.moveToPoint(p)
                }
                else {
                    path.addLineToPoint(p)
                }
            }
            path.closePath()
            fillColor = fillColor.colorWithAlphaComponent(1.0)
            fillColor.setFill()
            path.fill()
        }
        // Filling everything outside polygon if it is inverted
        else {
            
            let path = UIBezierPath()
            
            // Starting with the point which is closest to the first point in array
            
            let startingPoint: CGPoint = getClosestCorner(points[0], width: width, height: height)
            
            path.moveToPoint(startingPoint)
            
            // Adding all points in the point array
            
            for p in points {
                path.addLineToPoint(p)
            }
            
            // Adding the first point in array, starting point and all corner points that are left
            
            path.addLineToPoint(points[0])
            
            path.addLineToPoint(startingPoint)
            // getting corner points
            let cornerPoints: [CGPoint] = cornerPointsFromTo(startingPoint, to: startingPoint, width: width, height: height)
            for p in cornerPoints{
                path.addLineToPoint(p)
            }
            
            path.closePath();
            fillColor = fillColor.colorWithAlphaComponent(0.5)
            fillColor.setFill()
            path.fill()
        }
        
        // Draw points
        let pSize: CGFloat = selectedPointRadius / 2
        for p in points {
            let pointPath = UIBezierPath(ovalInRect: CGRect(x: p.x - pSize/2, y: p.y - pSize/2, width: pSize, height: pSize))
            pointColor.setFill()
            pointPath.fill()
        }
        // Selected point
        let point: CGPoint = points[selectedPoint]
        let pointPath = UIBezierPath(ovalInRect: CGRect(x: point.x - pSize, y: point.y - pSize, width: selectedPointRadius, height: selectedPointRadius))
        pointColor.setStroke()
        pointPath.stroke()
    }
    
    // TOUCHES!!!
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first {
            // p - touched point
            let p = touch.locationInView(self)
            var selectedP = pointArray[selectedPoint]
            print(p)
            
            // if the selected point is touched
            if p.x > selectedP.x - selectedPointRadius/2  &&
                p.x < selectedP.x + selectedPointRadius/2 &&
                p.y > selectedP.y - selectedPointRadius/2 &&
                p.y < selectedP.y + selectedPointRadius/2 {
                    selectedIsTouched = true
            }
            // if other point is touched, searches for that point
            else {
                for var i = 0; i < pointArray.count; i++ {
                    selectedP = pointArray[i]
                    if p.x > selectedP.x - selectedPointRadius/2  &&
                        p.x < selectedP.x + selectedPointRadius/2 &&
                        p.y > selectedP.y - selectedPointRadius/2 &&
                        p.y < selectedP.y + selectedPointRadius/2 {
                            selectedPoint = i
                            selectedIsTouched = true
                    }
                }
            }
            
        }
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            //print(touch.locationInView(self))
            selectedIsTouched = false
        }
        super.touchesEnded(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if let touch = touches.first{
            let p = touch.locationInView(self)
            //print(p)
            
            // if the selected point is touched it lets change its coordinates to the ones that are touched
            if (selectedIsTouched &&
                p.x >= 0.0 && p.x <= self.frame.width &&
                p.y >= 0.0 && p.y <= self.frame.height){
                    pointArray[selectedPoint] = p
            }
        }
        super.touchesMoved(touches, withEvent: event)
    }
    
    /**
        Gets an array of corner points from one to another int anti-clockwise order
        
        @param from Point which indicates from which point array should start
        @param to Point which indicates to which point array should end
        @param width Width of the frame
        @param height Height of the frame
    
        @return An array of corner points (points 'from' and 'to' not included)
    */
    func cornerPointsFromTo(from: CGPoint, to: CGPoint, width: CGFloat, height: CGFloat) -> [CGPoint] {
        var cornerPoints: [CGPoint] = []
        // moving anti-clockwise
        
        var corners: [CGPoint] = [CGPoint(x: 0.0, y: 0.0),
            CGPoint(x: 0.0, y: height / 2),
            CGPoint(x: 0.0, y: height),
            CGPoint(x: width / 2, y: height),
            CGPoint(x: width, y: height),
            CGPoint(x: width, y: height / 2),
            CGPoint(x: width, y: 0.0),
            CGPoint(x: width / 2, y: 0.0)]
        
        var found: Bool = false
        var ended: Bool = false
        
        for var i = 0; !found || !ended; i = (i + 1) % corners.count{
            // if the first point was not found before, but now it is 
            // starts putting points to array
            if !found && from == corners[i]{
                found = true
            }
            // if the first point was found and the last one is found 
            // stops putting points to array
            else if found && to == corners[i]{
                ended = true
            }
            // if the first point was found 
            // adds the current point to array
            else if found {
                cornerPoints.append(corners[i])
            }
        }
        
        
        return cornerPoints
    }
    /**
        Gets the closest corner to the given point
        
        @param p The given point
        @param width The width of the frame
        @param height the height of the frame
        
        @return Closest corner to the point (may be a middle of 2 closest corners)
    */
    func getClosestCorner(p: CGPoint, width: CGFloat, height: CGFloat) -> CGPoint {
        
        var x, y : CGFloat
        
        // x coordinate
        if (p.x < width / 2){
            x = 0.0
        } else if (p.x > width / 2) {
            x = width
        } else{
            x = width / 2
        }
        // y coordinate
        if (p.y < height / 2) {
            y = 0.0
        } else if (p.y > height / 2){
            y = height
        } else {
            y = height / 2
        }
        return CGPoint(x: x, y: y)
    }
    
    /**
        Adds a point in the middle of selected and next to selected points
    */
    func addPoint() {
        let nextPointIndex = (selectedPoint + 1) % pointArray.count
        // calculates position of middle point
        let x: CGFloat = pointArray[selectedPoint].x + (pointArray[nextPointIndex].x - pointArray[selectedPoint].x)/2
        let y: CGFloat = pointArray[selectedPoint].y + (pointArray[nextPointIndex].y - pointArray[selectedPoint].y)/2
        
        pointArray.insert(CGPoint(x: x, y: y), atIndex: nextPointIndex)
        selectedPoint = nextPointIndex
    }
    
    /**
        Deletes selected point from polygon (point array)
    */
    func deleteSelectedPoint() {
        if (pointArray.count > 0){
            pointArray.removeAtIndex(selectedPoint)
            selectedPoint = (selectedPoint - 1 < 0) ? pointArray.count - 1 : selectedPoint - 1;
        }
    }
}
