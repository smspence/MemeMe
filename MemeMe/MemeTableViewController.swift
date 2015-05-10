//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, MemeDetailViewDeleteDelegate {

    var memes : [Meme]!
    var appFirstStarted = true
    @IBOutlet weak var memeTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    var detailViewIndexPath : NSIndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    func reloadTableView() {
        // Update our copy of the shared model and reload the table view
        memes = getAppDelegate().savedMemes
        self.memeTableView.reloadData()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        reloadTableView()

        editButton.enabled = (memes.count > 0)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if memes.count == 0 && self.appFirstStarted {
            self.appFirstStarted = false
            // present the meme editor
            performSegueWithIdentifier("showMemeEditorSegue", sender: self)
        }

        detailViewIndexPath = nil
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        if self.memeTableView.editing {
            self.memeTableView.setEditing(false, animated: true)
            editButton.title = "Edit"
        }
    }

    @IBAction func editButtonTapped(sender: AnyObject) {

        // Toggle edit state
        let currentEditState = self.memeTableView.editing
        let newEditState = !currentEditState

        self.memeTableView.setEditing(newEditState, animated: true)

        if newEditState {
            // We have entered Editing mode, so change button to "Done"
            editButton.title = "Done"
        } else {
            // We have exited edit mode, so change button back to "Edit"
            editButton.title = "Edit"
        }
    }

    func deleteItemFromModel(index : Int) {
        // Delete the meme from the shared model
        getAppDelegate().savedMemes.removeAtIndex(index)
        // Update our copy of the shared model
        memes = getAppDelegate().savedMemes
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // Handle deletion of meme from the model, and remove the corresponding row from the tableView

            deleteItemFromModel(indexPath.row)

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

            if memes.count == 0 {
                // Table is empty, so set Edit button back to defaults and disable editing of the table
                editButton.title = "Edit"
                editButton.enabled = false
                tableView.setEditing(false, animated: true)
            }

        default:
            return
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("MemeTableViewCellReuseId") as! UITableViewCell
        let meme = self.memes[indexPath.row]

        // Set the name and image
        cell.textLabel?.text = meme.topText + ", " + meme.bottomText
        cell.imageView?.image = meme.memedImage

        return cell
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        // Show the detail view of the selected meme

        detailViewIndexPath = indexPath

        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.item]
        detailVC.deletionDelegate = self
        detailVC.hidesBottomBarWhenPushed = true
        self.navigationController!.pushViewController(detailVC, animated: true)
    }

    func deleteMemeDetailViewItem() {
        println("In table view, deleteMemeDetailViewItem()")

        if let indexPath = detailViewIndexPath {

            deleteItemFromModel(indexPath.row)

            detailViewIndexPath = nil

        } else {
            println("!! In table view deleteMemeDetailViewItem(), detailViewIndexPath is nil !!")
        }
    }

}
