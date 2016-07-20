//
//  memeTextFieldDelegate.swift
//  Meme
//
//  Created by CJ Gaspari on 7/18/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import Foundation
import UIKit

class memeTextFieldDelegate: NSObject, UITextFieldDelegate {
	
	let memeTextAttributes = [
		NSStrokeColorAttributeName: UIColor.blackColor(),
		NSForegroundColorAttributeName: UIColor.whiteColor(),
		NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
		NSStrokeWidthAttributeName: NSNumber(int: -3)
	]
	
	let alignment = ".Center"
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		
		return true;
	}
	
	func textFieldDidBeginEditing(textField: UITextField) {
		textField.text = ""
	}
}
