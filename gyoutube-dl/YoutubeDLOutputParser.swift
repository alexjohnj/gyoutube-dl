//
//  YoutubeDLOutputParser.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 17/08/2015.
//  Copyright © 2015 Alex Jackson. All rights reserved.
//

import Cocoa

class YoutubeDLOutputParser: NSObject {
    
    /** Attempts to extract the current download's percentage completion.
    
    - parameter output:The youtube-dl output string to parse
    - returns: An optional double containing a number between 0-100
    */
    func extractCompletionPercentageFromOutput(output: String) -> Double? {
        let progressRegexp = try! NSRegularExpression(pattern: "[0-9]+\\.?[0-9]+%", options: .caseInsensitive)
        let matches = progressRegexp.matches(in: output, options: [], range: NSMakeRange(0, output.characters.count))

        guard let percentageRange = matches.last?.range.stringRange(for: output) else {
            return nil
        }
        let percentageString = output[percentageRange].replacingOccurrences(of: "%", with: "")
        return Double(percentageString)
    }
    
    /** Attempts to extract the current download's video title. It does this using the output file 
        name so if that doesn't contain the title, we won't get the title.
    
    - parameter output:The youtube-dl output string to parse
    - returns: An optional String that will contain the video's title
    */
    func extractVideoTitleFromOutput(output: String) -> String? {
        let titleRegexp = try! NSRegularExpression(pattern: "\\[download\\]\\ Destination:.+", options: .caseInsensitive)
        let matches = titleRegexp.matches(in: output, options: [], range: NSMakeRange(0, output.characters.count))

        guard let fullLineRange = matches.last?.range.stringRange(for: output) else {
            return nil
        }

        let outputPath = output[fullLineRange].replacingOccurrences(of: "[download] Destination:", with: "")
        return ((outputPath as NSString).lastPathComponent as NSString).deletingPathExtension
    }
}
