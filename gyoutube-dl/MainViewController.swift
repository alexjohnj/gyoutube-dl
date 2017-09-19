//
//  ViewController.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
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

    override func prepare(for segue: NSStoryboardSegue, sender: Any?) {
        guard let dlViewController = segue.destinationController as? DownloadViewController else {
            fatalError("Unknowk destination view controller")
        }

        dlViewController.videoLinks = videoLinks
    }
    
    // MARK: Actions
    @IBAction func addLink(_ sender: AnyObject) {
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
        startButton.isEnabled = true
    }
    
    @IBAction func removeSelectedLink(_ sender: AnyObject) {
        let selectedRows = videoTable.selectedRowIndexes
        guard selectedRows.count > 0 else {
            __NSBeep()
            return
        }

        // This won't work if there's duplicate items but
        // that's why we prevent entering duplicate items!
        videoLinks = videoLinks.filter { (link: NSURL) -> Bool in
            return !selectedRows.contains(videoLinks.index(of: link)!)
        }
        videoTable.reloadData()
    }
    
    @IBAction func startDownload(sender: AnyObject) {
    }
}

extension MainViewController: NSTableViewDataSource {
    func numberOfRows(in tableView: NSTableView) -> Int {
        return videoLinks.count
    }

    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return videoLinks[row]
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else {
            print("No table column identifier")
            return nil
        }

        let cellView = tableView.makeView(withIdentifier: tableColumn.identifier, owner: self) as! NSTableCellView
        cellView.objectValue = videoLinks[row]
        cellView.textField?.stringValue = videoLinks[row].absoluteString ?? ""

        return cellView
    }
}

extension MainViewController: NSTableViewDelegate { }
