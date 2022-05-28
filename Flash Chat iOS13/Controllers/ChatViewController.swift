//  Sabah Naveed
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    let db = Firestore.firestore()
    
    var messages: [Message] = [
        Message(sender: "1@2.com", body: "hey!"),
        Message(sender: "a@b.com", body: "hello!"),
        Message(sender: "1@2.com", body: "wuts up")
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) //must call superclass for overrided functions
        navigationController?.isNavigationBarHidden = false //set nav bar to be hidden
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false //reset nav bar to display for next VC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.delegate = self
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true //hides back button
        
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier) //registers xib file in table view
        
        loadMessages()
    }
    
    func loadMessages() {
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in //query snapshot is an object of our database; closure gets triggered once all documents with new are collected
                
            self.messages = [] //emptys out once new are detected
            
            if let e = error {
                print("issue retrieving data: \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments { //loop through documents in snapshot
                        let data = doc.data()
                        if let sender = data[K.FStore.senderField] as? String, let message = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: sender, body: message)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async { //makes sure messages are loading in main loading thread
                                self.tableView.reloadData() //reloads messages
                                let indexPath = IndexPath(row: self.messages.count-1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true) //scrolls recent message up
                            }
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.senderField: messageSender,
                K.FStore.bodyField: messageBody,
                K.FStore.dateField: Date().timeIntervalSince1970]) { (error) in
                    if let e = error {
                        print("there was an issue saving data to firestore, \(e)")
                    } else {
                        print("successfully saved data")
                        DispatchQueue.main.async {
                            self.messageTextfield.text = ""
                        }
                    }
                }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            navigationController?.popToRootViewController(animated: true) //goes back to root VC
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}

extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //how many rows in table view
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //the cell that should be displayed at each row, gets called as many times as there are cells
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = message.body
        
        if message.sender == Auth.auth().currentUser?.email { //message from current user
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        } else { //another sender
            cell.rightImageView.isHidden = true
            cell.leftImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }

        return cell
    }
}

//extension ChatViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print(indexPath.row)
//    }
//}
