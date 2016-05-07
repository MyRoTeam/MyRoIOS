//
//  RobotConnectionViewController.swift
//  MyRo-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

/// View controller where a user attempts to connect to a robot via alphanumeric code
class RobotConnectionViewController: UIViewController {
    /// Text field to input a robot's alphanumeric code
    @IBOutlet weak var robotCodeTextField: NVBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// Attempts to connect to robot based on the code supplied by the user
    @IBAction func connectToRobot() {
        guard let code = self.robotCodeTextField.text where code == "code123" else {
            let alert = UIAlertController(title: "Error", message: "Invalid Robot Token", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            return
        }
        
        /*UserService.connectToRobot(code,
         success: { (response: [String : AnyObject]) in
         guard let robotToken = response["robotToken"] as? String else { return }
         
         User.connectedRobotToken = robotToken
         print("TOKEN: \(User.connectedRobotToken)")
         
         self.performSegueWithIdentifier("showControlVC", sender: self)
         }, failure: { (error: NSError) -> Void in
         let alert = UIAlertController(title: "Error", message: "Invalid Robot Token", preferredStyle: .Alert)
         alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
         self.presentViewController(alert, animated: true, completion: nil)
         })*/
        
        if (code == "code123") {
            self.performSegueWithIdentifier("showControlVC", sender: self)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let dest = segue.destinationViewController as? ControlViewController where segue.identifier == "showControlVC" else { return }
        
        dest.room = "myro-\(self.robotCodeTextField.text!)"
        print("ROOM: \(dest.room)")
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
