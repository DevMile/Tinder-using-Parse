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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let newUser = PFObject(className: "Testing")
        newUser["name"] = "Mile"
        newUser.saveInBackground { (success, error) in
            if success {
            print("New User Saved!")
            } else {
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    


}

