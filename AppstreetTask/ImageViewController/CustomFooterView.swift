//
//  CustomFooterView.swift
//  AppstreetTask
//
//  Created by Manisha on 22/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//

import Foundation
import UIKit

class CustomFooterView : UICollectionReusableView {
	
	@IBOutlet weak var refreshControlIndicator: UIActivityIndicatorView!
	var isAnimatingFinal:Bool = false
	var currentTransform:CGAffineTransform?
	
	class func fromNib() -> CustomFooterView? {
		if let nibViews = Bundle.main.loadNibNamed("CustomFooterView", owner: nil, options: nil) {
			for nibView in nibViews {
				if let view = nibView as? CustomFooterView {
					return view
				}
			}
		}
		return nil
	}
	
	override func awakeFromNib() {
		super.awakeFromNib()
		self.prepareInitialAnimation()
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
	
	func setTransform(inTransform:CGAffineTransform, scaleFactor:CGFloat) {
		if isAnimatingFinal {
			return
		}
		self.currentTransform = inTransform
		self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: scaleFactor, y: scaleFactor)
	}
	
	//reset the animation
	func prepareInitialAnimation() {
		self.isAnimatingFinal = false
		self.refreshControlIndicator?.stopAnimating()
		self.refreshControlIndicator?.transform = CGAffineTransform.init(scaleX: 0.0, y: 0.0)
	}
	
	func startAnimate() {
		self.isAnimatingFinal = true
		self.refreshControlIndicator?.startAnimating()
	}
	
	func stopAnimate() {
		self.isAnimatingFinal = false
		self.refreshControlIndicator?.stopAnimating()
	}
	
	func animateFinal() {
		if isAnimatingFinal {
			return
		}
		self.isAnimatingFinal = true
		UIView.animate(withDuration: 0.2) {
			self.refreshControlIndicator?.transform = CGAffineTransform.identity
		}
	}
}
