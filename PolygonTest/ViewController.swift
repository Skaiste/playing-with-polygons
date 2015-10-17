//
//  ViewController.swift
//  PolygonTest
//
//  Created by Skaiste Butkute on 13/10/2015.
//  Copyright © 2015 Maahes. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var polygon: Polygon!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
        Inverting polygon
    */
    @IBAction func btnPushButton() {
        polygon.inverted = !polygon.inverted
    }
    
    /**
        Adding point to polygon
    */
    @IBAction func addPoint(sender: AnyObject) {
        polygon.addPoint()
    }
    /**
        Removing selected point in polygon
    */
    @IBAction func removePointButton() {
        polygon.deleteSelectedPoint()
    }
}

