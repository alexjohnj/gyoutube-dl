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
        let progressRegexp = try! NSRegularExpression(pattern: "[0-9]+\\.?[0-9]+%", options: .CaseInsensitive)
        let matches = progressRegexp.matchesInString(output, options: [], range: NSMakeRange(0, output.characters.count))
        guard matches.count > 0 else {
            return nil
        }
        
        let lastMatch = matches[matches.count - 1]
        guard lastMatch != NSNotFound else {
            return nil
        }
        
        var percentageString: String = (output as NSString).substringWithRange(lastMatch.range)
        percentageString = percentageString.stringByReplacingOccurrencesOfString("%", withString: "")
        return (percentageString as NSString).doubleValue
    }
    
    /** Attempts to extract the current download's video title. It does this using the output file 
        name so if that doesn't contain the title, we won't get the title.
    
    - parameter output:The youtube-dl output string to parse
    - returns: An optional String that will contain the video's title
    */
    func extractVideoTitleFromOutput(output: String) -> String? {
        let titleRegexp = try! NSRegularExpression(pattern: "\\[download\\]\\ Destination:.+", options: .CaseInsensitive)
        let matches = titleRegexp.matchesInString(output, options: [], range: NSMakeRange(0, output.characters.count))
        guard matches.count > 0 else {
            return nil
        }
        
        let lastMatch = matches[matches.count - 1]
        guard lastMatch != NSNotFound else {
            return nil
        }
        
        let fullLine = (output as NSString).substringWithRange(lastMatch.range)
        let outputFilePath = (fullLine as NSString).stringByReplacingOccurrencesOfString("[download] Destination: ", withString: "")
        
        return ((outputFilePath as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    }
}
