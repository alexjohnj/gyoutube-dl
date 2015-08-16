//
//  ViewController.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {

    @IBOutlet weak var videoTable: NSTableView!
    @IBOutlet weak var urlField: NSTextField!
    @IBOutlet weak var addButton: NSButton!
    @IBOutlet weak var removeButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


    @IBAction func addLink(sender: AnyObject) {
    }
    @IBAction func removeSelectedLink(sender: AnyObject) {
    }
    @IBAction func startDownload(sender: AnyObject) {
    }
}

