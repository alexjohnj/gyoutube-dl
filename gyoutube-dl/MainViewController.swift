//
//  ViewController.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController, NSTableViewDelegate, NSTableViewDataSource {
    // MARK: Properties
    var videoLinks: [NSURL] = []
    
    // MARK: Outlets
    @IBOutlet weak var videoTable: NSTableView!
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    
    // MARK: NSViewController Overrides
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: NSStoryboardSegue, sender: AnyObject?) {
        let dlViewController = segue.destinationController as! DownloadViewController
        dlViewController.videoLinks = videoLinks
    }
    
    // MARK: Actions
    @IBAction func addLink(sender: AnyObject) {
        let inputString = urlField.stringValue
        
        guard let inputURL = NSURL(string:inputString) else {
            print("invalid URL")
            return
        }
        if videoLinks.contains(inputURL) {
            urlField.stringValue = ""
            return
        }
        videoLinks.append(inputURL)
        urlField.stringValue = ""
        videoTable.reloadData()
        startButton.enabled = true
    }
    
    @IBAction func removeSelectedLink(sender: AnyObject) {
        let selectedRows = videoTable.selectedRowIndexes
        guard selectedRows.count > 0 else {
            NSBeep()
            return
        }
        // This won't work if there's duplicate items but
        // that's why we prevent entering duplicate items!
        videoLinks = videoLinks.filter { (link: NSURL) -> Bool in
            return !selectedRows.containsIndex(videoLinks.indexOf(link)!)
        }
        videoTable.reloadData()
    }
    
    @IBAction func startDownload(sender: AnyObject) {
    }
    
    // MARK: TableView Methods
    func numberOfRowsInTableView(tableView: NSTableView) -> Int {
        return videoLinks.count
    }
    
    func tableView(tableView: NSTableView, objectValueForTableColumn tableColumn: NSTableColumn?, row: Int) -> AnyObject?  {
        return videoLinks[row]
    }
    
    func tableView(tableView: NSTableView, viewForTableColumn tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else {
            print("No table column identifier")
            return nil
        }
        let cellView = tableView.makeViewWithIdentifier(tableColumn.identifier, owner: self) as! NSTableCellView
        cellView.objectValue = videoLinks[row]
        cellView.textField?.stringValue = videoLinks[row].absoluteString
        
        return cellView
    }
}

