//
//  APIManager.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation

enum APIError: Error {
	case JSONError
}

class APIManager {
	let baseUrl = URL(string: "https://bdk0sta2n0.execute-api.eu-west-1.amazonaws.com/ios-assignment")!
	
	/// Performs a search for a given query, returning the objects on the given page.
	func searchProducts(by query: String, onPage page: Int, completion: @escaping (Error?, [Product]?, Int?) -> Void) {
		// Construct the request URL
		var requestUrlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)!
		
		requestUrlComponents.path = requestUrlComponents.path + "/search"
		
		var queryItems: [URLQueryItem] = requestUrlComponents.queryItems ??  []
		
		let queryQueryItem = URLQueryItem(name: "query", value: query)
		let pageQueryItem = URLQueryItem(name: "page", value: String(page))
		
		queryItems.append(queryQueryItem)
		queryItems.append(pageQueryItem)
		
		requestUrlComponents.queryItems = queryItems
		
		guard let requestUrl = requestUrlComponents.url else { return }
		
		// Perform data request
		let task = URLSession.shared.dataTask(with: requestUrl) {(data, response, error) in
			guard let data = data else { return }
			// Convert retrieved data to dictionary
			do {
				guard let jsonArray = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? [String : Any] else {
					completion(APIError.JSONError, nil, nil)
					return
				}
				
				guard let rawProducts = jsonArray["products"] as? [[String : AnyObject]] else {
					completion(APIError.JSONError, nil, nil)
					return
				}
				
				var products = [Product]()
				
				for rawProduct in rawProducts {
					do {
						let product = try Product(fromJson: rawProduct)
						products.append(product)
					} catch let error {
						completion(error, nil, nil)
						return
					}
				}
				
				guard let availableProducts = jsonArray["totalResults"] as? Int else {
					completion(APIError.JSONError, nil, nil)
					return
				}
				
				completion(nil, products, availableProducts)
				return
			} catch let error {
				completion(error, nil, nil)
				return
			}
		}
		
		task.resume()
	}
}
