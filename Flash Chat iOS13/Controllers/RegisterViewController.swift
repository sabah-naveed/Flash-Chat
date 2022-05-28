//  Sabah Naveed
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        if let email = emailTextfield.text, let password = passwordTextfield.text { //if entries are valid...
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in  //review closures
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: K.registerSegue, sender: self) //navigate to chat storyboard
                }
            }
        }
    }
    
}
