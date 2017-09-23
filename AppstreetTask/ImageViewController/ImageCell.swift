//
//  ImageCell.swift
//  AppstreetTask
//
//  Created by Manisha on 21/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
	
	@IBOutlet var thumbnailImageView: UIImageView!
	
	override func awakeFromNib() {
		super.awakeFromNib()
		thumbnailImageView.layer.borderWidth = 2
		thumbnailImageView.layer.borderColor = UIColor.black.cgColor
	}
	
	override func layoutSubviews() {
		super.layoutSubviews()
	}
}
