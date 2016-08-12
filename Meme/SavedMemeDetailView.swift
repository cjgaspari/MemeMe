//
//  SavedMemeDetailView.swift
//  MemeMe
//
//  Created by CJ Gaspari on 8/9/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import Foundation
import UIKit

class SavedMemeDetailView: UIViewController {
	
	var meme: Meme!
	var savedMemeIndex: Int? 
	@IBOutlet weak var savedMemeImage: UIImageView!
	
	override func viewWillAppear(animated: Bool) {
		self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: #selector(SavedMemeDetailView.editMeme))
		savedMemeImage.image = meme.memedImage
		tabBarController?.tabBar.hidden = true
	}
	
	override func viewWillDisappear(animated: Bool) {
		tabBarController?.tabBar.hidden = false
	}

	
	func editMeme() {
		let savedMeme = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! MemeMakerViewController
		savedMeme.meme = self.meme
		savedMeme.savedMemeIndex = self.savedMemeIndex
		presentViewController(savedMeme, animated: true, completion: { () -> Void in
		self.navigationController?.popToRootViewControllerAnimated(true)
		})
	}
}
