//
//  DiaryTableViewCell.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

/// Diary entry UITableViewCell subclass
public class DiaryTableViewCell: UITableViewCell {
    /// Diary cell's reuse identifier for tableview
    public static let reuseIdentifier = "DiaryTableViewCell"
    
    /// Diary cell's nib layout file reference
    public static let nib = UINib(nibName: DiaryTableViewCell.reuseIdentifier, bundle: NSBundle(forClass: DiaryTableViewCell.self))
    
    /// Tags describing the image label
    @IBOutlet weak var tagsLabel: UILabel!
    
    /// Label that displays when the picture was added to the diary in terms of the current date
    @IBOutlet weak var dateLabel: UILabel!
    
    /// Label that displays where the picture was taken
    @IBOutlet weak var locationLabel: UILabel!
    
    /// UIImageView that displays the diary entry's image
    @IBOutlet weak var contentImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Sets view properties of this cell based on it's corresponding model: DiaryEntry
    public func configureCell(entry: DiaryEntry) {
        self.tagsLabel.text = entry.tags.joinWithSeparator(", ")
        self.dateLabel.text = entry.date.timeAgoString
        self.locationLabel.text = entry.location
        self.contentImageView.image = entry.image
    }

    override public func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
