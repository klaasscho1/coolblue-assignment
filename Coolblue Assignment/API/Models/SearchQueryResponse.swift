//
//  Product.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation
import UIKit

struct SearchQueryResponse: Codable {
	var products: [Product]
	var currentPage: Int
	var pageSize: Int
	var totalResults: Int
	var pageCount: Int
	
	/// Object containing all information on a sellable product
	struct Product: Codable {
		var id: Int
		var name: String
		var usps: [String]
		var reviewInformation: ReviewInformation
		var salesPriceIncVat: Float
		var imageUrl: URL
		var nextDayDelivery: Bool
		
		struct ReviewInformation: Codable {
			var reviewSummary: ReviewSummary
			
			struct ReviewSummary: Codable {
				var reviewAverage: Float
				var reviewCount: Int
			}
		}
		
		/// Provide coding keys for consiser naming
		enum CodingKeys: String, CodingKey {
			case id = "productId"
			case name = "productName"
			case usps = "USPs"
			case reviewInformation
			case salesPriceIncVat
			case imageUrl = "productImage"
			case nextDayDelivery = "nextDayDelivery"
		}
		
		/// Returns a string-formatted version of the object's USPs
		func formattedDescription() -> String {
			var description = ""
			
			// Max out at 3 properties
			
			for usp in usps.prefix(3) {
				description += "- \(usp)\n"
			}
			
			if usps.count > 3 {
				description += "..."
			}
			
			// Trim additional whitespace
			
			return description.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		/// Returns a string-formatted version of the object's price
		func formattedPrice() -> String {
			return String(format: "%.02f", self.salesPriceIncVat).replacingOccurrences(of: ".", with: ",")
		}
		
		/// Returns a string-formatted version of the object's reviews
		func formattedReviews() -> String {
			let reviewSummary = self.reviewInformation.reviewSummary
			return "\(reviewSummary.reviewAverage)/10 (\(reviewSummary.reviewCount) review\(reviewSummary.reviewCount > 1 ? "s" : ""))"
		}
		
		/// Tries to retrieve the image defined in the object's thumbnail URL.
		func attemptRetrieveImage(completion: @escaping (UIImage) -> ()) {
			let session = URLSession(configuration: .default)

			let imageDownloadTask = session.dataTask(with: self.imageUrl) { (data, _, error) in
				
				guard let imageData = data else {
					if let e = error {
						print("Error retrieving product image: \(e)")
					} else {
						print("Unknown error retrieving product image.")
					}
					return
				}
				
				guard let image = UIImage(data: imageData) else {
					print("Error processing image.")
					return
				}
							
				completion(image)
			}
			
			imageDownloadTask.resume()
		}
	}
}
