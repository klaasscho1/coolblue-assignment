//
//  TableViewController+UISearchBarDelegate.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/22/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation
import UIKit

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
