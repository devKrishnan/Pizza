//
//  IngredientTypeCell.swift
//  Pizza
//
//  Created by radhakrishnan S on 11/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class IngredientTypeCell: UITableViewCell {
    @IBOutlet weak var selectionButton: UIButton!
    @IBOutlet weak var stock: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var ingredient: UILabel!
    override var isSelected: Bool{
        didSet{
            if isSelected == true {
                self.selectIngredient()
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    
    func selectIngredient(){
        let image = UIImage(named: "selected")
        selectionButton.setBackgroundImage(image, for: UIControlState.normal)
    }
    func deSelectIngredient(){
        let image = UIImage(named: "empty")
        selectionButton.setBackgroundImage(image, for: UIControlState.normal)
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
