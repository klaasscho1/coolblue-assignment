//
//  ProductTableViewCell.swift
//  Coolblue Assignment
//
//  Created by Klaas Schoenmaker on 5/21/20.
//  Copyright © 2020 Klaas Schoenmaker. All rights reserved.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
	@IBOutlet weak var productImageView: UIImageView!
	@IBOutlet weak var productNameLabel: UILabel!
	@IBOutlet weak var productReviewLabel: UILabel!
	@IBOutlet weak var productDescriptionLabel: UILabel!
	@IBOutlet weak var productPriceLabel: UILabel!
	@IBOutlet weak var productDeliveryLabel: UILabel!
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
