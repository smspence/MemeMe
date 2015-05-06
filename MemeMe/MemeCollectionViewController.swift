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
    @IBOutlet weak var editButton: UIBarButtonItem!
    var editModeEnabled = false
    var selectedIndexPath : NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    // TODO - remove
    var firstRun = true
    func getTestMeme() -> Meme {
        return Meme(topText: "Some test ABC",
                    bottomText: "bottom 123",
                    originalImage: UIImage(named: "myTestImage")!,
                    memedImage: UIImage(named: "myTestImage")! )
    }
    func setUpTestMemes() {
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
        getAppDelegate().savedMemes.append(getTestMeme())
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // TODO - remove
        if firstRun {
            self.setUpTestMemes()
            firstRun = false
        }

        // Get the savedMemes array from the App Delegate
        memes = getAppDelegate().savedMemes

        self.collectionView?.reloadData()

        self.editButton.enabled = (memes.count > 0)
    }

    @IBAction func editButtonTapped(sender: AnyObject) {

        self.editModeEnabled = !self.editModeEnabled

        if self.editModeEnabled {
            self.editButton.title = "Cancel"

            // TODO - hide the tab bar and show toolbar with delete button
            self.tabBarController?.tabBar.hidden = true
        } else {
            self.editButton.title = "Edit"

            // TODO - hide tool bar with delete button and show tab bar
            self.tabBarController?.tabBar.hidden = false
        }
    }

    @IBOutlet weak var toolBarWithTrashButton: UIToolbar!

    @IBAction func deleteButtonPressed(sender: AnyObject) {

        if let selectedIndexPath = self.selectedIndexPath {

            getAppDelegate().savedMemes.removeAtIndex(selectedIndexPath.item)
            memes = getAppDelegate().savedMemes

            self.collectionView?.deleteItemsAtIndexPaths([selectedIndexPath])

            if memes.count == 0 {
                // TODO - set things back to defaults
            }
        }

        self.selectedIndexPath = nil
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCellReuseId", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memedImage
        cell.selectionOverlay.hidden = true

        return cell
    }

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if self.editModeEnabled {

            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell

            if indexPath == selectedIndexPath {
                // Cell is already selected, so remove selection overlay and selected index path
                //  (The cell will no longer be selected for deletion)
                cell.selectionOverlay.hidden = true
                selectedIndexPath = nil

            } else {
                // The cell should be selected for deletion
                cell.selectionOverlay.hidden = false
                selectedIndexPath = indexPath
            }

        } else {
            let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
            detailVC.meme = self.memes[indexPath.item]
            self.navigationController!.pushViewController(detailVC, animated: true)
        }
    }

    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        if self.editModeEnabled {
            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell
            cell.selectionOverlay.hidden = true
        }
    }

}
