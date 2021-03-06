//
//  LoginViewController.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 2/4/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// View controller where user can login or register a new account
class LoginViewController: UIViewController {
    /// Text field to input username
    @IBOutlet weak var usernameTextField: UITextField!
    
    /// Text field to input password
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        SocketService.connect()
        SocketService.publish("myro instruction", items: "Test123")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /**
     Attempts to login by sending a request to the server and handles the
     response accordingly
 
     - parameter sender: Button that caused the login event
     */
    @IBAction func login(sender: UIButton) {
        UserService.authenticateUser(self.usernameTextField.text,
            password: self.passwordTextField.text,
            success: { [weak self] (response: [String : AnyObject]) -> Void in
                guard let userObj = response["user"] as? [String : AnyObject] else { return }
                guard let authToken = response["authToken"] as? String else { return }

                User.currentUser = User.fromJSON(userObj)
                User.authToken = authToken
                
                self?.performSegueWithIdentifier("login", sender: nil)
            }, failure: { [weak self] (error: NSError) -> Void in
                print("ERROR: \(error)")
                let alertController = UIAlertController(title: "Authentication Failed", message: "Invalid username/password", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                    
                })
                alertController.addAction(cancelAction)
                
                self?.presentViewController(alertController, animated: true, completion: nil)
        })
    }
}
