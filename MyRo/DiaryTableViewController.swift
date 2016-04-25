//
//  DiaryTableViewController.swift
//  MyRo
//
//  Created by Shreyas Hirday on 4/16/16.
//  Copyright © 2016 MyRo. All rights reserved.
//

import UIKit

class DiaryTableViewController: UITableViewController {
    //private let data: NSMutableArray? = nil
    private var entries = [DiaryEntry]()
    private var filteredEntries = [DiaryEntry]()
    private let searchController = UISearchController(searchResultsController: nil)
    private let fadeBackgroundView: UIView = {
        let view = UIView(frame: UIScreen.mainScreen().bounds)
        view.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.5)
        
        return view
    }()
    
    private lazy var fullscreenImageView = UIImageView()
    private var originalFrame = CGRectZero
    
    private var isFiltered: Bool {
        return self.searchController.active && self.searchController.searchBar.text?.characters.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissImage))
        tapGesture.numberOfTouchesRequired = 1
        tapGesture.numberOfTapsRequired = 1
        self.fadeBackgroundView.addGestureRecognizer(tapGesture)
        
        self.searchController.searchResultsUpdater = self
        self.searchController.searchBar.delegate = self
        self.searchController.dimsBackgroundDuringPresentation = false
        self.definesPresentationContext = true
        
        self.tableView.contentInset = UIEdgeInsetsMake(20.0, 0.0, 0.0, 0.0)
        self.tableView.tableHeaderView = self.searchController.searchBar
        self.tableView.registerNib(DiaryTableViewCell.nib, forCellReuseIdentifier: DiaryTableViewCell.reuseIdentifier)
        
        DataService.dataService.DIARY_ENTRY_REF.observeEventType(.Value, withBlock: { snapshot in
            if let snapshots = snapshot.children.allObjects as? [FDataSnapshot] {
                for snap in snapshots {
                    guard let json = snap.value as? [String : AnyObject] else { continue }
                    let entry = DiaryEntry.fromJSON(json)
                    
                    self.entries.append(entry)
                }
                
                self.tableView.reloadData()
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.isFiltered) {
            return self.filteredEntries.count
        }
        
        return self.entries.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier(DiaryTableViewCell.reuseIdentifier) as? DiaryTableViewCell else {
            fatalError("Fatal error: Unable to load cell DiaryTableViewCell")
        }
        
        let entry: DiaryEntry
       
        if (self.isFiltered) {
            entry = self.filteredEntries[indexPath.row]
        } else {
            entry = self.entries[indexPath.row]
        }
        
        cell.configureCell(entry)
       
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 200.0
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let cell = tableView.cellForRowAtIndexPath(indexPath) as? DiaryTableViewCell else { return }
        
        var rect = self.view.convertRect(cell.contentImageView.bounds, fromView: cell.contentImageView)
        rect.origin.y += 20.0
        
        self.originalFrame = rect
        self.fadeBackgroundView.alpha = 0.0
        self.tabBarController?.view.addSubview(self.fadeBackgroundView)
        
        self.fullscreenImageView.frame = rect
        self.fullscreenImageView.image = cell.contentImageView.image
        self.fullscreenImageView.contentMode = UIViewContentMode.ScaleAspectFill
        self.fullscreenImageView.clipsToBounds = true
        self.tabBarController?.view.addSubview(self.fullscreenImageView)
        cell.contentImageView.hidden = true
        
        guard let imageSize = cell.contentImageView.image?.size else { return }
        
        let ratio = self.view.frame.size.width / imageSize.width
        let imageWidth = self.view.frame.size.width
        let imageHeight = imageSize.height * ratio
        
        let endFrame = CGRectMake(0.0, (self.view.frame.size.height - imageHeight) / 2.0, imageWidth, imageHeight)
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    self.fullscreenImageView.frame = endFrame
                                    self.fadeBackgroundView.alpha = 1.0
            }, completion: nil)
    }
    
    @IBAction func dismissImage() {
        guard let indexPath = self.tableView.indexPathForSelectedRow else { return }
        guard let cell = self.tableView.cellForRowAtIndexPath(indexPath) as? DiaryTableViewCell else { return }
        
        UIView.animateWithDuration(0.5,
                                   delay: 0.0,
                                   options: UIViewAnimationOptions.CurveEaseInOut,
                                   animations: {
                                    self.fullscreenImageView.frame = self.originalFrame
                                    self.fadeBackgroundView.alpha = 0.0
            }, completion: { finished in
                guard finished else { return }
                
                cell.contentImageView.hidden = false
                self.fullscreenImageView.removeFromSuperview()
                self.fadeBackgroundView.removeFromSuperview()
        })
    }
    
    internal func filterContent(searchText: String) {
        let lowerSearchText = searchText.lowercaseString
        self.filteredEntries = self.entries.filter { entry in
            for tag in entry.tags {
                if (tag.lowercaseString.containsString(lowerSearchText)) {
                    return true
                }
            }
            
            return false
        }
        
        self.tableView.reloadData()
    }
}

extension DiaryTableViewController: UISearchBarDelegate {
    func searchBar(searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.filterContent(searchBar.text!)
    }
}

extension DiaryTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        self.filterContent(searchController.searchBar.text!)
    }
}