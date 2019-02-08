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
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var loginState = true

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        // If user exist redirect to next screen
        if PFUser.current() != nil {
            if PFUser.current()?["isWoman"] != nil {
            performSegue(withIdentifier: "fromLoginToSwipeVC", sender: nil)
            } else {
                performSegue(withIdentifier: "showUpdateUser", sender: nil)
            }
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if usernameField.text != "" && passwordField.text != "" {
            if loginState {
                // Show activity indicator and freeze user interaction
                showActivityIndicator()
                // Attempt to login
                PFUser.logInWithUsername(inBackground: self.usernameField.text!, password: self.passwordField.text!) { (user, error) in
                    self.stopActivityIndicator()
                    if error != nil {
                        self.displayAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error. Please try again.")
                    } else {
                        //Redirect user after login
                        if user?["isWoman"] != nil {
                            self.performSegue(withIdentifier: "fromLoginToSwipeVC", sender: nil)
                        } else {
                            self.performSegue(withIdentifier: "showUpdateUser", sender: nil)
                        }
                    }
                }
            } else {
                // If (loginState == false) SIGNUP USER
                self.showActivityIndicator()
                let user = PFUser()
                user.username = usernameField.text
                user.password = passwordField.text
                user.email = usernameField.text
                user.signUpInBackground { (success, error) in
                    self.stopActivityIndicator()
                    if error != nil {
                        self.displayAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error. Please try again.")
                        self.usernameField.text = ""
                        self.passwordField.text = ""
                    } else {
                        // Redirect user after creating account
                        self.performSegue(withIdentifier: "showUpdateUser", sender: nil)
                    }
                }
            }
        } else {
            // Show alert if email or password are not entered
            displayAlert(title: "Error", message: "Please enter your email and password.")
        }
        
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
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(alertAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    // Activity Indicator
    func showActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
        UIApplication.shared.endIgnoringInteractionEvents()
    }
    

}
