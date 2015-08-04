//
//  CollectionViewController.swift
//  MemeMe
//
//  Created by Prajwal Kedilaya on 6/29/15.
//  Copyright (c) 2015 Prajwal Kedilaya. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var collection: UICollectionView!
    
    var selectionRestorationIdentifier = "selection"
    var collectionReuseIdentifier = "cell"
    var collectionRestorationIdentifier = "collection"
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        collection.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        //set # of cells in collection to number of memes
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        return del.memes.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell{
        //get meme for cell in collection
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        let meme = del.memes[indexPath.row]
        
        //get cell from storyboard
        let cell = collection.dequeueReusableCellWithReuseIdentifier(collectionReuseIdentifier, forIndexPath: indexPath) as! UICollectionViewCell
        
        //set image to meme
        let imageView = UIImageView(image: meme.memeImage)
        cell.backgroundView = imageView
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        //save meme for cell in collection
        let del = UIApplication.sharedApplication().delegate as! AppDelegate
        
        //get selection view controller from storyboard
        let vc = storyboard?.instantiateViewControllerWithIdentifier(selectionRestorationIdentifier) as! SelectionViewController
        vc.currentMeme = del.memes[indexPath.row] as Meme
        
        //push on navigation controller stack
        navigationController?.pushViewController(vc, animated: true)
    }

}
