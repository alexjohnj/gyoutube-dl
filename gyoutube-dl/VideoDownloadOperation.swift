//
//  VideoDownloadOperation.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class VideoDownloadOperation: NSOperation {
    // MARK: Properties
    let videoLinks:[NSURL]
    dynamic var currentTitle = ""
    dynamic var currentTitleProgress = 0.0
    dynamic var currentVideoIndex = 0
    
    private let videoDownloadTask = NSTask()
    private let outputFileHandle: NSFileHandle
    
    // MARK: NSOperation State Overrides
    private var _executing = false
    override var executing: Bool {
        get { return _executing }
        set {
            if _executing != newValue {
                willChangeValueForKey("isExecuting")
                _executing = newValue
                didChangeValueForKey("isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var finished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValueForKey("isFinished")
                _finished = newValue
                didChangeValueForKey("isFinished")
            }
        }
    }
    
    private var _asynchronous = true
    override var asynchronous: Bool { return _asynchronous }
    
    // MARK: Object Lifecycle
    init(videoLinks:[NSURL]) {
        self.videoLinks = videoLinks
        
        let pipe = NSPipe()
        videoDownloadTask.standardOutput = pipe
        outputFileHandle = pipe.fileHandleForReading
        
        super.init()
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    // MARK: NSOperation Lifecycle
    override func start() {
        if cancelled {
            finished = true
            return
        }
        executing = true
        main()
    }
    
    override func main() {
        configureOperation()
        videoDownloadTask.launch()
        outputFileHandle.readInBackgroundAndNotify()
    }
    
    override func cancel() {
        videoDownloadTask.terminate()
        // Perform these tasks in case taskDidTerminate notification
        // doesn't get chance to fire
        outputFileHandle.closeFile()
        executing = false
        finished = true
    }
    
    private func configureOperation() {
        let outputDirectory = NSURL.fileURLWithPathComponents([NSHomeDirectory(), "Music", "%(title)s.%(ext)s"])!
        videoDownloadTask.launchPath = "/usr/local/bin/youtube-dl"
        videoDownloadTask.arguments = ["-x", "--audio-format", "mp3", "--output", outputDirectory.path!] + videoLinks.map { $0.absoluteString }
        videoDownloadTask.environment = ["PATH": "/usr/local/bin/:$PATH"]
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoDownloadOperation.readDidComplete(_:)), name: NSFileHandleReadCompletionNotification, object: outputFileHandle)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(VideoDownloadOperation.taskDidTerminate(_:)), name: NSTaskDidTerminateNotification, object: videoDownloadTask)
    }
    
    // MARK: Notification Responses
    
    func readDidComplete(noti: NSNotification) {
        guard let userInfo = noti.userInfo else {
            print("Read data userInfo was nil")
            return
        }
        guard let readDataOpt = userInfo[NSFileHandleNotificationDataItem] else {
            print("Read data did not have any data")
            return
        }
        let readData = readDataOpt as! NSData
        let stringDataReprOpt = NSString(data: readData, encoding: NSUTF8StringEncoding)
        guard let stringDataRepr = stringDataReprOpt else {
            print("Unable to parse output of youtube-dl")
            return
        }
        
        // Attempt to extract information about the download
        let outputParser = YoutubeDLOutputParser()
        if let dlTitle = outputParser.extractVideoTitleFromOutput(stringDataRepr as String) {
            if dlTitle != currentTitle {
                currentTitle = dlTitle
                currentVideoIndex += 1
            }
        }
        if let dlPercentage = outputParser.extractCompletionPercentageFromOutput(stringDataRepr as String) {
            currentTitleProgress = dlPercentage / 100
        }
        
        if !finished {
            outputFileHandle.readInBackgroundAndNotify()
        }
    }
    
    func taskDidTerminate(noti: NSNotification) {
        print("Finished youtube-dl with status code \(videoDownloadTask.terminationStatus)")
        outputFileHandle.closeFile()
        executing = true
        finished = true
    }
    
}
