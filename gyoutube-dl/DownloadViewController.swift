//
//  DownloadViewController.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class DownloadViewController: NSViewController {
    var videoLinks: [NSURL]?
    var downloadOperation: VideoDownloadOperation?
    
    // MARK: Outlets
    @IBOutlet weak var progressBar: NSProgressIndicator!
    @IBOutlet weak var cancelCloseButton: NSButton!
    
    // MARK: Object Life Cycle
    deinit {
        guard downloadOperation != nil else {
            return
        }
        downloadOperation!.removeObserver(self, forKeyPath: "isExecuting")
        downloadOperation!.removeObserver(self, forKeyPath: "isFinished")
        downloadOperation!.removeObserver(self, forKeyPath: "currentTitleProgress")
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.maxValue = 1.0
        progressBar.minValue = 0
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let videoLinks = videoLinks else {
            print("Nil links provided to DownloadViewController (in viewDidAppear())")
            return
        }
        downloadOperation = VideoDownloadOperation(videoLinks: videoLinks)
        downloadOperation!.addObserver(self, forKeyPath: "isExecuting", options: .New, context: nil)
        downloadOperation!.addObserver(self, forKeyPath: "isFinished", options: .New, context: nil)
        downloadOperation!.addObserver(self, forKeyPath: "currentTitleProgress", options: .New, context: nil)
        downloadOperation!.start()
    }
    
    // MARK: KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else { return }
        guard let change = change else { return }
        guard let newValue = change[NSKeyValueChangeNewKey] else { return }
        
        switch keyPath {
        case "isExecuting":
            if newValue as! Bool == true {
                progressBar.startAnimation(self)
            }
        case "isFinished":
            if newValue as! Bool == true {
                progressBar.stopAnimation(self)
                cancelCloseButton.title = "Close"
            }
            print("Finished downloading")
        case "currentTitleProgress":
            let currentProgress = newValue as! Double
            progressBar.doubleValue = currentProgress
        default:
            break
        }
    }
}
