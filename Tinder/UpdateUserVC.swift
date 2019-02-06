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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show current user data
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
        PFUser.current()?["isWoman"] = genderSwitch.isOn
        PFUser.current()?["interestedInWomen"] = interestedIn.isOn
        if let image = profileImage.image {
            if let imageData = image.pngData() {
                PFUser.current()?["photo"] = PFFile(name: "userPhoto.png", data: imageData)
                PFUser.current()?.saveInBackground(block: { (success, error) in
                    if success {
                        print("Success, user updated!")
                    } else {
                        print(error?.localizedDescription as Any)
                    }
                })
            }
        }
    }
    
    
    
}
