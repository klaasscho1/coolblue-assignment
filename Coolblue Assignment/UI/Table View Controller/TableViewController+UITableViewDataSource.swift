//
//  TableViewController+UITableViewDataSource.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/22/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation
import UIKit

// MARK: UITableViewDataSource

extension TableViewController {
	override func numberOfSections(in tableView: UITableView) -> Int {
		// Only using one section, as this is just a plain tableview
		return 1
	}
	
	override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
	{
		return data.count
	}
	
	override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
	{
		guard let cell = tableView.dequeueReusableCell(withIdentifier: PRODUCT_CELL_ID, for: indexPath) as? ProductTableViewCell else {
			fatalError()
		}
		
		let product = data[indexPath.row]
		
		// Fill cell with product information
				
		cell.nameLabel.text = product.name
		cell.reviewLabel.text = product.formattedReviews()
		cell.descriptionLabel.text = product.formattedDescription()
		cell.priceLabel.text = product.formattedPrice()
		cell.deliveryLabel.text = product.nextDayDelivery ? "Morgen in huis" : ""
		
		// If thumbnail is in cache, display it, otherwise attempt to download it
		if let cachedImage = self.imageCacheForProductId[product.id] {
			cell.thumbnailImageView.image = cachedImage
		} else {
			cell.thumbnailImageView.image = nil
			
			product.attemptRetrieveImage { (image) in
				DispatchQueue.main.async {
					cell.thumbnailImageView.image = image
					self.imageCacheForProductId[product.id] = image
				}
			}
		}
		
		// If cell is the last, try to load more data
		if indexPath.row == data.count - 1 && data.count < totalProductsAvailable {
			let searchString = searchBar.text ?? ""
			reloadDataWith(query: searchString, forPage: pagesRetrieved + 1)
		}
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
	
	override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		// Automatically deselect after selection so it doesn't stay gray
		tableView.deselectRow(at: indexPath, animated: true)
	}
}
