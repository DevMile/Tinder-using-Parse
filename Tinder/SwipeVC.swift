//
//  SwipeVC.swift
//  Tinder
//
//  Created by Milan Bojic on 2/5/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class SwipeVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    var displayedUserID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateImage()
        
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(swipeMe(gestureRecognizer:)))
        userImage.addGestureRecognizer(swipeGesture)
        
    }
    
    @objc func swipeMe(gestureRecognizer: UIPanGestureRecognizer) {
        // get the point of swipe touch
        let swipePoint = gestureRecognizer.translation(in: view)
        userImage.center = CGPoint(x: view.bounds.width / 2 + swipePoint.x, y: view.bounds.height / 2 + swipePoint.y)
        // rotation and transformation
        let xFromCenter = view.bounds.width / 2 - userImage.center.x
        var rotation = CGAffineTransform(rotationAngle: xFromCenter / 200)
        let scale = min(100 / abs(xFromCenter), 1)
        var scaledAndRotated = rotation.scaledBy(x: scale, y: scale)
        userImage.transform = scaledAndRotated
        // Define states for left and right swipes
        if gestureRecognizer.state == .ended {
            var acceptedOrRejected = ""
            
            if userImage.center.x < (view.bounds.width / 2 - 100) {
                acceptedOrRejected = "rejected"
            }
            if userImage.center.x > (view.bounds.width / 2 + 100) {
                acceptedOrRejected = "accepted"
            }
            if acceptedOrRejected != "" && displayedUserID != "" {
                PFUser.current()?.addUniqueObject(displayedUserID, forKey: acceptedOrRejected)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        self.updateImage()
                    }
                })
            }
            // reset values to starting position
            rotation = CGAffineTransform(rotationAngle: 0)
            scaledAndRotated = rotation.scaledBy(x: 1, y: 1)
            userImage.transform = scaledAndRotated
            userImage.center = CGPoint(x: view.bounds.width / 2, y: view.bounds.height / 2)
        }
    }
    
    func updateImage() {
        if let query = PFUser.query() {
            // Get users per their interests
            if let interestedInWomen = PFUser.current()?["interestedInWomen"] {
                query.whereKey("isWoman", equalTo: interestedInWomen)
            }
            // Leave out already swiped users
            var alreadySwipedUsers = [String]()
            if let acceptedUsers = PFUser.current()?["accepted"] as? [String] {
                alreadySwipedUsers += acceptedUsers
            }
            if let rejectedUsers = PFUser.current()?["rejected"] as? [String] {
                alreadySwipedUsers += rejectedUsers
            }
            query.whereKey("objectId", notContainedIn: alreadySwipedUsers)
            query.limit = 1
            // Download selected users
            query.findObjectsInBackground { (objects, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                } else {
                    if let users = objects {
                        for object in users {
                            if let user = object as? PFUser {
                                // Get user photo
                                if let imageFile = user["photo"] as? PFFile {
                                    imageFile.getDataInBackground(block: { (data, error) in
                                        if error != nil {
                                            print(error?.localizedDescription as Any)
                                        } else {
                                            if let imageData = data {
                                                let image = UIImage(data: imageData)
                                                self.userImage.image = image
                                            }
                                        }
                                    })
                                }
                                // Get user objectId
                                if let userId = user.objectId {
                                    self.displayedUserID = userId
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        PFUser.logOut()
        performSegue(withIdentifier: "logoutToLoginVC", sender: nil)
    }
    
    
    
    
}

