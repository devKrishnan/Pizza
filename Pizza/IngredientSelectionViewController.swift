//
//  IngredientSelectionViewController.swift
//  Pizza
//
//  Created by radhakrishnan S on 11/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

class IngredientSelectionViewController: UITableViewController {
    var selectionDelegate : PizzaIngredientSelection?
    var variantGroupIndex : Int?
    var selectedVariantIndex : Int?
    var variantGroup : [String: Any]? = nil{
        didSet{
            if let group = variantGroup {
                variations  = group[ParsingConstants.variations] as! [Any]
                
            }
        }
    }
    var  variations : [Any] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return variations.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let variation = variations[indexPath.row] as! [String : Any]
        
        let cell : IngredientTypeCell = tableView.dequeueReusableCell(withIdentifier: "IngredientTypeCell", for: indexPath) as! IngredientTypeCell
        print(variation[ParsingConstants.price] ?? "0")
        cell.price.text = "₹ " + String(format:"%.02f",variation[ParsingConstants.price] as! Float)
        
        if let delegate = selectionDelegate, let groupIndex = variantGroupIndex{
           let enabled  = delegate.isSelectionEnabled(variation: variation, variationIndex: indexPath.row, variationId: variation[ParsingConstants.id] as! String, groupIndex : groupIndex)
            cell.isUserInteractionEnabled = enabled
            cell.stock.isEnabled = enabled
            cell.ingredient.isEnabled = enabled
            cell.price.isEnabled = enabled
            cell.selectionButton.isEnabled =  enabled
        }
        if let selectedVariant = selectedVariantIndex,  selectedVariant == indexPath.row {
            cell.selectIngredient()
        }
        cell.ingredient.text = variation[ParsingConstants.name] as? String
        cell.stock.text = "In stock: " + String(variation[ParsingConstants.inStock] as! Int)
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let variation = variations[indexPath.row] as! [String : Any]
        let cell : IngredientTypeCell = tableView.cellForRow(at: indexPath) as! IngredientTypeCell
        cell.selectIngredient()
        if let delegate = selectionDelegate, let groupIndex = variantGroupIndex{
            delegate.saveVariant(variation : variation, variationIndex: indexPath.row, groupIndex: groupIndex)
        }
        for i in 0 ..< variations.count{
            if i == indexPath.row {
                continue
            }
            let indexPath = IndexPath(row: i, section: 0)
            let cell : IngredientTypeCell = tableView.cellForRow(at: indexPath) as! IngredientTypeCell
            cell.deSelectIngredient()
        }
    }
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
