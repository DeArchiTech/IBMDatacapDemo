//
//  OCRTextParser.swift
//  IBMCaptureSDK-Sample
//
//  Created by David Kwok Ho Chan on 2/15/17.
//  Copyright © 2017 Future Workshops. All rights reserved.
//

import Foundation

class OCRTextParser{
    
    func parseText(key : String, ocrText : String) -> String{
        
        let text = ocrText
        var range = text.rangeOfString(key)
        if range == nil{
            range = text.rangeOfString("FACTIRE #")
        }
        //1 Find the last index of a substring
        let last = range?.endIndex
        //2 Cut out a substring starting from the key(excluding) and to the end of the string
        let substring = text.substringFromIndex(last!)
        let secondRange = substring.rangeOfString(" ")
        //3 Cut out a substring starting from the start index to the first SPACE character
        let innerString = substring.substringToIndex((secondRange?.startIndex)!)
        return innerString
        
    }
    
}
