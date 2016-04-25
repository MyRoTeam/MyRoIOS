//
//  DiaryTableViewCell.swift
//  MyRo
//
//  Created by Aadesh Patel on 4/24/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

public class DiaryTableViewCell: UITableViewCell {
    public static let reuseIdentifier = "DiaryTableViewCell"
    public static let nib = UINib(nibName: DiaryTableViewCell.reuseIdentifier, bundle: NSBundle(forClass: DiaryTableViewCell.self))
    
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var contentImageView: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
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
