//
//  SelectionViewController.swift
//  MemeMe
//
//  Created by Prajwal Kedilaya on 6/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class SelectionViewController: UIViewController {

    var currentMeme: Meme?
    
    @IBOutlet weak var selectionImView: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectionImView.image = currentMeme?.memeImage
    }
}
