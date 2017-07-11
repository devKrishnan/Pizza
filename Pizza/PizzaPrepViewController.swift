//
//  PizzaPrepViewController.swift
//  Pizza
//
//  Created by radhakrishnan S on 11/07/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

protocol PizzaIngredientSelection {
    func saveVariant(variation: [String:Any],variationIndex : Int, groupIndex : Int) -> Void
    func isSelectionEnabled(variation : [String:Any],variationIndex : Int, variationId: String, groupIndex : Int )-> Bool
}
class PizzaPrepViewController: UITableViewController {
    var variants : [String : Any]  = [:]
    var groups : [[String : Any]] = [[:]]
    var groupSelectedVariantMap : [String: String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()

        var response: [String:Any]
        if let path = Bundle.main.path(forResource: "PizzaFormula", ofType: "json") {
            
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url)
                do {
                    response = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                    variants = response[ParsingConstants.variants] as! [String : Any]
                    groups = variants[ParsingConstants.variant_groups] as! [[String : Any]]
                } catch  {
                    print("exception caught")
                }
                
            } catch  {
                print("exception caught")
            }
            
        }
        
        for i in  0 ..< groups.count {
            var group : [String:Any] =  groups[i]
            group[ParsingConstants.selectedVariantIndex] = ParsingConstants.invalidIndex
            let groupID : String =  group[ParsingConstants.group_id] as! String
            groupSelectedVariantMap[groupID] = ""
            groups[i] = group
        }
        
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
        return groups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let group = groups[indexPath.row]
        let cell: PizzaIngredientCell = tableView.dequeueReusableCell(withIdentifier: "PizzaIngredientCell", for: indexPath) as! PizzaIngredientCell
        cell.ingredient.text = group[ParsingConstants.name] as? String
        let variations : [[String:Any]] =  group[ParsingConstants.variations] as! [[String : Any]]
        if let selectedIndex = group[ParsingConstants.selectedVariantIndex] as? Int, selectedIndex != ParsingConstants.invalidIndex, selectedIndex < variations.count {
            let selectedVariant = variations[selectedIndex]
            cell.variationName.text = selectedVariant[ParsingConstants.name] as? String
            cell.price.text = "₹ " + String(format:"%.02f",selectedVariant[ParsingConstants.price] as! Float)
        }

        // Configure the cell...

        return cell
    }
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let group = groups[indexPath.row]
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let selectionController : IngredientSelectionViewController = storyboard.instantiateViewController(withIdentifier: "IngredientSelectionViewController") as! IngredientSelectionViewController
        selectionController.selectionDelegate =  self
        selectionController.variantGroup = group
        selectionController.selectedVariantIndex = group[ParsingConstants.selectedVariantIndex] as? Int
        selectionController.variantGroupIndex = indexPath.row
        self.navigationController?.pushViewController(selectionController, animated: true)
        
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
    @IBAction func saveAndDismiss(_ sender: Any) {
        var allIngredientsSet = true
        for ingredient  in groupSelectedVariantMap.values{
            if (ingredient.characters.count <= 0){
                allIngredientsSet = false
                break
            }
        }
        if allIngredientsSet {
            
            self.showErrorMessage(title: "Pizza", message: "Ordered successfully", handler: { (UIAlertAction) in
                self.dismiss(animated: true, completion: {
                    
                })
            })
        }else{
            showErrorMessage(title: "Ingredients", message: "Missing")
        }
        
    }
    func showErrorMessage(title:String,message:String,handler: ((UIAlertAction) -> Swift.Void)? = nil){
        let alertController : UIAlertController = UIAlertController(title: title    , message: message, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: handler)
        alertController.addAction(action)
        present(alertController, animated: true)
    }
}

extension PizzaPrepViewController: PizzaIngredientSelection{
    func saveVariant(variation: [String:Any], variationIndex : Int, groupIndex : Int) -> Void{
        var group = groups[groupIndex]
        group[ParsingConstants.selectedVariantIndex] = variationIndex
        groups[groupIndex] = group
        let groupID : String =  group[ParsingConstants.group_id] as! String
        groupSelectedVariantMap[groupID] = variation[ParsingConstants.id] as? String
        self.tableView.reloadRows(at: [IndexPath(row: groupIndex, section: 0)], with: UITableViewRowAnimation.automatic)
    }
    func isSelectionEnabled(variation : [String:Any], variationIndex : Int , variationId: String, groupIndex : Int)-> Bool{
        var isSelectionEnabled = true
        let group = groups[groupIndex]
        let groupID = group[ParsingConstants.group_id] as! String
        
        let exclude_list = variants[ParsingConstants.exclude_list] as! [[Any]]
        for excludePair in exclude_list {
            let first : [String : String] = excludePair.first as! [String : String]
            let last : [String : String] = excludePair.last as! [String : String]
            let firstGroupID = first[ParsingConstants.group_id]
            let lastGroupID = last[ParsingConstants.group_id]
            let firstVariantID = first[ParsingConstants.variation_id]
            let lastVariantID = last[ParsingConstants.variation_id]
            
            if (firstGroupID == groupID && firstVariantID == variationId) {
                let selectedVariantID = groupSelectedVariantMap[lastGroupID!]
                if selectedVariantID == lastVariantID {
                    isSelectionEnabled = false
                    break
                }
            }else if (lastGroupID == groupID && lastVariantID == variationId){
                let selectedVariantID = groupSelectedVariantMap[firstGroupID!]
                if selectedVariantID == firstVariantID {
                    isSelectionEnabled = false
                    break
                }
            }
        }
        return isSelectionEnabled
    }
}
