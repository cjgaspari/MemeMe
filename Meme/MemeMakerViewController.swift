//
//  ViewController.swift
//  Meme
//
//  Created by CJ Gaspari on 7/18/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import UIKit

class MemeMakerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	//MARK: Variables

	@IBOutlet weak var photoView: UIImageView!
	@IBOutlet weak var shareAction: UIBarButtonItem!
	@IBOutlet weak var cancelButton: UIBarButtonItem!
	@IBOutlet weak var cameraButton: UIBarButtonItem!
	@IBOutlet weak var albumButton: UIBarButtonItem!
	@IBOutlet weak var topTextField: UITextField!
	@IBOutlet weak var bottomTextField: UITextField!
	@IBOutlet weak var topNavBar: UINavigationBar!
	@IBOutlet weak var bottomToolBar: UIToolbar!
	@IBOutlet weak var directionsLabel: UILabel!
	
	let memeTextDelegate = MemeTextFieldDelegate()
	
	var meme: Meme!
	var savedMemeIndex: Int?
	
	func configureItems(enabled: Bool){
		topTextField.hidden = enabled
		bottomTextField.hidden = enabled
		directionsLabel.hidden = !enabled
	}
	
	//MARK: UIView Stuff
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		configureItems(false)
		photoView.image = image
		
		memeTextDelegate.prepareTextField(topTextField, defaultText: "TOP")
		memeTextDelegate.prepareTextField(bottomTextField, defaultText: "BOTTOM")
		
		dismissViewControllerAnimated(true, completion: nil)
		
	}
	
	override func viewWillAppear(animated: Bool) {
		
		if meme != nil {
			photoView.image = meme.image
			configureItems(false)
			memeTextDelegate.prepareTextField(topTextField, defaultText: meme.topText)
			memeTextDelegate.prepareTextField(bottomTextField, defaultText: meme.bottomText)
			
		}
		super.viewWillAppear(true)
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		shareAction.enabled = photoView.image != nil
		cancelButton.enabled = true
		self.subscribeToKeyboardNotifications()
		
	}
	
	override func prefersStatusBarHidden() -> Bool {
		return true
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.unsubscribeFromKeyboardNotifications()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		configureItems(true)
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Meme stuff	
	func save() {
		let meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: photoView.image!, memedImage: generateMemeImage())
		
		let object = UIApplication.sharedApplication().delegate
		let appDelegate = object as! AppDelegate
		
		if savedMemeIndex != nil {
			appDelegate.memes[savedMemeIndex!] = meme
		} else {
			appDelegate.memes.append(meme)
		}
		
	}
	
	func generateMemeImage() -> UIImage {
		topNavBar.hidden = true
		bottomToolBar.hidden = true
		
		UIGraphicsBeginImageContext(self.view.frame.size)
		view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		topNavBar.hidden = false
		bottomToolBar.hidden = false
		
		return memedImage
	}
	
	func cancel() {
		dismissViewControllerAnimated(true, completion: nil)
	}
	
	//MARK: Button stuff
	enum buttonType: Int { case shareButton = 0, cancelButton, cameraButton, albumButton }
	
	@IBAction func shareButton(sender: UIBarButtonItem){
		let nextController = UIActivityViewController(activityItems: [generateMemeImage()], applicationActivities: nil)
		presentViewController(nextController, animated: true, completion: nil)
		
		nextController.completionWithItemsHandler = { (activity, success, items, error) in
			if success {
				self.save()
				self.dismissViewControllerAnimated(true, completion: nil)
			}
		}
	}
	
	@IBAction func cancelButton(sender: UIBarButtonItem){
		cancel()
	}
	
	func presentImagePicker(sourceType: UIImagePickerControllerSourceType){
		let imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		imagePicker.sourceType = sourceType
		
		if meme != nil {
			meme = nil
		}
		
		presentViewController(imagePicker, animated: true, completion: nil)
	}
	
	@IBAction func cameraButton(sender: UIBarButtonItem) {
		presentImagePicker(.Camera)

	}
	
	@IBAction func albumButton(sender: UIBarButtonItem){
		presentImagePicker(.PhotoLibrary)
	}
	
	//MARK: Keyboard Stuff
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeMakerViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(MemeMakerViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func unsubscribeFromKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
	}
	
	func getKeyboardHeight(notification: NSNotification) -> CGFloat {
		let userInfo = notification.userInfo
		let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
		return keyboardSize.CGRectValue().height
	}
	
	func keyboardWillShow(notification: NSNotification) {
		if bottomTextField.isFirstResponder() {
			self.view.frame.origin.y = -getKeyboardHeight(notification)
		}
		
	}

	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
		
	}
	
}

