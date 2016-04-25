//
//  DiaryEntryPopupViewController.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public class DiaryEntryPopupViewController: UIViewController {
    public static let nibName = "DiaryEntryPopupViewController"
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var tagsTextField: UITextField!
    
    public var contentImage: UIImage? = nil
    private var now = NSDate()
    
    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    public init() {
        super.init(nibName: DiaryEntryPopupViewController.nibName, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.contentImageView.image = self.contentImage
        self.dateTextField.text = self.now.dateString("hh:mm a")
        
        CloudVisionService.getTags(forImage: self.contentImage!).then(.Current) { (json) -> [String] in
            guard let responses = json["responses"] as? [AnyObject] else { return [String]() }
            guard let response = responses[0] as? [String : AnyObject] else { return [String]() }
            guard let annotations = response["labelAnnotations"] as? [[String : AnyObject]] else { return [String]() }
            
            let tags = annotations.map { CloudVisionTag.fromJSON($0) }.filter { $0.score > CloudVisionTag.scoreThreshold }.map { $0.desc! }
            
            return tags
        }.then { tags in
            self.tagsTextField.text = tags.joinWithSeparator(",")
        }.error { (err: NSError) in
            print("Cloud Vision Error: \(err.description)")
        }
    }

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func save() {
        let entry = DiaryEntry()
        entry.date = self.now
        entry.location = self.locationTextField.text
        entry.tags = self.tagsTextField.text?.characters.split { $0 == "," }.map(String.init)
        entry.image = self.contentImage
        
        DataService.dataService.saveDiaryEntry(entry)
        
        self.close()
    }
    
    @IBAction func close() {
        self.parentViewController?.dismissPopupViewController(animated: true, completion: nil)
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
