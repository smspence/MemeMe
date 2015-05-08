//
//  MemeCollectionViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeCollectionViewController : UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var memes : [Meme]!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var memeCollectionView: UICollectionView!
    @IBOutlet weak var toolBarWithTrashButton: UIToolbar!
    @IBOutlet weak var trashButton : UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationItem!
    @IBOutlet weak var addMemeButton: UIBarButtonItem!
    var editModeEnabled = false
    var selectedIndexPaths = Set<NSIndexPath>()

    override func viewDidLoad() {
        super.viewDidLoad()

        memeCollectionView.allowsMultipleSelection = true
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
        if firstRun && self.getAppDelegate().savedMemes.count == 0 {
            self.setUpTestMemes()
            firstRun = false
        }

        // Get the savedMemes array from the App Delegate
        memes = getAppDelegate().savedMemes

        self.memeCollectionView.reloadData()

        self.editButton.enabled = (memes.count > 0)
    }

    @IBAction func editButtonTapped(sender: AnyObject) {

        self.editModeEnabled = !self.editModeEnabled

        if self.editModeEnabled {
            // "Edit" was pressed
            self.editModeStart()
        } else {
            // "Cancel" was pressed
            self.editModeEnd()
        }
    }

    func editModeStart() {
        // The view has entered Edit mode,
        //  so the button should now function as a "Cancel"
        self.editButton.title = "Cancel"

        // Hide the tab bar and show toolbar with delete button
        self.tabBarController?.tabBar.hidden = true
        self.toolBarWithTrashButton.hidden = false

        // We begin with no items selected, so disable the trash button for now
        self.trashButton.enabled = false

        self.navBar.title = "Select Items"
        self.addMemeButton.enabled = false
    }

    func editModeEnd() {
        // Cancel or trash has been tapped, so set things back
        //  to how they were before Edit was tapped

        // The button should go back to saying "Edit"
        self.editButton.title = "Edit"
        self.editButton.enabled = (self.memes.count > 0)

        // hide tool bar with delete button and show tab bar
        self.tabBarController?.tabBar.hidden = false
        self.trashButton.enabled = false
        self.toolBarWithTrashButton.hidden = true

        self.navBar.title = "Sent Memes"
        self.addMemeButton.enabled = true

        // If cancel was pressed with items selected,
        //  we will "deselect" them here
        for indexPath in self.selectedIndexPaths {
            self.memeCollectionView.deselectItemAtIndexPath(indexPath, animated: false)

            if let cell = self.memeCollectionView.cellForItemAtIndexPath(indexPath) as? MemeCollectionViewCell {
                cell.setSelectionOverlayVisible(false)
            }
        }

        self.selectedIndexPaths.removeAll(keepCapacity: false)

        self.editModeEnabled = false
    }

    @IBAction func deleteButtonPressed(sender: AnyObject) {

        let appDelegate = getAppDelegate()

        // When deleting multiple memes at once,
        //    we have to delete items from the memes array in order from
        //    highest to lowest index, to prevent attempts to delete
        //    an index that is out of range.
        // Create an array with the contents of our selectedIndexPaths set.
        // Sort the array from highest to lowest item index.
        var sortedArray = Array(self.selectedIndexPaths)
        sortedArray.sort { (indexPath1 : NSIndexPath, indexPath2 : NSIndexPath) -> Bool in
            return indexPath1.item > indexPath2.item
        }

        for indexPath in sortedArray {
            appDelegate.savedMemes.removeAtIndex(indexPath.item)
            memes = appDelegate.savedMemes
        }

        self.memeCollectionView.deleteItemsAtIndexPaths( sortedArray )

        self.selectedIndexPaths.removeAll(keepCapacity: false)

        self.editModeEnd()
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {

        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionViewCellReuseId", forIndexPath: indexPath) as! MemeCollectionViewCell
        let meme = memes[indexPath.item]
        cell.imageView.image = meme.memedImage

        if self.selectedIndexPaths.contains(indexPath) {
            cell.setSelectionOverlayVisible(true)
        } else {
            cell.setSelectionOverlayVisible(false)
        }

        return cell
    }

    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {

        if self.editModeEnabled {

            let cell = collectionView.cellForItemAtIndexPath(indexPath) as! MemeCollectionViewCell

            // The cell should be selected for deletion
            cell.setSelectionOverlayVisible(true)
            self.selectedIndexPaths.insert(indexPath)

            self.trashButton.enabled = true

        } else {
            let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
            detailVC.meme = self.memes[indexPath.item]
            self.navigationController!.pushViewController(detailVC, animated: true)
        }
    }

    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        if self.editModeEnabled {
            if let cell = collectionView.cellForItemAtIndexPath(indexPath) as? MemeCollectionViewCell {
                cell.setSelectionOverlayVisible(false)
            }
            self.selectedIndexPaths.remove(indexPath)
            self.trashButton.enabled = (self.selectedIndexPaths.count > 0)
        }
    }

}
