//
//  ViewController.swift
//  Meme
//
//  Created by CJ Gaspari on 7/18/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
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
	
	let memeTextDelegate = memeTextFieldDelegate()
	
	func enableItems(bool: Bool){
		topTextField.hidden = bool
		bottomTextField.hidden = bool
		directionsLabel.hidden = !bool
	}
	
	
	//MARK: UIView Stuff
	func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
		
		enableItems(false)
		//directionsLabel.hidden = true
		photoView.image = image
		
		//Top Text Field 
		//topTextField.hidden = false
		topTextField.text = "TOP"
		topTextField.defaultTextAttributes = memeTextDelegate.memeTextAttributes
		topTextField.textAlignment = .Center	//Figure out if this can be added to the memeTextFieldDelegate
		topTextField.delegate = memeTextDelegate
		
		
		//Bottom Text Field
		//bottomTextField.hidden = false
		bottomTextField.text = "BOTTOM"
		bottomTextField.defaultTextAttributes = memeTextDelegate.memeTextAttributes
		bottomTextField.textAlignment = .Center //Figure out if this can be added to the memeTextFieldDelegate
		bottomTextField.delegate = memeTextDelegate
		
		dismissViewControllerAnimated(true, completion: nil)
		print("Picked Image")
		
	}
	
	override func viewWillAppear(animated: Bool) {
		cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
		shareAction.enabled = photoView.image != nil
		cancelButton.enabled = photoView.image != nil
		self.subscribeToKeyboardNotifications()
		
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.unsubscribeFromKeyboardNotifications()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		//topTextField.hidden = true
		//bottomTextField.hidden = true
		enableItems(true)
		
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	//MARK: Meme stuff
	
	struct Meme {
		let topText: String
		let bottomText: String
		let image: UIImage
		let memedImage: UIImage
	}
	
	func save() {
		var meme = Meme( topText: topTextField.text!, bottomText: bottomTextField.text!, image: photoView.image!, memedImage: generateMemeImage())
	}
	
	func generateMemeImage() -> UIImage {
		topNavBar.hidden = true
		bottomToolBar.hidden = true
		
		UIGraphicsBeginImageContext(self.view.frame.size)
		self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
		let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		topNavBar.hidden = false
		bottomToolBar.hidden = false
		
		return memedImage
	}
	
	func cancel() {
		photoView.image = UIImage()
		topTextField.text = ""
		bottomTextField.text = ""
		shareAction.enabled = false
		cancelButton.enabled = false
		enableItems(true)
		//topTextField.hidden = true
		//bottomTextField.hidden = true
		//directionsLabel.hidden = false
	}
	
	//MARK: Button stuff
	enum buttonType: Int { case shareButton = 0, cancelButton, cameraButton, albumButton }
	
	@IBAction func buttonClick(sender: UIBarButtonItem){
		switch buttonType(rawValue: sender.tag)! {
		case .shareButton:
			let nextController = UIActivityViewController(activityItems: [generateMemeImage()], applicationActivities: nil)
			nextController.completionWithItemsHandler = { (activity, success, items, error) in
				if success {
					self.save()
					print("saved Meme")
				}
			}
			self.presentViewController(nextController, animated: true, completion: nil)
		case .cancelButton:
			cancel()
		case .cameraButton:
			let nextController = UIImagePickerController()
			nextController.delegate = self
			nextController.sourceType = UIImagePickerControllerSourceType.Camera
			presentViewController(nextController, animated: true, completion: nil)
		case .albumButton:
			let nextController = UIImagePickerController()
			nextController.delegate = self
			nextController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
			presentViewController(nextController, animated: true, completion: nil)

		}
		
	}
	
	//MARK: Keyboard Stuff
	func subscribeToKeyboardNotifications() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
			self.view.frame.origin.y -= getKeyboardHeight(notification)
		} else if topTextField.isFirstResponder() {
			self.view.frame.origin.y = 0
		}
		
	}

	func keyboardWillHide(notification: NSNotification) {
		self.view.frame.origin.y = 0
		
	}


}

