//
//  ViewController.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
	let PRODUCT_CELL_ID = "productCell"
	
	// Mocking the mock data for now
	var data: [Product] = []

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register the reusable product cell to the tableview
		self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: PRODUCT_CELL_ID)
		
		self.setNavigationItem()
		
		self.repopulateWithAPI()
	}
	
	/// Repopulate table with data from API
	func repopulateWithAPI() {
		let apiManager = APIManager()
		apiManager.searchProducts(by: "apple", onPage: 1) { (error, products) in
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
			fatalError("Cell is of unexpected type.")
		}
		
		// cell.productNameLabel.text = "Hello world"

		return cell
	}
}
