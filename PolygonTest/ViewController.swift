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
    
    @IBAction func btnPushButton() {
        polygon.inverted = !polygon.inverted
    }
    
    @IBAction func addPoint(sender: AnyObject) {
        polygon.addPoint()
    }
    
    @IBAction func removePointButton() {
        polygon.deleteSelectedPoint()
    }
}

