//
//  SavedMemesViewController.swift
//  MemeMe
//
//  Created by CJ Gaspari on 8/8/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import UIKit

class SavedMemesViewController: UITableViewController {
	
	var memes: [Meme] {
		return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
	}
	
	override func viewWillAppear(animated: Bool) {
		self.tableView.reloadData()
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCellWithIdentifier("MemeCell")!
		let meme = memes[indexPath.row]
		
		cell.textLabel?.text = "\(meme.topText) ... \(meme.bottomText)"
		cell.imageView?.image = meme.memedImage
		
		return cell
		
	}
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let savedMeme = self.storyboard!.instantiateViewControllerWithIdentifier("SavedMemeDetail") as! SavedMemeDetailView
		savedMeme.meme = memes[indexPath.row]
		savedMeme.savedMemeIndex = indexPath.row
		
		self.navigationController?.pushViewController(savedMeme, animated: true)
	}
		
	@IBAction func createMeme(){
		let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! MemeMakerViewController
		self.presentViewController(createMemeController, animated: true, completion: nil)
	}

}
