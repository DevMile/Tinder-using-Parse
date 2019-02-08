//
//  UpdateUserVC.swift
//  Tinder
//
//  Created by Milan Bojic on 2/6/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class UpdateUserVC: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var genderSwitch: UISwitch!
    @IBOutlet weak var interestedIn: UISwitch!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show current user data when logged in
        if let isWoman = PFUser.current()?["isWoman"] as? Bool {
            genderSwitch.setOn(isWoman, animated: false)
        }
        if let interestedInWomen = PFUser.current()?["interestedInWomen"] as? Bool {
            interestedIn.setOn(interestedInWomen, animated: false)
        }
        if let imageData = PFUser.current()?["photo"] as? PFFile {
            imageData.getDataInBackground { (data, error) in
                if let downloadedImage = data {
                    let image = UIImage(data: downloadedImage)
                    self.profileImage.image = image
                }
            }
        }
    }
    
    @IBAction func updateUserImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImage.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updateUser(_ sender: Any) {
        self.showActivityIndicator()
        PFUser.current()?["isWoman"] = genderSwitch.isOn
        PFUser.current()?["interestedInWomen"] = interestedIn.isOn
        if let image = profileImage.image {
            if let imageData = image.pngData() {
                PFUser.current()?["photo"] = PFFile(name: "userPhoto.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        // Redirect user after updating information
                        self.stopActivityIndicator()
                        let alert = UIAlertController(title: "Success!", message: "User updated.", preferredStyle: .alert)
                        let action = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                            self.performSegue(withIdentifier: "showSwipeVC", sender: nil)
                        })
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.stopActivityIndicator()
                        self.displayAlert(title: "Error", message: error?.localizedDescription ?? "Unknown error, please try again.")
                    }
                })
            }
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
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
