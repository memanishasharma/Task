//
//  ImageCollectionView.swift
//  AppstreetTask
//
//  Created by Manisha on 22/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//

import UIKit
import Alamofire


extension ImageMainScreenController: UICollectionViewDelegate,UICollectionViewDataSource{
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.imageUrlArray.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell",for:indexPath) as! ImageCell
		let media = imageUrlArray[indexPath.row] as! String
		if let url =  URL(string: media){
			cell.thumbnailImageView.image = UIImage(named: "ic_image_18pt")
			cell.thumbnailImageView.af_setImage(withURL: url, completion: { response in
				guard let image = response.result.value else {
					print("Error downloading image")
					return
				}
				cell.thumbnailImageView.image = image
				let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.showDetail))
				cell.gestureRecognizers = [ tapGesture ]
			})
			
		}
		return cell
	}
	
	
	func showDetail(sender: UITapGestureRecognizer){
		if let cell = sender.view as? ImageCell{
			self.imageViewToEnlarge = cell.thumbnailImageView
			self.superView = cell.superview?.convert(cell.frame, to: self.view)
			print("dframe \(self.superView)")
			self.performSegue(withIdentifier: "EnlargeImage", sender: self)
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	//Adding Footerview
	func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		if kind == UICollectionElementKindSectionFooter {
			let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
			self.footerView = aFooterView as! CustomFooterView
			self.footerView?.backgroundColor = UIColor.clear
			return aFooterView
		} else {
			let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewReuseIdentifier, for: indexPath)
			return headerView
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
		if elementKind == UICollectionElementKindSectionFooter {
			self.footerView?.prepareInitialAnimation()
		}
	}
	
	// Calculate height of bounce and show refresh control
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		let threshold   = 100.0
		let contentOffset = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let diffHeight = contentHeight - contentOffset
		let frameHeight = scrollView.bounds.size.height
		var triggerThreshold  = Float((diffHeight - frameHeight))/Float(threshold)
		triggerThreshold   =  min(triggerThreshold, 0.0)
		let pullRatio  = min(fabs(triggerThreshold),1.0)
		self.footerView?.setTransform(inTransform: CGAffineTransform.identity, scaleFactor: CGFloat(pullRatio))
		if pullRatio >= 1 {
			self.footerView?.animateFinal()
		}
		print("pullRation:\(pullRatio)")
	}
	
	func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
		let contentOffset = scrollView.contentOffset.y
		let contentHeight = scrollView.contentSize.height
		let diffHeight = contentHeight - contentOffset
		let frameHeight = scrollView.bounds.size.height
		let pullHeight  = fabs(diffHeight - frameHeight)
		print("pullHeight:\(pullHeight)")
		if pullHeight >= 0.0 {
			if (self.footerView?.isAnimatingFinal)! {
				print("load more trigger")
				getData()
				if self.isLoading{
					self.footerView?.startAnimate()
				}else{
					self.footerView?.stopAnimate()
				}
			}
		}
	}
}

