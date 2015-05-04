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
    let memeTableCellReuseId = "MemeTableViewCellReuseId"
    var appFirstStarted = true
    @IBOutlet weak var memeTableView: UITableView!

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

        self.memeTableView.reloadData()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if memes.count == 0 && self.appFirstStarted {
            self.appFirstStarted = false
            // present the meme editor
            performSegueWithIdentifier("showMemeEditorSegue", sender: self)
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier(memeTableCellReuseId) as! UITableViewCell
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
