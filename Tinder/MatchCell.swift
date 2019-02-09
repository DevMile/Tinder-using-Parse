//
//  MatchCell.swift
//  Tinder
//
//  Created by Milan Bojic on 2/9/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class MatchCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var mesageTextField: UITextField!
    var recipientId = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    @IBAction func sendButtonPressed(_ sender: Any) {
        let messages = PFObject(className: "Message")
        messages["sender"] = PFUser.current()?.objectId
        messages["recipient"] = recipientId
        messages["content"] = mesageTextField.text
        messages.saveEventually { (success, error) in
            if success {
                print("Message sent successfully!")
            }
        }
    }
    

}
