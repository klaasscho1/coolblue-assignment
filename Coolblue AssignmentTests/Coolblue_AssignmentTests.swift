//
//  Coolblue_AssignmentTests.swift
//  Coolblue AssignmentTests
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import XCTest
@testable import Coolblue_Assignment

class Coolblue_AssignmentTests: XCTestCase {
	var apiManager: APIManager!
	
	override func setUpWithError() throws {
		apiManager = APIManager()
	}
	
	override func tearDownWithError() throws {
		try super.tearDownWithError()
	}
	
	func testSearchRequest() throws {
		let productRetrievalExpectation = expectation(description: "productsRetrieved")
		var productResponse: [SearchQueryResponse.Product]?
		
		apiManager.searchProducts(by: "apple", onPage: 1) { (error, products, _)  in
			guard let products = products else {
				if let error = error {
					fatalError("Did not find any products, error: \(error.localizedDescription)")
				} else {
					fatalError("Unknown error trying to find products. Nothing found.")
				}
			}
			productResponse = products
			productRetrievalExpectation.fulfill()
		}
		
		waitForExpectations(timeout: 1) { (error) in
			XCTAssertNotNil(productResponse)
		}
	}
	
	func testProductParsing() throws {
		let productJsonString = """
		{
		    "productId": 785359,
		    "productName": "Apple iPhone 6 32GB Grijs",
		    "reviewInformation": {
		        "reviews": [],
		        "reviewSummary": {
		            "reviewAverage": 9.1,
		            "reviewCount": 952
		        }
		    },
		    "USPs": [
		        "32 GB opslagcapaciteit",
		        "4,7 inch Retina HD scherm",
		        "iOS 11"
		    ],
		    "availabilityState": 2,
		    "salesPriceIncVat": 369,
		    "productImage": "https://image.coolblue.nl/300x750/products/818870",
		    "coolbluesChoiceInformationTitle": "middenklasse iPhone",
		    "promoIcon": {
		        "text": "middenklasse iPhone",
		        "type": "coolblues-choice"
		    },
		    "nextDayDelivery": true
		}
		"""
		
		guard let data = productJsonString.data(using: .utf8) else {
			throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
		}
		
		let decoder = JSONDecoder()
		
		do {
			let parsedProduct = try decoder.decode(SearchQueryResponse.Product.self, from: data)
			
			XCTAssertEqual(parsedProduct.id, 785359)
			XCTAssertEqual(parsedProduct.name, "Apple iPhone 6 32GB Grijs")
			XCTAssertEqual(parsedProduct.formattedDescription(), """
			- 32 GB opslagcapaciteit
			- 4,7 inch Retina HD scherm
			- iOS 11
			""")
		} catch let error {
			fatalError(error.localizedDescription)
		}
	}
}
