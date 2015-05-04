//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Shawn Spencer on 5/3/15.
//  Copyright (c) 2015 Shawn Spencer. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var memeEditorNavBar: UINavigationBar!
    @IBOutlet weak var memeEditorToolbar: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var memeEditorShareButton: UIBarButtonItem!

    let defaultTopText    = "TOP"
    let defaultBottomText = "BOTTOM"

    override func viewDidLoad() {
        super.viewDidLoad()

        topTextField.delegate    = self
        bottomTextField.delegate = self

        let memeTextAttributes = [
            NSStrokeColorAttributeName : UIColor.blackColor(),
            NSForegroundColorAttributeName : UIColor.whiteColor(),
            NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName : -3.0 // Negative values result in text that is both stroked and filled
        ]

        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes

        topTextField.text    = defaultTopText
        bottomTextField.text = defaultBottomText
        topTextField.textAlignment    = NSTextAlignment.Center
        bottomTextField.textAlignment = NSTextAlignment.Center
    }

    // Don't show the status bar while in the meme editor
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        // Subscribe to keyboard notification, to allow the view to be moved up when the keyboard shows
        self.subscribeToKeyboardNotifications()

        if imagePickerView.image == nil {
            memeEditorShareButton.enabled = false
        }

        // Only enable the camera button if the device has a camera
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        self.unsubscribeFromKeyboardNotifications()
    }

    func keyboardWillShow(notification: NSNotification) {
        // If the bottom text field is selected, move the view up so
        //  the bottom text will not be covered by the keyboard
        if bottomTextField.isFirstResponder() {
            // The origin (0, 0) is at the top of the screen,
            //  so subtract the height of the keyboard to move the view up
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        // If the bottom text field is selected, move the view back
        //  to its normal position
        if bottomTextField.isFirstResponder() {
            // The origin (0, 0) is at the top of the screen,
            //  so add the height of the keyboard to move the view down
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }

    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo!
        let keyboardSize = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue // of a CGRect
        return keyboardSize.CGRectValue().height
    }

    func subscribeToKeyboardNotifications() {

        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {

        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {
        // Clear the default text
        if (textField === topTextField && textField.text == defaultTopText) ||
           (textField === bottomTextField && textField.text == defaultBottomText) {
                textField.text = ""
        }
    }

    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        // Make sure the text in the text field is always all-caps

        // Figure out what the new text will be
        var newText: NSString = textField.text
        newText = newText.stringByReplacingCharactersInRange(range, withString: string)

        // Manually set the text field to the uppercase version of newText
        textField.text = newText.uppercaseString
        
        // returning false, because we manually changed the text field's text above
        return false;
    }

    @IBAction func pickAnImage(sender: AnyObject) {

        let pickerController = UIImagePickerController()
        pickerController.delegate = self

        // Figure out whether the user pressed the camera or album button
        let barButton = sender as! UIBarButtonItem
        if barButton.title == "Album" {
            println("Album selected")
            pickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        } else {
            println("Camera selected")
            pickerController.sourceType = UIImagePickerControllerSourceType.Camera
            pickerController.cameraDevice = UIImagePickerControllerCameraDevice.Rear
        }

        self.presentViewController(pickerController, animated: true, completion: nil)
    }

    func createMemedImage() -> UIImage {

        // hide toolbar and navbar so they are not shown in the meme image
        memeEditorNavBar.hidden = true
        memeEditorToolbar.hidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        // show toolbar and navbar
        memeEditorNavBar.hidden = false
        memeEditorToolbar.hidden = false

        return memedImage
    }

    func saveMeme() {

        if let originalImage = imagePickerView.image {

            let meme = Meme(topText: topTextField.text,
                            bottomText: bottomTextField.text,
                            originalImage: originalImage,
                            memedImage: self.createMemedImage() )

            // Add it to the savedMemes array in the App Delegate
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            appDelegate.savedMemes.append(meme)

            println("In saveMeme(), saved meme")
        } else {
            println("In saveMeme(), imagePickerView.image is nil")
        }
    }

    func activityCompletionHandler(activityType: String!, completed: Bool, returnedItems: [AnyObject]!, activityError: NSError!) {
        println("In activityCompletionHandler()")

        if completed {
            if activityType != nil {
                println("completed activity type \(activityType)")
            } else {
                println("completed")
            }

            if returnedItems != nil {
                println("returned \(returnedItems.count) modified items")
            }

            self.dismissViewControllerAnimated(true, completion: nil)

            self.saveMeme()

        } else {
            println("not completed")
        }

        if activityError != nil {
            println("activity error \(activityError.description) occurred")
        }
    }

    @IBAction func shareButtonPressed(sender: AnyObject) {
        println("In shareButtonPressed()")

        // Put the memed image into an array, because the activity controller expects an array as the parameter
        var imageArray = [UIImage]()
        imageArray.append( self.createMemedImage() )

        let activityVC = UIActivityViewController(activityItems: imageArray, applicationActivities: nil)
        activityVC.completionWithItemsHandler = activityCompletionHandler
        self.presentViewController(activityVC, animated: true, completion: nil)
    }

    @IBAction func cancelButtonPressed(sender: AnyObject) {
        println("In cancelButtonPressed()")
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {

        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            println("Picked image: \(info.description)")
            imagePickerView.image = pickedImage
            memeEditorShareButton.enabled = true
        } else {
            println("Image optional was nil")
        }

        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //println("User cancelled the image picker controller")
        self.dismissViewControllerAnimated(true, completion: nil)
    }

}

