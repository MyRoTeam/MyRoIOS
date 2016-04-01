//
//  RegisterViewController.swift
//  NeverGoneBot-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    @IBOutlet weak var usernameTextField: NVBTextField!
    @IBOutlet weak var passwordTextField: NVBTextField!
    @IBOutlet weak var confirmPasswordTextField: NVBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func register() {
        guard self.usernameTextField.text?.characters.count > 0 && self.passwordTextField.text?.characters.count > 0 && self.confirmPasswordTextField.text?.characters.count > 0 else {
            let alert = UIAlertController(title: "Error", message: "All Fields Required", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        guard self.passwordTextField.text == self.confirmPasswordTextField.text else {
            let alert = UIAlertController(title: "Error", message: "All Fields Required", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        let user = User(username: self.usernameTextField.text!)
        UserService.createUser(user,
            withPassword: self.passwordTextField.text!,
            success: { (response: [String : AnyObject]) in
                print("RESP: \(response)")
                
                let alert = UIAlertController(title: "Registered", message: "Registered user account!", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                }))
                
                self.presentViewController(alert, animated: true, completion: nil)
            },
            failure: nil)
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
