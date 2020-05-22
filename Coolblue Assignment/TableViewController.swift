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
	
	// Mocking the mock data for now
	var data: [Product] = []
	var imageCacheForProductId = [Int : UIImage]()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register the reusable product cell to the tableview
		//self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: PRODUCT_CELL_ID)
		
		self.setNavigationItem()
		
		self.reloadDataWith(query: "")
	}
	
	/// Repopulate table with data from API
	func reloadDataWith(query: String) {
		let apiManager = APIManager()
		apiManager.searchProducts(by: query, onPage: 1) { (error, products) in
			guard error == nil else {
				print("Could not retrieve products. Error: \(String(describing: error))")
				return
			}
			
			guard let products = products else {
				print("Unexpectedly found no products, no error given.")
				return
			}
			
			print("Retrieved products succesfully, repopulating table.")
			
			self.data = products
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
				
		cell.nameLabel.text = product.name
		cell.reviewLabel.text = "\(product.reviewAverage)/10 (\(product.reviewCount) review\(product.reviewCount > 1 ? "s" : ""))"
		cell.descriptionLabel.text = product.formattedDescription()
		cell.priceLabel.text = String(format: "%.02f", product.salesPriceIncVat)
		cell.deliveryLabel.text = product.nextDayDelivery ? "Morgen in huis" : ""
		
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
		
		return cell
	}
	
	override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		return 200
	}
}

extension TableViewController: UISearchBarDelegate {
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		print("Searching: \(String(describing: searchBar.text))")
		guard let searchString = searchBar.text else { return }
		self.reloadDataWith(query: searchString)
	}
}
