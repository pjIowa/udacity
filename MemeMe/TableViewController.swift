//
//  TableViewController.swift
//  MemeMe
//
//  Created by Prajwal Kedilaya on 6/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class TableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableRestorationIdentifier = "table"
    var tableReuseIdentifer = "cell"
    var selectionRestorationIdentifier = "selection"
    
    @IBOutlet weak var table: UITableView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        table.reloadData()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //get meme for row in table
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        let meme = del.memes[indexPath.row]
        
        //get cell from storyboard
        let cell: UITableViewCell = table.dequeueReusableCellWithIdentifier(tableReuseIdentifer) as! UITableViewCell
        
        //set parameters from meme in table
        cell.imageView?.image = meme.memeImage
        cell.textLabel?.text = meme.topText
        cell.detailTextLabel?.text = meme.bottomText
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //set # of rows in table to number of memes
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        return del.memes.count
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //save meme for row in table
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //get selection view controller from storyboard
        let vc = storyboard?.instantiateViewControllerWithIdentifier(selectionRestorationIdentifier) as! SelectionViewController
        vc.currentMeme = del.memes[indexPath.row]
        
        //push on navigation controller stack
        navigationController?.pushViewController(vc, animated: true)
    }
}
