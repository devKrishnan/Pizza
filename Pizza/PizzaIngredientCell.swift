//
//  PizzaIngredientCell.swift
//  Pizza
//
//  Created by radhakrishnan S on 11/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class PizzaIngredientCell: UITableViewCell {
    @IBOutlet weak var ingredient: UILabel!
    @IBOutlet weak var variationName : UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}
