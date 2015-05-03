//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // Don't show the status bar while in the meme editor
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    // TODO - remember to enforce all-caps

}

