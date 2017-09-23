//
//  ImageMainScreenController.swift
//  AppstreetTask
//
//  Created by Manisha on 21/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage


class ImageMainScreenController: UIViewController,UITextFieldDelegate{
	
	@IBOutlet var imageCollectionView: UICollectionView!
	@IBOutlet var imageSearchTextField: UITextField!
	@IBOutlet var loader: UIActivityIndicatorView!
	
	var page = 0
	var isLoading = false
	
	var imageViewToEnlarge: UIImageView?
	var superView:CGRect?
	
	var footerView:CustomFooterView?
	let footerViewReuseIdentifier = "CustomFooterView"
	
	let imageUrlArray = NSMutableArray()
	
	let APIKEY = "6513203-106452b06412a31d9835244e2"
	let BASEURL = "https://pixabay.com/api/"
	
	override func viewDidLoad() {
		super.viewDidLoad()
		imageCollectionView.delegate = self
		imageCollectionView.dataSource = self
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
		tap.cancelsTouchesInView = false
		view.addGestureRecognizer(tap)
		
		imageSearchTextField.delegate = self
		self.imageCollectionView.register(UINib(nibName: "CustomFooterView", bundle: nil), forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: footerViewReuseIdentifier)
	}
	
	func dismissKeyboard() {
		imageSearchTextField.resignFirstResponder()
	}
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		self.title = "Task"
		if loader.isAnimating{
			loader.stopAnimating()
		}
	}
	
	//MARK: MEthod to Fetch image json data from API
	func getData(){
		isLoading = true
		page = page + 1
		if let imageSearchText = imageSearchTextField.text, imageSearchText != ""{
			
			let queryItems = [URLQueryItem(name: "key" , value: self.APIKEY),
			                  URLQueryItem(name: "q" , value: imageSearchText),
			                  URLQueryItem(name: "image_type" , value: "all"),
			                  URLQueryItem(name: "page" , value: "\(page)")
			]
			
			let urlComps = NSURLComponents(string: BASEURL)!
			urlComps.queryItems = queryItems
			let URL = urlComps.url
			
			if let flickrURL = URL{
				Alamofire.request(flickrURL as URL).responseJSON(completionHandler: {(response) -> Void in
					
					if let dict = response.result.value as? NSDictionary{
							if let items = dict.value(forKey: "hits") as? NSArray{
								if items.count == 0{
									DispatchQueue.main.async(execute: {
										let alert = UIAlertController(title: "", message: "Sorry! No result found. Try with some other keyword", preferredStyle: UIAlertControllerStyle.alert)
										alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
										self.present(alert, animated: true, completion: nil)
									})
								}
								for item in items {
									let dictionaryItem = item as! NSDictionary
									
									if let url = dictionaryItem.value(forKeyPath: "previewURL") as? String {
									 self.imageUrlArray.add(url)
									}
								}
								DispatchQueue.main.async(execute: {
									if self.loader.isAnimating{
										self.loader.stopAnimating()
									}
									self.imageCollectionView.reloadData()
									self.isLoading = false
								})
							}
						}else{
						DispatchQueue.main.async(execute: {
							if self.loader.isAnimating{
								self.loader.stopAnimating()
							}
							self.isLoading = false
						})
						let alert = UIAlertController(title: "", message: "Something Unexpected occur", preferredStyle: UIAlertControllerStyle.alert)
						alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
						self.present(alert, animated: true, completion: nil)
					}
					
				})
				
			}
		}else{
			let alert = UIAlertController(title: "", message: "Enter some text to search related images", preferredStyle: UIAlertControllerStyle.alert)
			alert.addAction(UIAlertAction(title: "ok", style: UIAlertActionStyle.default, handler: nil))
			self.present(alert, animated: true, completion: nil)
			self.footerView?.stopAnimate()
			
		}
	}
	
	
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if let enlargedImageViewController = segue.destination as? EnlargedImageViewController {
			enlargedImageViewController.image = self.imageViewToEnlarge?.image
			enlargedImageViewController.frame = superView
			
		}
	}
	
	// textfield Delegate method
	func textFieldDidEndEditing(_ textField: UITextField) {
		self.loader.startAnimating()
		getData()
	}
	
	func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
		textField.resignFirstResponder()
		return true
	}
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		imageSearchTextField.resignFirstResponder()
		return true
	}
	func textFieldDidBeginEditing(_ textField: UITextField) {
		self.imageUrlArray.removeAllObjects()
		page = 0
		imageCollectionView.reloadData()
	}
	
}








