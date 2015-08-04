//
//  RecordedAudio.swift
//  PitchPerfect
//
//  Created by Prajwal Kedilaya on 6/16/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class RecordedAudio: NSObject {
    var filePathURL:NSURL!
    var title:String!
    
    init(filePathURL: NSURL, title: String) {
        self.filePathURL = filePathURL
        self.title = title
    }
}
