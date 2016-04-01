//
//  RobotConnectionViewController.swift
//  NeverGoneBot-iOS
//
//  Created by Aadesh Patel on 3/30/16.
//  Copyright © 2016 Aadesh Patel. All rights reserved.
//

import UIKit

class RobotConnectionViewController: UIViewController {
    
    @IBOutlet weak var robotCodeTextField: NVBTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func connectToRobot() {
        guard let code = self.robotCodeTextField.text else { return }
        self.performSegueWithIdentifier("showControlVC", sender: self)

        UserService.connectToRobot(code,
            success: { (response: [String : AnyObject]) in
                guard let robotToken = response["robotToken"] as? String else { return }
                
                User.connectedRobotToken = robotToken
                print("TOKEN: \(User.connectedRobotToken)")
                
                self.performSegueWithIdentifier("showControlVC", sender: self)
            }, failure: { (error: NSError) -> Void in
                let alert = UIAlertController(title: "Error", message: "Invalid Robot Token", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            })
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
