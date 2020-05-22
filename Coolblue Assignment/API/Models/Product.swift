//
//  Product.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation
import UIKit

struct Product {
	let id: Int
	let name: String
	let usps: [String]
	let reviewAverage: Float
	let reviewCount: Int
	let salesPriceIncVat: Float
	let imageUrl: URL
	let nextDayDelivery: Bool
	var imageCache: UIImage?
	
	init(fromJson data: [String : AnyObject]) throws {
		self.id = data["productId"] as! Int
		self.name = data["productName"] as! String
		self.usps = data["USPs"] as! [String]
		self.reviewAverage = (((data["reviewInformation"] as! [String : AnyObject])["reviewSummary"] as! [String : AnyObject])["reviewAverage"] as! NSNumber).floatValue
		self.reviewCount = ((data["reviewInformation"] as! [String : AnyObject])["reviewSummary"] as! [String : AnyObject])["reviewCount"] as! Int
		self.salesPriceIncVat = (data["salesPriceIncVat"] as! NSNumber).floatValue
		self.imageUrl = URL(string: data["productImage"] as! String)!
		self.nextDayDelivery = data["nextDayDelivery"] as! Bool
	}
	
	func formattedDescription() -> String {
		var description = ""
		
		for usp in usps.prefix(3) {
			description += "- \(usp)\n"
		}
		
		if usps.count > 3 {
			description += "..."
		}
		
		return description
	}
	
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
