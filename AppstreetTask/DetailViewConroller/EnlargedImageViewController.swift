//
//  EnlargedImageViewController.swift
//  AppstreetTask
//
//  Created by Manisha on 21/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//


import UIKit

class EnlargedImageViewController: UIViewController, UIGestureRecognizerDelegate, UIScrollViewDelegate {
	
	@IBOutlet var topBar: UIView!
	@IBOutlet var backButton: UIView!
	
	@IBOutlet var backdropView: UIView!
	
	@IBOutlet var scrollView: UIScrollView!
	@IBOutlet var scrollViewTopConstraint: NSLayoutConstraint!
	@IBOutlet var scrollViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet var scrollViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet var scrollViewTrailingConstraint: NSLayoutConstraint!
	
	@IBOutlet var imageView: UIImageView!
	@IBOutlet var imageViewTopConstraint: NSLayoutConstraint!
	@IBOutlet var imageViewBottomConstraint: NSLayoutConstraint!
	@IBOutlet var imageViewLeadingConstraint: NSLayoutConstraint!
	@IBOutlet var imageViewTrailingConstraint: NSLayoutConstraint!
	@IBOutlet var imageViewVCenterConstraint: NSLayoutConstraint!
	@IBOutlet var imageViewHCenterConstraint: NSLayoutConstraint!
	
	var image:UIImage?
	var frame:CGRect?
	
	override func viewDidLoad() {
		super.viewDidLoad()
		self.backButton.isUserInteractionEnabled = true
		self.backButton.gestureRecognizers = [
			UITapGestureRecognizer(target: self, action: #selector(self.didClick(_:)))
		]
		
		self.view.isUserInteractionEnabled = true
    	self.backdropView.alpha = 0
		self.topBar.alpha = 0
		DispatchQueue.main.async(execute: {
			if let image: UIImage = self.image{
			let imageView: UIImageView = UIImageView(image: image)
			imageView.contentMode = .scaleAspectFill
			imageView.layer.masksToBounds = true
			if let r = self.frame {
				let tr = self.topBar.frame
				imageView.frame = CGRect(x: (r.minX), y: (r.minY) + tr.maxY, width: (r.width), height: (r.height))
				
				self.view.insertSubview(imageView, belowSubview: self.topBar)
				
				self.view.layoutIfNeeded()
				
				let wi = image.size.width, hi = image.size.height
				let wv = self.view.frame.width, hv = self.view.frame.height
				var width = wi >= hi ? wv : wi*hv/hi
				var height = wi >= hi ? hi*wv/wi : hv
				
				if wi < hi && width > wv {
					width = wv
					height = hi*wv/wi
				}
				
				if wi >= hi && height > hv {
					width = wi*hv/hi
					height = hv
				}
				
				let minX = (wv - width)/2
				let minY = (hv - height)/2
				
				UIView.animate(withDuration: 0.25, animations: {
					imageView.frame = CGRect(x: minX, y: minY, width: width, height: height)
					self.backdropView.alpha = 1
					self.topBar.alpha = 1
				}, completion: { finished in
					imageView.removeFromSuperview()
					
					self.imageView.image = image
					
					self.scrollView.clipsToBounds = false
					self.scrollViewLeadingConstraint.constant = minX
					self.scrollViewTrailingConstraint.constant = minX
					self.scrollViewTopConstraint.constant = minY
					self.scrollViewBottomConstraint.constant = minY
					
					self.scrollView.delegate = self
					self.scrollView.minimumZoomScale = 1.0
					self.scrollView.maximumZoomScale = 10.0
					
					self.view.bringSubview(toFront: self.topBar)
				})
			}
			}
		})
		
	}
	
	
	
	@objc func didClick(_ sender: NSObject) {
		if let sender = sender as? UITapGestureRecognizer {
			    let image = self.image
				let imageView: UIImageView = UIImageView(image: image)
				imageView.contentMode = .scaleAspectFill
				imageView.layer.masksToBounds = true
				
				if let r = self.frame,let wi = image?.size.width, let hi = image?.size.height{
					let tr = self.topBar.frame
					
					let wv = self.view.frame.width, hv = self.view.frame.height
					var width = wi >= hi ? wv : wi*hv/hi
					var height = wi >= hi ? hi*wv/wi : hv
					
					if wi < hi && width > wv {
						width = wv
						height = hi*wv/wi
					}
					
					if wi >= hi && height > hv {
						width = wi*hv/hi
						height = hv
					}
					
					let minX = (wv - width)/2
					let minY = (hv - height)/2
					
					imageView.frame = CGRect(x: minX, y: minY, width: width, height: height)
					self.view.insertSubview(imageView, belowSubview: self.topBar)
					
					self.scrollView.isHidden = true
					self.backdropView.alpha = 1
					self.topBar.alpha = 1
					
					self.view.layoutIfNeeded()
					UIView.animate(withDuration: 0.25, animations: {
						imageView.frame = CGRect(x: (r.minX), y: (r.minY), width: (r.width), height: (r.height))
						
						self.backdropView.alpha = 0
						self.topBar.alpha = 0
					}, completion: { finished in
						self.imageView.removeFromSuperview()
						self.dismiss(animated: true, completion: nil)
					})
				}else{
					self.dismiss(animated: true, completion: nil)
				}
			
		}
	}
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		
		if let image = self.image{
		let wi = image.size.width, hi = image.size.height
		let wv = size.width, hv = size.height
		
		var width = wi >= hi ? wv : wi*hv/hi
		var height = wi >= hi ? hi*wv/wi : hv
		
		if wi < hi && width > wv {
			width = wv
			height = hi*wv/wi
		}
		
		if wi >= hi && height > hv {
			width = wi*hv/hi
			height = hv
		}
		
		let minX = (wv - width)/2
		let minY = (hv - height)/2
		
		self.scrollViewLeadingConstraint.constant = minX
		self.scrollViewTrailingConstraint.constant = minX
		self.scrollViewTopConstraint.constant = minY
		self.scrollViewBottomConstraint.constant = minY
		}
	}
	
	// MARK: UIGestureRecognizerDelegate
	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
		if gestureRecognizer.view == self.view {
			if touch.view == self.topBar ||
				touch.view == self.backButton ||
				touch.view == self.scrollView{
				return false
			}
			
			return true
		}
		
		return false
	}
	
	// MARK: UIScrollViewDelegate
	func viewForZooming(in scrollView: UIScrollView) -> UIView? {
		return self.imageView
	}
}

