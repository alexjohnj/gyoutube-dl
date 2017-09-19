//
//  VideoDownloadOperation.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 16/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class VideoDownloadOperation: Operation {
    // MARK: Properties
    let videoLinks: [NSURL]

    @objc dynamic var currentTitle = ""
    @objc dynamic var currentTitleProgress = 0.0
    @objc dynamic var currentVideoIndex = 0
    
    private let videoDownloadTask = Process()
    private let outputFileHandle: FileHandle

    private let notiCenter = NotificationCenter.default
    
    // MARK: NSOperation State Overrides
    private var _executing = false
    override var isExecuting: Bool {
        get { return _executing }
        set {
            if _executing != newValue {
                willChangeValue(forKey: "isExecuting")
                _executing = newValue
                didChangeValue(forKey: "isExecuting")
            }
        }
    }
    
    private var _finished: Bool = false;
    override var isFinished: Bool {
        get {
            return _finished
        }
        set {
            if _finished != newValue {
                willChangeValue(forKey: "isFinished")
                _finished = newValue
                didChangeValue(forKey: "isFinished")
            }
        }
    }
    
    private var _asynchronous = true
    override var isAsynchronous: Bool { return _asynchronous }
    
    // MARK: Object Lifecycle
    init(videoLinks: [NSURL]) {
        self.videoLinks = videoLinks
        
        let pipe = Pipe()
        videoDownloadTask.standardOutput = pipe
        outputFileHandle = pipe.fileHandleForReading
        
        super.init()
    }
    
    deinit {
        notiCenter.removeObserver(self)
    }
    
    // MARK: NSOperation Lifecycle
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
        isExecuting = true
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
        isExecuting = false
        isFinished = true
    }
    
    private func configureOperation() {
        let outputDirectory = NSURL.fileURL(withPathComponents: [NSHomeDirectory(), "Music", "%(title)s.%(ext)s"])!
        videoDownloadTask.launchPath = "/usr/local/bin/youtube-dl"
        videoDownloadTask.arguments = ["-x", "--audio-format", "mp3", "--output", outputDirectory.path] + videoLinks.map { $0.absoluteString! }
        videoDownloadTask.environment = ["PATH": "/usr/bin/:/usr/local/bin/"]

        notiCenter.addObserver(self,
                               selector: #selector(VideoDownloadOperation.readDidComplete(noti:)),
                               name: FileHandle.readCompletionNotification,
                               object: outputFileHandle)
        notiCenter.addObserver(self,
                               selector: #selector(VideoDownloadOperation.taskDidTerminate(noti:)),
                               name: Process.didTerminateNotification,
                               object: videoDownloadTask)
    }
    
    // MARK: Notification Responses
    
    @objc func readDidComplete(noti: NSNotification) {
        guard let userInfo = noti.userInfo else {
            print("Read data userInfo was nil")
            return
        }

        guard let readDataOpt = userInfo[NSFileHandleNotificationDataItem],
            let readData = readDataOpt as? Data else {
            print("Read data did not have any data")
            return
        }

        guard let stringDataRepr = String(data: readData, encoding: .utf8) else {
            print("Unable to parse output of youtube-dl")
            return
        }
        
        // Attempt to extract information about the download
        let outputParser = YoutubeDLOutputParser()
        if let dlTitle = outputParser.extractVideoTitleFromOutput(output: stringDataRepr) {
            if dlTitle != currentTitle {
                currentTitle = dlTitle
                currentVideoIndex += 1
            }
        }

        if let dlPercentage = outputParser.extractCompletionPercentageFromOutput(output: stringDataRepr) {
            currentTitleProgress = dlPercentage / 100
        }
        
        if !isFinished {
            outputFileHandle.readInBackgroundAndNotify()
        }
    }
    
    @objc func taskDidTerminate(noti: NSNotification) {
        print("Finished youtube-dl with status code \(videoDownloadTask.terminationStatus)")
        outputFileHandle.closeFile()
        isExecuting = true
        isFinished = true
    }
    
}
