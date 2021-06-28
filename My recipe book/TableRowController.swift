//
//  TableRowController.swift
//  My recipe book
//
//  Created by bobo on 17/06/2021.
//
import UIKit
import Foundation
class TableRowController:  UIViewController, UITableViewDelegate,UITableViewDataSource  {
    @IBOutlet weak var allRecipe: UITableView!
    var recipeList : [Recipe]!
    let cellId = "recipe"

    override func viewDidLoad() {
        super.viewDidLoad()
        recipeList = HomeController.recipeList
        setupTable()
    }
    
    func OpenRecipe(index : Int){
        UserDefaults.standard.set(self.recipeList[index].name, forKey: "name")
        UserDefaults.standard.set(self.recipeList[index].ingredients, forKey: "ingredients")
        UserDefaults.standard.set(self.recipeList[index].type, forKey: "type")

      let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecipeController") as! RecipeController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func setupTable(){
        allRecipe.delegate = self
        allRecipe.dataSource = self
    }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            OpenRecipe(index: indexPath.row)
       }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return self.recipeList.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          var cell : Cell? = self.allRecipe.dequeueReusableCell(withIdentifier: cellId) as? Cell
          
        cell?.cell_LBL_name?.text = String(recipeList[indexPath.row].name!)
          
          if(cell == nil){
              cell = Cell(style: UITableViewCell.CellStyle.default, reuseIdentifier: cellId)
          }
        return cell!
    }
}
