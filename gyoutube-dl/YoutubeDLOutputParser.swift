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
}
