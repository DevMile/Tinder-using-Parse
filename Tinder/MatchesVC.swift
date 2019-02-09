//
//  MatchesVC.swift
//  Tinder
//
//  Created by Milan Bojic on 2/9/19.
//  Copyright © 2019 Milan Bojic. All rights reserved.
//

import UIKit
import Parse

class MatchesVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    var userImages = [UIImage]()
    var userIds = [String]()
    var messages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Show people who match with us
        if let query = PFUser.query() {
            query.whereKey("accepted", contains: PFUser.current()?.objectId)
            query.whereKey("objectId", containedIn: PFUser.current()?["accepted"] as! [String])
            query.findObjectsInBackground { (objects, error) in
                self.showActivityIndicator()
                if let users = objects {
                    for object in users {
                        if let user = object as? PFUser {
                            // Get peoples images, IDs and messages
                            if let imageFile = user["photo"] as? PFFile {
                                imageFile.getDataInBackground(block: { (data, error) in
                                    self.stopActivityIndicator()
                                    if let imageData = data {
                                        if let image = UIImage(data: imageData), let userId = user.objectId {
                                            let messageQuery = PFQuery(className: "Message")
                                            messageQuery.whereKey("sender", equalTo: PFUser.current()?.objectId as Any)
                                            messageQuery.whereKey("recipient", equalTo: user.objectId as Any)
                                            messageQuery.findObjectsInBackground(block: { (objects, error) in
                                                if let objects = objects {
                                                    for message in objects {
                                                        if let content = message["content"] as? String {
                                                            self.messages.append(content)
                                                            self.userImages.append(image)
                                                            self.userIds.append(userId)
                                                        }
                                                    }
                                                }
                                                self.tableView.reloadData()
                                            })
                                        }
                                    }
                                })
                            }
                        }
                    }
                }
            }
        }
    }
    
    // TableView methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userImages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "matchCell", for: indexPath) as? MatchCell else { return UITableViewCell() }
        tableView.rowHeight = 160
        cell.profileImage.image = userImages[indexPath.row]
        cell.recipientId = userIds[indexPath.row]
        cell.messageLabel.text = messages[indexPath.row]
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Activity Indicator
    func showActivityIndicator() {
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
    }
    
    func stopActivityIndicator() {
        self.activityIndicator.stopAnimating()
    }
    
    
}
