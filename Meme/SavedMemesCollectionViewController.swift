//
//  SavedMemesCollectionViewController.swift
//  MemeMe
//
//  Created by CJ Gaspari on 8/9/16.
//  Copyright © 2016 CJ Gaspari. All rights reserved.
//

import Foundation
import UIKit

class SavedMemesCollectionViewController: UICollectionViewController {
	
	@IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
	
	
	func adjustFlowLayout(size: CGSize) {
		let space = CGFloat(0.5)
		let dimension:CGFloat = size.width >= size.height ? ((size.width - (5 * space)) / 3.0) :  ((size.width - (2 * space)) / 3.0)
		
		flowLayout.minimumInteritemSpacing = space
		flowLayout.minimumLineSpacing = space
		flowLayout.itemSize = CGSizeMake(dimension, dimension)
	}
	
	var memes: [Meme] {
		return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
	}
	
	override func viewWillAppear(animated: Bool) {
		self.collectionView?.reloadData()
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		
		collectionView?.collectionViewLayout.invalidateLayout()
		adjustFlowLayout(size)

	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		adjustFlowLayout(view.frame.size)
	}
	
	override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return memes.count
	}
	
	override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let item = collectionView.dequeueReusableCellWithReuseIdentifier("MemeItem", forIndexPath: indexPath) as! SavedMemesCell
		
		let meme = memes[indexPath.item]
		
		item.imageView.image = meme.memedImage
		
		return item
	}
	
	override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
		let savedMeme = self.storyboard!.instantiateViewControllerWithIdentifier("SavedMemeDetail") as! SavedMemeDetailView
		
		savedMeme.meme = memes[indexPath.item]
		self.navigationController?.pushViewController(savedMeme, animated: true)
	}
	
	@IBAction func createMeme(){
		let createMemeController = self.storyboard!.instantiateViewControllerWithIdentifier("CreateMemeVC") as! MemeMakerViewController
		self.presentViewController(createMemeController, animated: true, completion: nil)
	}
}
