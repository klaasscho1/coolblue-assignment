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
		
		// Set initial data to an empty search, on the first page
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
