//
//  ViewController.swift
//  Tinder
//
//  Created by Milan Bojic on 2/5/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController {
    
    @IBOutlet weak var swipeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeMe(gestureRecognizer:)))
        swipeLabel.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeMe(gestureRecognizer: UIPanGestureRecognizer) {
        // get the point of swipe touch
       let swipePoint = gestureRecognizer.translation(in: view)
        swipeLabel.center = CGPoint(x: view.bounds.width / 2 + swipePoint.x, y: view.bounds.height / 2 + swipePoint.y)
        // rotation and transformation
        let xFromCenter = view.bounds.width / 2 - swipeLabel.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        swipeLabel.transform = scaledAndRotated
        
        if gestureRecognizer.state == .ended {
            if swipeLabel.center.x < (view.bounds.width / 2 - 100) {
                print("I dont like you")
            }
            if swipeLabel.center.x > (view.bounds.width / 2 + 100) {
                print("I like you")
            }
            // reset values to starting position
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            swipeLabel.transform = scaledAndRotated
            swipeLabel.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    


}

