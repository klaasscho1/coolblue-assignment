//
//  ViewController.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	@IBOutlet weak var searchBar: UISearchBar!
	let PRODUCT_CELL_ID: String = "product-display"
	
	var data: [Product] = []
	var imageCacheForProductId = [Int : UIImage]()
	var pagesRetrieved = 0
	var totalProductsAvailable = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.setNavigationItem()
		
		self.reloadDataWith(query: "", forPage: 1)
	}
	
	/// Repopulate table with data from API
	func reloadDataWith(query: String, forPage page: Int) {
		let apiManager = APIManager()
		apiManager.searchProducts(by: query, onPage: page) { (error, products, availableProducts) in
			guard error == nil else {
				print("Could not retrieve products. Error: \(String(describing: error))")
				return
			}
			
			guard let products = products else {
				print("Unexpectedly found no products, no error given.")
				return
			}
			
			print("Retrieved '\(query)' products for page \(page) succesfully, repopulating table.")
			
			self.data.append(contentsOf: products)
			self.pagesRetrieved = page
			self.totalProductsAvailable = availableProducts ?? 0
			
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
		}
	}
	
	/// Set the navigation bar title view to the coolblue logo
	func setNavigationItem() {
        let imageView = UIImageView(image: UIImage(named: "CoolblueLogo"))

		imageView.contentMode = .scaleAspectFit
		
		self.navigationItem.titleView = imageView
	}


}

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

// MARK: UISearchBarDelegate

extension TableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print("Searching: \(String(describing: searchBar.text))")
		guard let searchString = searchBar.text else { return }
		
		// Reset data and pagination
		
		self.data = []
		self.pagesRetrieved = 0
		self.totalProductsAvailable = 0
		
		self.reloadDataWith(query: searchString, forPage: 1)
	}
}
