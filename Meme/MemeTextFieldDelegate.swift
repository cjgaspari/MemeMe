//
//  memeTextFieldDelegate.swift
//  Meme
//
//  Created by CJ Gaspari on 7/18/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate: NSObject, UITextFieldDelegate {
	
	func prepareTextField(textField: UITextField, defaultText: String) {
		textField.delegate = self
		textField.defaultTextAttributes = memeTextAttributes
		textField.text = defaultText
		textField.autocapitalizationType = .AllCharacters
		textField.textAlignment = .Center
	}
	
	let memeTextAttributes = [
		NSStrokeColorAttributeName: UIColor.blackColor(),
		NSForegroundColorAttributeName: UIColor.whiteColor(),
		NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName: NSNumber(int: -3)
	]
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true;
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.text = ""
	}
}