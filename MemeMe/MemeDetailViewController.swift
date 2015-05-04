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

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        memeImageView.image = meme.memedImage
    }

}
