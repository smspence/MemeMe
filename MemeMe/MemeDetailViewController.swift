//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeDetailViewController : UIViewController {

    var meme : Meme!
    @IBOutlet weak var memeImageView: UIImageView!
    var navAndStatusBarHidden = false

    override func viewDidLoad() {
        super.viewDidLoad()

        var tapRecognizer = UITapGestureRecognizer(target: self, action: "handleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        tapRecognizer.numberOfTouchesRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)

        var button = UIBarButtonItem(title: "Edit", style: UIBarButtonItemStyle.Plain, target: self, action: "handleEditButton:")
        self.navigationItem.rightBarButtonItem = button
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        memeImageView.image = meme.memedImage
    }

    override func prefersStatusBarHidden() -> Bool {
        return navAndStatusBarHidden
    }

    func fadeNavAndStatusBar() {
        // Toggle the nav bar and status bar to fade in or out

        navAndStatusBarHidden = !navAndStatusBarHidden

        let alpha = navAndStatusBarHidden ? 0.0 : 1.0

        UIView.animateWithDuration(0.33)
        {
            self.setNeedsStatusBarAppearanceUpdate()
            self.navigationController!.navigationBar.alpha = CGFloat(alpha)
        }
    }

    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            fadeNavAndStatusBar()
        }
    }

    func handleEditButton(sender: UIBarButtonItem) {
        // Pass the meme that is being viewed into the meme editor

        let editorVC = self.storyboard!.instantiateViewControllerWithIdentifier("MemeEditorStoryboardId") as! MemeEditorViewController
        editorVC.memePassedIn = meme
        self.presentViewController(editorVC, animated: true, completion: nil)
    }

}
