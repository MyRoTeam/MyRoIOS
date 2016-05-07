//
//  RegisterViewController.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// User registration view controller
class RegisterViewController: UIViewController {
    /// Username input text field
    @IBOutlet weak var usernameTextField: NVBTextField!
    
    /// Password input text field
    @IBOutlet weak var passwordTextField: NVBTextField!
    
    /// Confirm password input text field to compare passwords
    @IBOutlet weak var confirmPasswordTextField: NVBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**
     Registers new account in server by sending request parameters based on
     the username, password, and confirm password text fields
     */
    @IBAction func register() {
        guard self.usernameTextField.text?.characters.count > 0 && self.passwordTextField.text?.characters.count > 0 && self.confirmPasswordTextField.text?.characters.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "All Fields Required", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.passwordTextField.text == self.confirmPasswordTextField.text else {
            let alert = UIAlertController(title: "Passwords Don't Match", message: "Passwords Must Match", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let user = User(username: self.usernameTextField.text!)
        UserService.createUser(user, withPassword: self.passwordTextField.text!).then { user in
            let alert = UIAlertController(title: "Registered", message: "Registered user account!", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                self.dismissViewControllerAnimated(true, completion: nil)
            }))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
