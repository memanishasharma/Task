//
//  ImageCustomFlowLayout.swift
//  AppstreetTask
//
//  Created by Manisha on 22/09/17.
//  Copyright © 2017 Manisha. All rights reserved.
//

import UIKit

extension ImageMainScreenController: UICollectionViewDelegateFlowLayout {
	
	override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransition(to: size, with: coordinator)
		self.imageCollectionView.reloadData()
	}
	
	fileprivate var sectionInsets: UIEdgeInsets {
		return .zero
	}
	
	fileprivate var itemsPerRow: CGFloat {
		return 3
	}
	
	fileprivate var interitemSpace: CGFloat {
		return 5.0
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    sizeForItemAt indexPath: IndexPath) -> CGSize {
		let sectionPadding = sectionInsets.left * (itemsPerRow + 1)
		let interitemPadding = max(0.0, itemsPerRow - 1) * interitemSpace
		let availableWidth = collectionView.bounds.width - sectionPadding - interitemPadding
		let widthPerItem = availableWidth / itemsPerRow
		
		return CGSize(width: widthPerItem, height: widthPerItem)
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    insetForSectionAt section: Int) -> UIEdgeInsets {
		return sectionInsets
	}
	
	func collectionView(_ collectionView: UICollectionView,
	                    layout collectionViewLayout: UICollectionViewLayout,
	                    minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return 5.0
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return interitemSpace
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
		if isLoading {
			return CGSize.zero
		}
		return CGSize(width: collectionView.bounds.size.width, height: 55)
	}
	
}
