//
//  LoginVC.swift
//  Tinder
//
//  Created by Milan Bojic on 2/5/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class LoginVC: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    var loginState = true

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        // login or signup user
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        if loginState {
            loginButton.setTitle("Sign Up", for: .normal)
            signupButton.setTitle("Log In", for: .normal)
            loginState = false
        } else {
            loginButton.setTitle("Log In", for: .normal)
            signupButton.setTitle("Sign Up", for: .normal)
            loginState = true
        }
    }
    

}
