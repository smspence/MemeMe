//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes : [Meme]!
    let memeCollectionCellReuseId = "memeCollectionViewCellReuseId"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the savedMemes array from the App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.savedMemes
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Get the savedMemes array from the App Delegate
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        memes = appDelegate.savedMemes

        self.collectionView?.reloadData()
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(memeCollectionCellReuseId, forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memedImage

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

}
