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
	let data: [[String : String]] = [[
		"name" : "iPhone 5",
		"description" : "Hello World"
	]]

	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Register the reusable product cell to the tableview
		self.tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: PRODUCT_CELL_ID)
		
		let apiManager = APIManager()
		apiManager.searchProducts(by: "apple", onPage: 1) { (error, products) in
			print("Complete!")
		}
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
