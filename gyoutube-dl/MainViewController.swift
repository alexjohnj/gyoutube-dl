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
    
    // MARK: Actions
    @IBAction func addLink(sender: AnyObject) {
    }
    @IBAction func removeSelectedLink(sender: AnyObject) {
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

