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
    var videoLinks: [URL] = []
    
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

        guard let inputURL = URL(string: inputString),
            inputURL.scheme == "http" || inputURL.scheme == "https" else {
            print("User was silly and entered an invalid URL")
            return
        }

        // Avoid entering duplicate URLs
        if let index = videoLinks.index(of: inputURL) {
            videoTable.selectRowIndexes(IndexSet(integer: index), byExtendingSelection: false)
        } else {
            videoLinks.append(inputURL)
            videoTable.reloadData()
            startButton.isEnabled = true
        }

        urlField.stringValue = ""
    }
    
    @IBAction func removeSelectedLink(_ sender: AnyObject) {
        let selectedRows = videoTable.selectedRowIndexes
        guard selectedRows.count > 0 else {
            __NSBeep()
            return
        }

        videoLinks = videoLinks.enumerated()
            .filter { !selectedRows.contains($0.offset) }
                .map { videoLinks[$0.offset] }

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
        cellView.textField?.stringValue = videoLinks[row].absoluteString

        return cellView
    }
}

extension MainViewController: NSTableViewDelegate { }
