//
//  Meme.swift
//  impicker
//
//  Created by Prajwal Kedilaya on 6/19/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class Meme{
   
    var topText:String!
    var bottomText:String!
    var memeImage:UIImage!
    
    init(topText: String, bottomText: String, memeImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.memeImage = memeImage
    }
}
