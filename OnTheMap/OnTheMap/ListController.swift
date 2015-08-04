//
//  ListController.swift
//  OnTheMap
//
//  Created by Prajwal Kedilaya on 7/22/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class ListController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var table: UITableView!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* Get the app delegate */
        appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        /* reload stored points into the table */
        table.reloadData()
    }
    
    /* move the top of table to stay on screen during scrolling */
    override func viewDidLayoutSubviews() {
        if let var rect = self.navigationController?.navigationBar.frame {
            var y = rect.size.height + rect.origin.y
            self.table.contentInset = UIEdgeInsetsMake(y, 0, 0, 0)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        if var results = appDelegate.parseClient?.storedPoints{
            return results.count
        }
        else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        /* show name of student and a map icon on each cell*/
        var result = StudentLocation()
        if var results = appDelegate.parseClient?.storedPoints{
            result = results[indexPath.row]
        }
        let cell = table.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        cell.textLabel?.text = result.name
        cell.imageView?.image = pin
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        /* open to media URL when cell is selected */
        var result = StudentLocation()
        if var results = appDelegate.parseClient?.storedPoints{
            result = results[indexPath.row]
        }
        UIApplication.sharedApplication().openURL(NSURL(string:result.url)!)
    }
}
