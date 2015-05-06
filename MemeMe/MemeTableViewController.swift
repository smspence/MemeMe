//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeTableViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {

    var memes : [Meme]!
    var appFirstStarted = true
    @IBOutlet weak var memeTableView: UITableView!
    @IBOutlet weak var editButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getAppDelegate() -> AppDelegate {
        return UIApplication.sharedApplication().delegate as! AppDelegate
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Get our copy of the shared model
        memes = getAppDelegate().savedMemes

        self.memeTableView.reloadData()

        self.editButton.enabled = (memes.count > 0)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if memes.count == 0 && self.appFirstStarted {
            self.appFirstStarted = false
            // present the meme editor
            performSegueWithIdentifier("showMemeEditorSegue", sender: self)
        }
    }

    // TODO - prepare for segue to meme editor, if in tableView edit mode, disable tableView edit mode

    @IBAction func editButtonTapped(sender: AnyObject) {

        // Toggle edit state
        let currentEditState = self.memeTableView.editing
        let newEditState = !currentEditState

        self.memeTableView.setEditing(newEditState, animated: true)

        if newEditState {
            editButton.title = "Done"
        } else {
            editButton.title = "Edit"
        }
    }

    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        switch editingStyle {
        case .Delete:
            // Handle deletion of meme from the model, and remove the corresponding row from the tableView

            // remove the item from the shared model, and update our copy of the shared model
            getAppDelegate().savedMemes.removeAtIndex(indexPath.row)
            memes = getAppDelegate().savedMemes

            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Left)

            if memes.count == 0 {
                // Table is empty so, set Edit button back to defaults and disable editing of the table
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

        let detailVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewStoryboardId") as! MemeDetailViewController
        detailVC.meme = self.memes[indexPath.item]
        self.navigationController!.pushViewController(detailVC, animated: true)
    }
}
