//
//  Product.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import Foundation

struct Product {
	let id: Int
	let name: String
	let usps: [String]
	let salesPriceIncVat: Float
	let imageUrl: URL
	let nextDayDelivery: Bool
	
	init(fromJson data: [String : AnyObject]) throws {
		self.id = data["productId"] as! Int
		self.name = data["productName"] as! String
		self.usps = data["USPs"] as! [String]
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
}
