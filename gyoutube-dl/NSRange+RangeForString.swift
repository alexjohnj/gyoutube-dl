//
//  NSRange+RangeForString.swift
//  gyoutube-dl
//
//  Created by Alex Jackson on 19/09/2017.
//  Copyright © 2017 Alex Jackson. All rights reserved.
//

import Foundation

extension NSRange {
    /// Convert an NSRange to a Swift Range generic over a string index. Credit to Paul Hudson
    /// (<https://www.hackingwithswift.com/example-code/language/how-to-convert-an-nsrange-to-a-swift-string-index>)
    func stringRange(for str: String) -> Range<String.Index>? {
        guard location != NSNotFound else { return nil }

        guard let fromUTFIndex = str.utf16.index(str.utf16.startIndex, offsetBy: location, limitedBy: str.utf16.endIndex) else { return nil }
        guard let toUTFIndex = str.utf16.index(fromUTFIndex, offsetBy: length, limitedBy: str.utf16.endIndex) else { return nil }
        guard let fromIndex = String.Index(fromUTFIndex, within: str) else { return nil }
        guard let toIndex = String.Index(toUTFIndex, within: str) else { return nil }

        return fromIndex ..< toIndex
    }
}
